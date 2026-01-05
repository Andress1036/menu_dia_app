class MenuModel {
  final String bebidaDia;
  final String carneDia;
  final String ensalada;
  final String sopaDia;
  final String img;

  MenuModel({
    required this.bebidaDia,
    required this.carneDia,
    required this.ensalada,
    required this.sopaDia,
    this.img = "",
  });

  factory MenuModel.fromMap(Map<dynamic, dynamic> data) {
    return MenuModel(
      bebidaDia: data["bebidaDia"] ?? "",
      carneDia: data["carneDia"] ?? "",
      ensalada: data["ensalada"] ?? "",
      sopaDia: data["sopaDia"] ?? "",
      img: data["img"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "bebidaDia": bebidaDia,
      "carneDia": carneDia,
      "ensalada": ensalada,
      "sopaDia": sopaDia,
      "img": img,
    };
  }

 
}
