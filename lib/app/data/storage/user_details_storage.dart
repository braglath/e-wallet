import 'package:get_storage/get_storage.dart';

class UserDetails {
  final _userNameBox = GetStorage();
  final _userProfilePicBox = GetStorage();
  final _userNamekey = 'userName';
  final _userProfilePickey = 'userProfilePic';

  // ? write user details

  Future<void> saveUserNametoBox(String userName) =>
      _userNameBox.write(_userNamekey, userName);

  Future<void> saveUserProfilePictoBox(String userProfilePic) =>
      _userProfilePicBox.write(_userProfilePickey, userProfilePic);

  // ? read user details

  String readUserNamefromBox() => _userNameBox.read(_userNamekey) ?? '';
  String readUserProfilePicfromBox() =>
      _userProfilePicBox.read(_userProfilePickey) ?? '';
}
