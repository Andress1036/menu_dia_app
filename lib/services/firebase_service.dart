import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/menu_model.dart';

class FirebaseService {
  final DatabaseReference _menuRef = FirebaseDatabase.instance.ref("menuDia");
  final DatabaseReference _imagenesRef = FirebaseDatabase.instance.ref("ListaDia");

  // Textos de "carne del día" por imagen: clave = nombre de la imagen, valor = texto.
  // OJO: el nodo en Firebase se llama "textoDia" (singular), tal como está en la consola.
  final DatabaseReference _textosRef = FirebaseDatabase.instance.ref("textoDia");

  final FirebaseAuth _auth = FirebaseAuth.instance;


// Código del último error de login (null si salió bien). Lo usa AuthController
// para mostrarle al usuario el motivo real en vez de un mensaje genérico.
 String? ultimoErrorCode;

// Login
 Future<User?> login(String? email, String? password) async {
  ultimoErrorCode = null;
  try {
    // Validaciones básicas antes de llamar a Firebase
    if (email == null || email.isEmpty) {
      ultimoErrorCode = 'email-vacio';
      throw Exception("El correo no puede estar vacío");
    }
    if (password == null || password.isEmpty) {
      ultimoErrorCode = 'password-vacio';
      throw Exception("La contraseña no puede estar vacía");
    }

    // Intentar login con Firebase
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    return credential.user;
  } on FirebaseAuthException catch (e) {
    // Errores específicos de Firebase
    ultimoErrorCode = e.code;
    if (e.code == 'user-not-found') {
      print("No existe un usuario con ese correo.");
    } else if (e.code == 'wrong-password') {
      print("Contraseña incorrecta.");
    } else if (e.code == 'invalid-email') {
      print("Formato de correo inválido.");
    } else {
      print("Error de autenticación: ${e.code}");
    }
    return null;
  } catch (e) {
    // Cualquier otro error inesperado
    ultimoErrorCode ??= 'desconocido';
    print("Error inesperado: $e");
    return null;
  }
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

  // Textos asociados a cada imagen (nodo "textoDia"). Si no existe, devuelve un mapa vacío.
  Stream<Map<String, String>> getTextosDia() {
    return _textosRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        return data.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
      return <String, String>{};
    });
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
