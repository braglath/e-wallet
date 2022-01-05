import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    final isDeviceSupported = await _auth.isDeviceSupported();
    if (!isAvailable && !isDeviceSupported) {
      print(isAvailable);
      return false;
    }
    try {
      return await _auth.authenticate(
        biometricOnly: false,
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}
