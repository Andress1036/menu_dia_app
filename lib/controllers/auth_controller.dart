import '../services/firebase_service.dart';

class AuthController {
  final FirebaseService _service = FirebaseService();

  Future<bool> login(String email, String password) async {
    final user = await _service.login(email, password);
    return user != null;
  }
}
