import 'package:e_wallet/app/data/utils/usable_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:e_wallet/app/data/services/local_auth_api.dart';
import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/views/views/custom_snackbars.dart';

class MoreController extends GetxController {
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
  }

  void editNameField(bool? checkboxState) {
    editName.value = checkboxState ?? true;
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return AddControllerPageStrings.nameEmpty;
    }
    return null;
  }

  void saveName() {
    if (profileNameKey.currentState!.validate()) {
      name.value = nameController.text;
      UserDetails().saveUserNametoBox(nameController.text);
      nameController.clear();
    }
  }

  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    appVersion.value = version;
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
        photo = XFile(photo!.path);
        if (photo != null) {
          //? photo with file path
          final String profilePic = photo!.path;
          UserDetails().saveUserProfilePictoBox(profilePic);
          profilePicture.value = profilePic;
          Get.back();
        } else {
          CustomSnackbar(
                  title: MainStrings.warning,
                  message: MoreControllerPageStrings.failedPickImage)
              .showWarning();
          isLoading.value = false;
          Get.back();
          throw Exception();
        }
      }
    } on PlatformException catch (e) {
      Get.back();
      isLoading.value = false;

      CustomSnackbar(
              title: MainStrings.warning,
              message: '${MoreControllerPageStrings.failedPickImage}, $e')
          .showWarning();
    }
  }

  void checkFingerprint() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      checkFingerPrint.value = true;
      CustomSnackbar(
              message: MoreControllerPageStrings.fingerAuthSucc,
              title: MainStrings.success)
          .showSuccess();
      // print('Authentication Success');
    } else {
      checkFingerPrint.value = false;
      CustomSnackbar(
              message: MoreControllerPageStrings.fingerAuthErr,
              title: MainStrings.warning)
          .showWarning();
      // print('Authentication Error');
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
