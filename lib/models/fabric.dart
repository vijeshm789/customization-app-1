class Fabric {
  final String id;
  final String name;
  final String code;
  final String imageUrl;
  final String categoryId;
  final String folderId;
  final String? description;
  final double? price;
  final List<String>? colors;
  final String? material;

  const Fabric({
    required this.id,
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.categoryId,
    required this.folderId,
    this.description,
    this.price,
    this.colors,
    this.material,
  });

  factory Fabric.fromJson(Map<String, dynamic> json) {
    return Fabric(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      folderId: json['folderId'] as String,
      description: json['description'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'] as List)
          : null,
      material: json['material'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'folderId': folderId,
      'description': description,
      'price': price,
      'colors': colors,
      'material': material,
    };
  }

  Fabric copyWith({
    String? id,
    String? name,
    String? code,
    String? imageUrl,
    String? categoryId,
    String? folderId,
    String? description,
    double? price,
    List<String>? colors,
    String? material,
  }) {
    return Fabric(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      folderId: folderId ?? this.folderId,
      description: description ?? this.description,
      price: price ?? this.price,
      colors: colors ?? this.colors,
      material: material ?? this.material,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Fabric && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
