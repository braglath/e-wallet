import 'package:e_wallet/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';

class AddController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final currentDate = DateTime.now().obs;
  final DateFormat format = DateFormat('MM/yyyy');
  final formattedDate = ''.obs;
  final cardtype = 'Pick card type'.obs;
  final cardManufacturer = 'Pick card manufacturer'.obs;
  final screenPickerColor = Color(0xffE45C3A).obs;

  final count = 0.obs;

  @override
  final homeController = Get.put<HomeController>(HomeController());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  Future<void> selectDate(BuildContext context) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(2050),
      initialDate: currentDate.value,
    ).then((date) {
      if (date != null) {
        currentDate.value = date;
        formattedDate.value = format.format(currentDate.value);
        print('formatted date - ${formattedDate.value}');
      }
    });
  }

  void setCardType(String? newvalue) {
    cardtype.value = RxString(newvalue.toString()).toString();
    print('selected card type - ${cardtype.value}');
  }

  void setCardManufacturer(String? newvalue) {
    cardManufacturer.value = RxString(newvalue.toString()).toString();
    print('selected card type - ${cardManufacturer.value}');
  }

  void colorPicker(Color color) {
    screenPickerColor.value = color;
  }

  Future addCard() async {
    print(
        'Name - ${nameController.text}\nCard number - ${numberController.text}\nExp date - ${formattedDate.value}\nType - ${cardtype.value}\nManufacturer - ${cardManufacturer.value}\nCard color - ${screenPickerColor.value}');
    final card = CardModel(
        name: nameController.text,
        number: int.parse(numberController.text),
        expDate: formattedDate.value.toString(),
        cardType: cardtype.value,
        cardManufacturer: cardManufacturer.value,
        cardColor: screenPickerColor.value.toString());

    await CardDatabase.instance.create(card).whenComplete(() {
      homeController.refreshCards();
      homeController.refresh();
      scrollToAddProductPage();
      resetAddProductsDetails();
    });
    print(homeController.cards.length.toString());
  }

  void resetAddProductsDetails() {
    nameController.clear();
    numberController.clear();
    formattedDate.value = format.format(DateTime.now());
    cardtype.value = 'Pick card type';
    cardManufacturer.value = 'Pick card manufacturer';
    screenPickerColor.value = Color(0xffE45C3A);
  }

  void scrollToAddProductPage() {
    homeController.tabController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
    );
  }
}
