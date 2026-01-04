import 'dart:async';
import 'package:flutter/material.dart';
import '../controllers/menu_dia_controller.dart';
import '../models/menu_model.dart';

class MenuDiaPage extends StatefulWidget {
  const MenuDiaPage({super.key});

  @override
  State<MenuDiaPage> createState() => _MenuDiaPageState();
}

class _MenuDiaPageState extends State<MenuDiaPage> {
  final MenuDiaController _menuController = MenuDiaController();

  String bebidaDia = "bebida dia";
  String carneDia = "carne dia";
  String ensalada = "ensalada";
  String sopaDia = "sopa";

  String imagenSeleccionada = "nada";
  List<String> imagenesDisponibles = [];

  @override
  void initState() {
    super.initState();

    // Escuchar menú (posición 0 de la lista)

    _menuController.getMenu().listen((menu) {
      setState(() {
        bebidaDia = menu.bebidaDia;
        carneDia = menu.carneDia;
        ensalada = menu.ensalada;
        sopaDia = menu.sopaDia;
        imagenSeleccionada = menu.img.split("dia/").last.split(".").first;
      });
    });
    // Escuchar imágenes disponibles
    _menuController.getImagenes().listen((imagenes) {
      setState(() {
        imagenesDisponibles = imagenes;
      });
    });

    _menuController.updateMenu(
      MenuModel(
        bebidaDia: bebidaDia,
        carneDia: carneDia,
        ensalada: ensalada,
        sopaDia: sopaDia,
        img: "../../assets/fotos/dia/$imagenSeleccionada.webp"
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Menú del Día")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Row(
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
                  child: Text(bebidaDia, style: const TextStyle(fontSize: 18)),
                ),
                  ],
                ),
                
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Carne del día:",
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
                      child: Text(carneDia, style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Ensalada:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(ensalada, style: const TextStyle(fontSize: 18)),
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
                      child: Text(sopaDia, style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Imagen:",
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
                        imagenSeleccionada,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Imágenes disponibles:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    imagenesDisponibles.join(" - "),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "----------------------------------",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  "Modificación Menú Día:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Agregar bebida",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _menuController.updateMenu(
                        MenuModel(
                          bebidaDia: value,
                          carneDia: carneDia,
                          ensalada: ensalada,
                          sopaDia: sopaDia,
                          img: imagenSeleccionada,
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 10),
                Text("Elige la imagen del día:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: imagenSeleccionada,
                  hint: Text("Selecciona la imagen"),
                  items: imagenesDisponibles
                      .map(
                        (opcion) => DropdownMenuItem(
                          value: opcion,
                          child: Text(opcion),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
