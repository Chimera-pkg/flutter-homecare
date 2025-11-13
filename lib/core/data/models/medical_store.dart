class MedicalStore {
  final int id;
  final String name;
  final double price;
  final String imgUrl;

  MedicalStore({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
  });

  factory MedicalStore.fromJson(Map<String, dynamic> json) {
    return MedicalStore(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imgUrl: json['img_url'],
    );
  }
}
