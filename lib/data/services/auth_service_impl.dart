import 'package:local_auth/local_auth.dart';
import '../../domain/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Future<bool> authenticate(String reason) async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        return true;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
