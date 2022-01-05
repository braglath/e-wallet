import 'package:get_storage/get_storage.dart';

class UserDetails {
  final _userNameBox = GetStorage();
  final _userProfilePicBox = GetStorage();
  final _secureModeBox = GetStorage();
  final _userNamekey = 'userName';
  final _userProfilePickey = 'userProfilePic';
  final _secureModekey = 'secureMode';

  // ? write user details

  Future<void> saveUserNametoBox(String userName) =>
      _userNameBox.write(_userNamekey, userName);

  Future<void> saveUserProfilePictoBox(String userProfilePic) =>
      _userProfilePicBox.write(_userProfilePickey, userProfilePic);

  Future<void> saveSecureMode(bool secureMode) =>
      _secureModeBox.write(_secureModekey, secureMode);

  // ? read user details

  String readUserNamefromBox() => _userNameBox.read(_userNamekey) ?? '';
  String readUserProfilePicfromBox() =>
      _userProfilePicBox.read(_userProfilePickey) ?? '';
  bool readSecureModefromBox() => _secureModeBox.read(_secureModekey) ?? false;
}
