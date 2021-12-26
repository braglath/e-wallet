import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/views/views/custom_snackbars.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  final isDarkMode = false.obs;
  final isLoading = false.obs;
  final cards = <CardModel>[].obs;
  final scrollController = ScrollController().obs;
  var shouldAutoscroll = false.obs;
  final DateFormat format = DateFormat('MM/yyyy');
  DateTime timeBackButtonPressed = DateTime.now();

  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: FaIcon(FontAwesomeIcons.home),
      text: 'Home',
    ),
    Tab(
      text: 'Add',
      icon: FaIcon(FontAwesomeIcons.plusSquare),
    ),
    Tab(
      text: 'More',
      icon: FaIcon(FontAwesomeIcons.user),
    ),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    scrollController.value.addListener(_scrollListener);
    // print('profile pic - ${UserDetails().readUserProfilePicfromBox()}');
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
      print(
          'scrollController value - ${scrollController.value.position.pixels}');
    } else {
      shouldAutoscroll.value = false;
    }
  }

  void scrollToTop() {
    final double start = 0;
    scrollController.value.animateTo(start,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    print(scrollController.value);
  }

  void scrollToBottomm() {
    scrollController.value.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
    print(scrollController.value);
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
  }

  Future deleteCard(int id) async {
    print(id);
    isLoading.value = true;
    await CardDatabase.instance.delete(id);
    cards.removeWhere((element) => element.id == id);
    Get.back();
    CustomSnackbar(title: 'Success', message: 'Card removed successfully')
        .showSuccess();
    isLoading.value = false;
  }

  Future<bool> pressBackAgainToExit() async {
    final difference = DateTime.now().difference(timeBackButtonPressed);
    final isExitWarning = difference >= Duration(seconds: 2);
    timeBackButtonPressed = DateTime.now();
    if (isExitWarning) {
      CustomSnackbar(
              title: 'Exiting the app',
              message: 'Press back button again to exit the app')
          .showWarning();
      return false;
    } else {
      Get.closeCurrentSnackbar();
      return true;
    }
  }
}
