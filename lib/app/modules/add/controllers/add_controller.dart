import 'package:e_wallet/app/data/services/google_ad_service.dart';
import 'package:e_wallet/app/data/services/local_auth_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import 'package:e_wallet/app/modules/home/controllers/home_controller.dart';
import 'package:e_wallet/app/views/views/custom_snackbars.dart';

class AddController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final currentDate = DateTime.now().obs;
  final DateFormat format = DateFormat('MM/yyyy');
  final formattedDate = ''.obs;
  final cardtype = 'Pick card type'.obs;
  final cardManufacturer = 'Pick card manufacturer'.obs;
  final screenPickerColor = ColorResourcesLight.mainLIGHTColor.obs;

  final count = 0.obs;

  @override
  final homeController = Get.put<HomeController>(HomeController());

  @override
  void onInit() {
    super.onInit();
    AdMobService().createInterAd();
  }

  void onClose() {}
  void increment() => count.value++;

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Name cannot be empty';
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
      return 'Cannot have special characters or numbers';
    }
    return null;
  }

  String? cardValidator(String? value) {
    if (value!.isEmpty) {
      return 'Card number cannot be empty';
    }
    if (RegExp(r'[a-z]').hasMatch(value)) {
      return 'Only numbers are accepted here';
    }

    if (value.length < 16) {
      return 'Cannot be less than 16 characters';
    }
    return null;
  }

  String? cvvValidator(String? value) {
    if (value!.isEmpty) {
      return 'Card number cannot be empty';
    }
    if (RegExp(r'[a-z]').hasMatch(value)) {
      return 'Only numbers are accepted here';
    }

    if (value.length < 3) {
      return 'Cannot be less than 3 characters';
    }
    return null;
  }

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
        // print('formatted date - ${formattedDate.value}');
      }
    });
  }

  void setCardType(String? newvalue) {
    cardtype.value = RxString(newvalue.toString()).toString();
    // print('selected card type - ${cardtype.value}');
  }

  void setCardManufacturer(String? newvalue) {
    cardManufacturer.value = RxString(newvalue.toString()).toString();
    // print('selected card type - ${cardManufacturer.value}');
  }

  void colorPicker(Color color) {
    screenPickerColor.value = color;
  }

  Future addCard() async {
    if (formKey.currentState!.validate()) {
      if (formattedDate.value.contains(format.format(DateTime.now())) ||
          cardtype.value.contains('Pick card type') ||
          cardManufacturer.value.contains('Pick card manufacturer')) {
        CustomSnackbar(title: 'Warning', message: 'Enter all card details')
            .showWarning();
      } else {
        // print(
        //     'Name - ${nameController.text}\nCard number - ${numberController.text}\nExp date - ${formattedDate.value}\nType - ${cardtype.value}\nManufacturer - ${cardManufacturer.value}\nCard color - ${screenPickerColor.value}');
        final card = CardModel(
            name: nameController.text,
            number: int.parse(numberController.text),
            expDate: formattedDate.value.toString(),
            cvvNumber: int.parse(cvvController.text),
            cardType: cardtype.value,
            cardManufacturer: cardManufacturer.value,
            cardColor: screenPickerColor.value.toString());

        await CardDatabase.instance.create(card).whenComplete(() {
          homeController.refreshCards();
          homeController.refresh();
          CustomSnackbar(title: 'Success', message: 'Card added successfully')
              .showSuccess();
          AdMobService().showInterad();
          scrollToAddProductPage();
          resetAddProductsDetails();
        });
        // print(homeController.cards.length.toString());
      }
    }
  }

  void resetAddProductsDetails() {
    nameController.clear();
    numberController.clear();
    formattedDate.value = format.format(DateTime.now());
    cvvController.clear();
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
