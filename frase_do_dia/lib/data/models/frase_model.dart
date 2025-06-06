class FraseModel {
  final String texto;

  FraseModel({required this.texto});

  factory FraseModel.fromJson(Map<String, dynamic> json) {
    return FraseModel(texto: json['slip']['advice']);
  }
}
