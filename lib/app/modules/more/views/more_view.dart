import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import 'package:e_wallet/app/views/views/custom_bottom_sheet.dart';
import 'package:e_wallet/app/views/views/faded_scale_animation.dart';

import '../controllers/more_controller.dart';

class MoreView extends GetView<MoreController> {
  @override
  Widget build(BuildContext context) {
    // print('user profile pic ${UserDetails().readUserProfilePicfromBox()}');
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(height: 25),
            profilePick(context),
            SizedBox(height: 25),
            Obx(() {
              return ExpansionTile(
                childrenPadding: EdgeInsets.all(12),
                // backgroundColor: ThemeService().theme == ThemeMode.light
                //     ? ColorResourcesLight.mainLIGHTColor
                //     : ColorResourcesDark.mainDARKColor,
                onExpansionChanged: (value) => controller.editNameField(value),
                title: Text(
                  controller.name.value.isEmpty
                      ? UserDetails().readUserNamefromBox().isEmpty
                          ? 'Name'
                          : UserDetails().readUserNamefromBox()
                      : UserDetails().readUserNamefromBox(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                trailing: controller.editName.value
                    ? Icon(
                        Icons.cancel,
                        color: ThemeService().theme == ThemeMode.light
                            ? ColorResourcesLight.mainLIGHTColor
                            : ColorResourcesDark.mainDARKColor,
                      )
                    : Icon(
                        Icons.edit,
                        color: ThemeService().theme == ThemeMode.light
                            ? ColorResourcesLight.mainLIGHTColor
                            : ColorResourcesDark.mainDARKColor,
                      ),
                children: [
                  _name(),
                  ElevatedButton(
                      onPressed: () => controller.saveName(),
                      child: Text('Confirm'))
                ],
              );
            }),

            // Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  // Spacer(),
                  Obx(() {
                    return Text(
                      'App version - ${controller.appVersion}',
                      style: TextStyle(
                        fontSize: 20,
                        color: ThemeService().theme == ThemeMode.light
                            ? ColorResourcesLight.mainLIGHTColor
                            : Colors.white,
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget profilePick(context) {
    return FadedScaleAnimation(
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _profileImage(context),
          IconButton(
              splashRadius: 12,
              alignment: Alignment.bottomCenter,
              onPressed: () => CustomBottomSheet(
                    icon1: FontAwesomeIcons.cameraRetro,
                    icon2: FontAwesomeIcons.photoVideo,
                    title1: 'Camera',
                    titile2: 'Gallery',
                    onTap1: () => controller.pickImage(ImageSource.camera),
                    onTap2: () => controller.pickImage(ImageSource.gallery),
                  ).show(),
              icon: FaIcon(
                FontAwesomeIcons.camera,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Widget _profileImage(BuildContext context) {
    // print('user profile pic ${UserDetails().readUserProfilePicfromBox()}');

    return Obx(() {
      return InkWell(
        radius: 25,
        borderRadius: BorderRadius.circular(50),
        onTap: () => {},
        child: Hero(
          tag: 'profileicon',
          child: Center(
              child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 55,
            child: CircleAvatar(
              radius: 52,
              child: UserDetails().readUserProfilePicfromBox().isEmpty
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    )
                  : null,
              backgroundColor: ThemeService().theme == ThemeMode.light
                  ? ColorResourcesLight.mainLIGHTColor
                  : ColorResourcesDark.mainDARKColor,
              foregroundImage: controller.profilePicture.value.isEmpty
                  ? UserDetails().readUserProfilePicfromBox().isEmpty
                      ? null
                      : FileImage(
                          File(UserDetails().readUserProfilePicfromBox()),
                        )
                  : FileImage(
                      File(controller.profilePicture.value),
                    ),
            ),
          )),
        ),
      );
    });
  }

  Widget _name() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: controller.profileNameKey,
          child: TextFormField(
            cursorColor: ThemeService().theme == ThemeMode.light
                ? ColorResourcesLight.mainLIGHTColor
                : Colors.white,
            style: TextStyle(
                color: ThemeService().theme == ThemeMode.light
                    ? ColorResourcesLight.mainLIGHTColor
                    : Colors.white),
            validator: (value) => controller.nameValidator(value),
            controller: controller.nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Name',
            ),
          ),
        ),
      );
}
