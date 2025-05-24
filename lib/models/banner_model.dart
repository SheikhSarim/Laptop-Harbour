class BannerModel {
  final String id;
  final String imageUrl;

  BannerModel({required this.id, required this.imageUrl});

  factory BannerModel.fromMap(String id, Map<String, dynamic> map) {
    return BannerModel(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
    };
  }
}
