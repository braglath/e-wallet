import 'package:e_wallet/app/data/utils/usable_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/services/databse.dart';
import 'package:e_wallet/app/data/services/google_ad_service.dart';
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
  final cardtype = CardType.pickCardType.obs;
  final cardManufacturer = CardManufacturers.pickCardManufacturer.obs;
  final screenPickerColor = ColorResourcesLight.mainLIGHTColor.obs;

  @override
  final homeController = Get.put<HomeController>(HomeController());

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return AddControllerPageStrings.nameEmpty;
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
      return AddControllerPageStrings.noSpclCharc;
    }
    return null;
  }

  String? cardValidator(String? value) {
    if (value!.isEmpty) {
      return AddControllerPageStrings.nameEmpty;
    }
    if (RegExp(r'[a-z]').hasMatch(value)) {
      return AddControllerPageStrings.onlyNumbers;
    }

    if (value.length < 16) {
      return AddControllerPageStrings.noLess16Charc;
    }
    return null;
  }

  String? cvvValidator(String? value) {
    if (value!.isEmpty) {
      return AddControllerPageStrings.cvvEmpty;
    }
    if (RegExp(r'[a-z]').hasMatch(value)) {
      return AddControllerPageStrings.onlyNumbers;
    }

    if (value.length < 3) {
      return AddControllerPageStrings.noLess3Charc;
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
      print('format month - ${date?.day}');
      print('format year - ${date?.year}');
      if (date != null) {
        currentDate.value = date;
        print('format current - ${currentDate.value}');
        formattedDate.value = format.format(currentDate.value);
        print('formatted formatted - ${formattedDate.value}');
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
          cardtype.value.contains(CardType.pickCardType) ||
          cardManufacturer.value
              .contains(CardManufacturers.pickCardManufacturer)) {
        CustomSnackbar(
                title: MainStrings.warning,
                message: AddControllerPageStrings.enterAllCardDetails)
            .showWarning();
      } else {
        // print(
        //     'Name - ${nameController.text}\nCard number - ${numberController.text}\nExp date - ${formattedDate.value}\nType - ${cardtype.value}\nManufacturer - ${cardManufacturer.value}\nCard color - ${screenPickerColor.value}');
        AdMobService().createInterAd();
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
          CustomSnackbar(
                  title: MainStrings.success,
                  message: AddControllerPageStrings.cardAddedSuccess)
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
    cardtype.value = CardType.pickCardType;
    cardManufacturer.value = CardManufacturers.pickCardManufacturer;
    screenPickerColor.value = Color(0xffE45C3A);
  }

  void scrollToAddProductPage() {
    homeController.tabController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
    );
  }
}
