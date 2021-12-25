import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:e_wallet/app/data/utils/color_resources.dart';

class CustomSnackbar {
  String title;
  String message;
  CustomSnackbar({required this.title, required this.message});
  void showWarning() {
    Get.closeAllSnackbars();
    Get.snackbar('', '',
        isDismissible: true,
        backgroundColor:
            ColorResourcesLight.mainLIGHTAPPBARcolor.withOpacity(0.5),
        icon: CircleAvatar(
          backgroundColor: ColorResourcesLight.mainLIGHTColor,
          child: Icon(
            Icons.warning_sharp,
            color: Colors.white,
            size: 25,
          ),
        ),
        messageText: Text(message,
            style: TextStyle(
                color: ColorResourcesLight.mainTextHEADINGColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        shouldIconPulse: true,
        colorText: ColorResourcesLight.mainLIGHTColor,
        titleText: Text(title,
            style: TextStyle(
                color: ColorResourcesLight.mainTextHEADINGColor,
                fontWeight: FontWeight.bold,
                fontSize: 17)));
  }

  void showSuccess() {
    Get.closeAllSnackbars();
    Get.snackbar('', '',
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        backgroundColor:
            ColorResourcesLight.mainLIGHTAPPBARcolor.withOpacity(0.5),
        icon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: ColorResourcesLight.mainLIGHTColor,
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        messageText: Text(message,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        shouldIconPulse: true,
        colorText: ColorResourcesLight.mainLIGHTColor,
        titleText: Text(title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)));
  }
}
