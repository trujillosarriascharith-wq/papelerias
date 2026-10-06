import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Pega aquí el ID de cliente de tipo "Aplicación web"
  static const _serverClientId =
      '837703104379-ode12uta4h0ia0q46vgvnbf6uev98paa.apps.googleusercontent.com';
  static bool _inicializado = false;

  static Future<void> _init() async {
    if (_inicializado) return;
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _inicializado = true;
  }

  /// Devuelve la cuenta de Google, o null si el usuario canceló.
  static Future<GoogleSignInAccount?> iniciarSesion() async {
    await _init();
    try {
      return await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  static Future<void> cerrarSesion() async {
    await _init();
    await GoogleSignIn.instance.signOut();
  }
}