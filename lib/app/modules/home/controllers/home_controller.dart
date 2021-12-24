import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  final isDarkMode = false.obs;
  final isLoading = false.obs;
  final cards = <CardModel>[].obs;

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
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
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

  void scrollToAddProductPage() {
    tabController.animateTo(
      1,
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
    isLoading.value = false;
  }


}