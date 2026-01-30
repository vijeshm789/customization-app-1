class FabricCategory {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final List<FabricFolder> folders;

  const FabricCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.folders = const [],
  });

  factory FabricCategory.fromJson(Map<String, dynamic> json) {
    return FabricCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      folders: json['folders'] != null
          ? (json['folders'] as List)
              .map((f) => FabricFolder.fromJson(f as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'folders': folders.map((f) => f.toJson()).toList(),
    };
  }

  FabricCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    List<FabricFolder>? folders,
  }) {
    return FabricCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      folders: folders ?? this.folders,
    );
  }
}

class FabricFolder {
  final String id;
  final String name;
  final String categoryId;
  final String? imageUrl;
  final int fabricCount;

  const FabricFolder({
    required this.id,
    required this.name,
    required this.categoryId,
    this.imageUrl,
    this.fabricCount = 0,
  });

  factory FabricFolder.fromJson(Map<String, dynamic> json) {
    return FabricFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String?,
      fabricCount: json['fabricCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'fabricCount': fabricCount,
    };
  }
}
