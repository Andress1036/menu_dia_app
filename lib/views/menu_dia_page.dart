import 'dart:async';


import 'package:flutter/material.dart';
import 'package:menudia_app/views/login_page.dart';
import '../controllers/menu_dia_controller.dart';
import '../models/menu_model.dart';

class MenuDiaPage extends StatefulWidget {
  const MenuDiaPage({super.key});

  @override
  State<MenuDiaPage> createState() => _MenuDiaPageState();
}

class _MenuDiaPageState extends State<MenuDiaPage> {
  final MenuDiaController _menuController = MenuDiaController();
  late StreamSubscription<MenuModel> _menuSub;
  late StreamSubscription<List<String>> _imagenesSub;
  
  final TextEditingController _bebidaController = TextEditingController();
  final TextEditingController _carneController = TextEditingController();
  final TextEditingController _ensaladaController = TextEditingController();
  final TextEditingController _sopaController = TextEditingController();

  

  String bebidaDia = "";
  String carneDia = "";
  String ensalada = "";
  String sopaDia = "";

  String imagenSeleccionada = "nada";
  List<String> imagenesDisponibles = [];

  @override
  void initState() {
    super.initState();

    _menuSub = _menuController.getMenu().listen((menu) {
      if (!mounted) return;
      setState(() {
        bebidaDia = menu.bebidaDia;
        carneDia = menu.carneDia;
        ensalada = menu.ensalada;
        sopaDia = menu.sopaDia;
        imagenSeleccionada = menu.img.split("dia/").last.split(".").first;

        _bebidaController.text = menu.bebidaDia;
        _carneController.text = menu.carneDia;
        _ensaladaController.text = menu.ensalada;
        _sopaController.text = menu.sopaDia;
      });
    });
    
    // Escuchar imágenes disponibles
    _imagenesSub = _menuController.getImagenes().listen((imagenes) {
      if (!mounted) return;
      setState(() {
        imagenesDisponibles = imagenes;
      });
    });
  }

  @override
  void dispose() {
    _bebidaController.dispose();
    _carneController.dispose();
    _ensaladaController.dispose();
    _sopaController.dispose();
    _menuSub.cancel();
    _imagenesSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor Menú del Día"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await _menuController.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                /*Row(
                  children: [
                    Text(
                      "Bebida:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        bebidaDia,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Carne del día:",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          carneDia,
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                /* Row(
                  children: [
                    Text(
                      "Ensalada:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          ensalada,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Sopa del día:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        sopaDia,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Imagen:",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        imagenSeleccionada,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 15),

            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,

                  child: Text(
                    "Modificación Menú Día",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),
                Column(
                  children: [
                    TextField(
                      controller: _bebidaController,
                      decoration: InputDecoration(
                        labelText: "Bebida del día",
                        labelStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final inicio = _bebidaController.text.length > 8
                            ? 8
                            : 0;
                        // Selecciona todo el texto al tocar
                        _bebidaController.selection = TextSelection(
                          baseOffset: inicio,
                          extentOffset: _bebidaController.text.length,
                        );
                      },
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: _carneController,
                      decoration: InputDecoration(
                        labelText: "Carne del día",
                        labelStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final inicio = _carneController.text.length > 25
                            ? 25
                            : 0;
                        // Selecciona todo el texto al tocar
                        _carneController.selection = TextSelection(
                          baseOffset: inicio,
                          extentOffset: _carneController.text.length,
                        );
                      },
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: _ensaladaController,
                      decoration: InputDecoration(
                        labelText: "Ensalada",
                        labelStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final inicio = _ensaladaController.text.length > 16
                            ? 16
                            : 0;
                        // Selecciona todo el texto al tocar
                        _ensaladaController.selection = TextSelection(
                          baseOffset: inicio,
                          extentOffset: _ensaladaController.text.length,
                        );
                      },
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: _sopaController,
                      decoration: InputDecoration(
                        labelText: "Sopa del día",
                        labelStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final inicio = _sopaController.text.length > 5 ? 5 : 0;
                        // Selecciona todo el texto al tocar
                        _sopaController.selection = TextSelection(
                          baseOffset: inicio,
                          extentOffset: _sopaController.text.length,
                        );
                      },
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // 🔹 Actualizar Firebase SOLO al presionar el botón
                        _menuController.updateMenu(
                          MenuModel(
                            bebidaDia: _bebidaController.text,
                            carneDia: _carneController.text,
                            ensalada: _ensaladaController.text,
                            sopaDia: _sopaController.text,
                            img:
                                "../../assets/fotos/dia/$imagenSeleccionada.webp",
                          ),
                        );
                      },
                      child: Text(
                        "Guardar cambios",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Elige la imagen del día:",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: DropdownButton<String>(
                    value: imagenSeleccionada,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hint: Text("Selecciona la imagen"),
                    items: imagenesDisponibles
                        .map(
                          (opcion) => DropdownMenuItem(
                            value: opcion,
                            child: Center(
                              child: Text(opcion, textAlign: TextAlign.center),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      setState(() {
                        imagenSeleccionada = valor!;
                      });
                      // Aquí actualizas Firebase con el valor elegido
                      _menuController.updateMenu(
                        MenuModel(
                          bebidaDia: bebidaDia,
                          carneDia: carneDia,
                          ensalada: ensalada,
                          sopaDia: sopaDia,
                          img: "../../assets/fotos/dia/$valor.webp",
                        ),
                      );
                    },
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
