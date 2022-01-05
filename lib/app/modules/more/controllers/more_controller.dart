import 'package:e_wallet/app/data/services/local_auth_api.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
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
  final secureModeWindow = false.obs;
  final isSecureModeOn = false.obs;
  final checkFingerPrint = false.obs;
  final name = ''.obs;
  XFile? photo;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> profileNameKey = GlobalKey<FormState>();
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    initPackageInfo();
    isSecureModeOn.value = UserDetails().readSecureModefromBox();

    // print('profile pic - ${UserDetails().readUserProfilePicfromBox()}');
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void editNameField(bool? checkboxState) {
    editName.value = checkboxState ?? true;
    // print(editName.value);
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  void saveName() {
    if (profileNameKey.currentState!.validate()) {
      // print(nameController.text);
      name.value = nameController.text;
      UserDetails().saveUserNametoBox(nameController.text);
      nameController.clear();
    }
  }

  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    appVersion.value = version;
    // print('app version - $version');
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
          // print('photo file page - ${photo!.path}');
          final String profilePic = photo!.path;
          UserDetails().saveUserProfilePictoBox(profilePic);
          profilePicture.value = profilePic;

          // print('profile pic - ${UserDetails().readUserProfilePicfromBox()}');
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

      CustomSnackbar(title: 'Warning', message: 'Failed to pick image, $e')
          .showWarning();
      // print('Failed to pick image: $e');
    }
  }

  void checkFingerprint() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      checkFingerPrint.value = true;
      CustomSnackbar(
              message: 'Fingerprint authentication successful',
              title: 'Success')
          .showSuccess();
      print('Authentication Success');
    } else {
      checkFingerPrint.value = false;
      CustomSnackbar(message: 'Fingerprint error', title: 'Success')
          .showWarning();
      print('Authentication Error');
    }
  }

  void secureModeSwitch(bool val) {
    isSecureModeOn.value = val;
    UserDetails().saveSecureMode(isSecureModeOn.value);
    if (isSecureModeOn.isTrue) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  void toggleSecureMode() {
    isSecureModeOn.toggle();
    UserDetails().saveSecureMode(isSecureModeOn.value);
    if (isSecureModeOn.isTrue) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }
}
