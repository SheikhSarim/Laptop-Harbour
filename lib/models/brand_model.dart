class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;

  BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory BrandModel.fromMap(String id, Map<String, dynamic> map) {
    return BrandModel(
      id: id,
      name: map['name'] ?? 'Unknown',
      logoUrl: map['logoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (logoUrl != null) 'logoUrl': logoUrl,
    };
  }
}
