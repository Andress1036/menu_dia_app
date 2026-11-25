import '../services/firebase_service.dart';

class AuthController {
  final FirebaseService _service = FirebaseService();

  /// Devuelve null si el login salió bien, o el mensaje del error para mostrarlo.
  Future<String?> login(String email, String password) async {
    final user = await _service.login(email, password);
    if (user != null) return null;
    return _mensajeDeError(_service.ultimoErrorCode);
  }

  String _mensajeDeError(String? code) {
    switch (code) {
      case 'email-vacio':
        return "Escribe el correo.";
      case 'password-vacio':
        return "Escribe la contraseña.";
      case 'invalid-email':
        return "El correo no tiene un formato válido.";
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return "Correo o contraseña incorrectos.";
      case 'user-disabled':
        return "Esta cuenta está deshabilitada.";
      case 'too-many-requests':
        return "Demasiados intentos fallidos: Firebase bloqueó el acceso "
            "temporalmente desde este dispositivo. Espera un rato (de minutos "
            "a horas) o prueba desde otra red, y no sigas insistiendo.";
      case 'network-request-failed':
        return "Sin conexión a internet.";
      default:
        return "Error al iniciar sesión${code == null ? '' : ' ($code)'}.";
    }
  }
}
