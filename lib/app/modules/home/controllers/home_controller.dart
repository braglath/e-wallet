import 'package:e_wallet/app/data/utils/usable_strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';
import 'package:e_wallet/app/data/services/local_auth_api.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/views/views/custom_snackbars.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  final isDarkMode = false.obs;
  final isLoading = false.obs;
  final cards = <CardModel>[].obs;
  final scrollController = ScrollController().obs;
  var shouldAutoscroll = false.obs;
  final DateFormat format = DateFormat(MainStrings.mmyy);
  DateTime timeBackButtonPressed = DateTime.now();
  final showCardNumber = false.obs;
  final showCvvNumber = false.obs;

  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: FaIcon(FontAwesomeIcons.home),
      text: TabNames.home,
    ),
    Tab(
      text: TabNames.add,
      icon: FaIcon(FontAwesomeIcons.plusSquare),
    ),
    Tab(
      text: TabNames.more,
      icon: FaIcon(FontAwesomeIcons.user),
    ),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    scrollController.value.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.value.removeListener(_scrollListener);
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.value.hasClients &&
        scrollController.value.position.pixels >= 150) {
      shouldAutoscroll.value = true;
    } else {
      shouldAutoscroll.value = false;
    }
  }

  void scrollToTop() {
    final double start = 0;
    scrollController.value.animateTo(start,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void scrollToBottomm() {
    scrollController.value.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  void increment() => count.value++;

  void themeSwitcher() {
    ThemeService().switchTheme();
    if (ThemeService().theme == ThemeMode.light) {
      isDarkMode.value = false;
    } else {
      isDarkMode.value = true;
    }
  }

  void scrollToAddProductPage(int i) {
    tabController.animateTo(
      i,
      duration: Duration(milliseconds: 500),
    );
  }

  Future refreshCards() async {
    isLoading.value = true;
    final cardsList = await CardDatabase.instance.readAllCards();
    cards.assignAll(cardsList);
    isLoading.value = false;
    print('cards ${cards[1].number}');
  }

  Future deleteCard(int id) async {
    isLoading.value = true;
    await CardDatabase.instance.delete(id);
    cards.removeWhere((element) => element.id == id);
    Get.back();
    CustomSnackbar(
            title: MainStrings.success,
            message: HomeControllerPageStrings.cardRemovedSucc)
        .showSuccess();
    isLoading.value = false;
  }

  Future<bool> pressBackAgainToExit() async {
    final difference = DateTime.now().difference(timeBackButtonPressed);
    final isExitWarning = difference >= Duration(seconds: 2);
    timeBackButtonPressed = DateTime.now();
    if (isExitWarning) {
      CustomSnackbar(
              title: HomeControllerPageStrings.exitingApp,
              message: HomeControllerPageStrings.pressBackAgain)
          .showWarning();
      return false;
    } else {
      Get.closeCurrentSnackbar();
      return true;
    }
  }

  void cardNumberAuthentication() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      showCardNumber.value = true;
      CustomSnackbar(
              title: MainStrings.success,
              message: HomeControllerPageStrings.cardnumberWillBeHidden)
          .showSuccess();
      Future.delayed(Duration(seconds: 5), () => showCardNumber.value = false);
      // print('Authentication Success');
    } else {
      showCardNumber.value = false;

      // print('Authentication Error');
    }
  }

  void cvvAuthentication() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      showCvvNumber.value = true;
      CustomSnackbar(
              title: MainStrings.success,
              message: HomeControllerPageStrings.cvvnumberWillBeHidden)
          .showSuccess();
      Future.delayed(Duration(seconds: 5), () => showCvvNumber.value = false);
      // print('Authentication Success');
    } else {
      showCvvNumber.value = false;
      // print('Authentication Error');
    }
  }
}
