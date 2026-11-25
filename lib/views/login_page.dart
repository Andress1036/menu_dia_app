import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'menu_dia_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  // Intentos fallidos seguidos en esta pantalla. Firebase no publica el límite real
  // (varía según dispositivo y red), así que esto es solo una ayuda para no insistir.
  int _intentosFallidos = 0;
  bool _verPassword = false; // false = contraseña oculta (puntos)
  bool _cargando = false; // evita pulsar "Entrar" varias veces mientras responde

  void _login() async {
    if (_cargando) return;
    setState(() => _cargando = true);
    final error = await _authController.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (!mounted) return; // 🔹 evita usar context si el widget ya no existe
    if (error == null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const MenuDiaPage()),
      );
    } else {
      setState(() {
        _cargando = false;
        _intentosFallidos++;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), duration: const Duration(seconds: 6)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login a Mr Sabor"),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Contraseña",
                // Ojo para mostrar u ocultar lo que se escribe
                suffixIcon: IconButton(
                  icon: Icon(
                    _verPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  tooltip: _verPassword
                      ? "Ocultar contraseña"
                      : "Mostrar contraseña",
                  onPressed: () =>
                      setState(() => _verPassword = !_verPassword),
                ),
              ),
              obscureText: !_verPassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargando ? null : _login,
              child: Text(_cargando ? "Entrando..." : "Entrar"),
            ),
            if (_intentosFallidos > 0) ...[
              const SizedBox(height: 16),
              Text(
                "Intentos fallidos seguidos: $_intentosFallidos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _intentosFallidos >= 3 ? Colors.red : Colors.black87,
                ),
              ),
            ],
            if (_intentosFallidos >= 3) ...[
              const SizedBox(height: 8),
              const Text(
                "Cuidado: si sigues fallando, Firebase puede bloquear el acceso "
                "temporalmente desde este dispositivo. Revisa los datos antes "
                "de volver a intentar.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
