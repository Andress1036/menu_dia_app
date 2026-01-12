import '../models/menu_model.dart';
import '../services/firebase_service.dart';

class MenuDiaController {
  final FirebaseService _service = FirebaseService();

  Stream<MenuModel> getMenu() => _service.getMenu();
  Stream<List<String>> getImagenes() => _service.getImagenesDisponibles();
 

 Future<void> updateMenu(MenuModel menu) async {
    await _service.updateMenu(menu);
 }

 Future<void> signOut() async {
  await _service.signOut();
 }
}
