import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/views/views/custom_snackbars.dart';

class MoreController extends GetxController {
  final count = 0.obs;
  final appVersion = ''.obs;
  final isLoading = false.obs;
  final profilePicture = ''.obs;
  final editName = false.obs;
  final name = ''.obs;
  XFile? photo;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> profileNameKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initPackageInfo();
    print('profile pic - ${UserDetails().readUserProfilePicfromBox()}');
  }


  @override
  void onClose() {}
  void increment() => count.value++;

  void editNameField(bool? checkboxState) {
    editName.value = checkboxState ?? true;
    print(editName.value);
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  void saveName() {
    if (profileNameKey.currentState!.validate()) {
      print(nameController.text);
      name.value = nameController.text;
      UserDetails().saveUserNametoBox(nameController.text);
      nameController.clear();
    }
  }

  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    appVersion.value = version;
    print('app version - $version');
  }

  Future pickImage(ImageSource source) async {
    isLoading.value = true;
    try {
      final ImagePicker _picker = ImagePicker();
      photo = await _picker.pickImage(source: source);
      if (photo == null) {
        isLoading.value = false;
        Get.back();
      } else {
        // final imageTemporary = File(photo.path);
        photo = XFile(photo!.path);
        if (photo != null) {
          //? photo with file path
          print('photo file page - ${photo!.path}');
          final String profilePic = photo!.path;
          UserDetails().saveUserProfilePictoBox(profilePic);
          profilePicture.value = profilePic;

          print('profile pic - ${UserDetails().readUserProfilePicfromBox()}');
          Get.back();
        } else {
          CustomSnackbar(title: 'Warning', message: 'Failed to pick image')
              .showWarning();
          isLoading.value = false;
          Get.back();
          throw Exception();
        }
      }
    } on PlatformException catch (e) {
      Get.back();
      isLoading.value = false;

      CustomSnackbar(title: 'Warning', message: 'Failed to pick image')
          .showWarning();
      print('Failed to pick image: $e');
    }
  }
}
