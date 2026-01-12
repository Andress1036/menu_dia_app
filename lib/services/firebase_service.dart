import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/menu_model.dart';

class FirebaseService {
  final DatabaseReference _menuRef = FirebaseDatabase.instance.ref("menuDia");
  final DatabaseReference _imagenesRef = FirebaseDatabase.instance.ref("ListaDia");

  final FirebaseAuth _auth = FirebaseAuth.instance;


// Login
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
// Obtener menú
  Stream<MenuModel> getMenu() {
    return _menuRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        return MenuModel.fromMap(Map<String, dynamic>.from(data));
      } else {
        throw Exception("Datos de menú inválidos");
      }
    });
  }

  // Actualizar menú
  Future<void> updateMenu(MenuModel menu) async {
    await _menuRef.set(menu.toMap());
  }

  // Lista de imágenes disponibles
  Stream<List<String>> getImagenesDisponibles() {
    return _imagenesRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is List) {
        return data.whereType<String>().toList();
      } else {
        throw Exception("Datos de imágenes inválidos");
      }
    });
  }
 
}
