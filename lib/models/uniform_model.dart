import 'garment_zone.dart';

enum ModelCategory {
  boys,
  girls,
  corporate,
  medical,
}

extension ModelCategoryExtension on ModelCategory {
  String get displayName {
    switch (this) {
      case ModelCategory.boys:
        return 'Boys';
      case ModelCategory.girls:
        return 'Girls';
      case ModelCategory.corporate:
        return 'Corporate';
      case ModelCategory.medical:
        return 'Medical';
    }
  }

  String get iconName {
    switch (this) {
      case ModelCategory.boys:
        return 'boy';
      case ModelCategory.girls:
        return 'girl';
      case ModelCategory.corporate:
        return 'corporate';
      case ModelCategory.medical:
        return 'medical';
    }
  }
}

class UniformModel {
  final String id;
  final String name;
  final ModelCategory category;
  final String imageUrl;
  final String overlayImageUrl;
  final List<GarmentZoneType> availableZones;
  final Map<GarmentZoneType, ZoneOverlayData>? zoneOverlays;

  const UniformModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.overlayImageUrl,
    required this.availableZones,
    this.zoneOverlays,
  });

  factory UniformModel.fromJson(Map<String, dynamic> json) {
    return UniformModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: ModelCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ModelCategory.boys,
      ),
      imageUrl: json['imageUrl'] as String,
      overlayImageUrl: json['overlayImageUrl'] as String,
      availableZones: (json['availableZones'] as List)
          .map((z) => GarmentZoneType.values.firstWhere(
                (e) => e.name == z,
                orElse: () => GarmentZoneType.body,
              ))
          .toList(),
      zoneOverlays: json['zoneOverlays'] != null
          ? (json['zoneOverlays'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                GarmentZoneType.values.firstWhere(
                  (e) => e.name == key,
                  orElse: () => GarmentZoneType.body,
                ),
                ZoneOverlayData.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'imageUrl': imageUrl,
      'overlayImageUrl': overlayImageUrl,
      'availableZones': availableZones.map((z) => z.name).toList(),
      'zoneOverlays': zoneOverlays?.map(
        (key, value) => MapEntry(key.name, value.toJson()),
      ),
    };
  }
}

class ZoneOverlayData {
  final double left;
  final double top;
  final double width;
  final double height;
  final String? maskImageUrl;

  const ZoneOverlayData({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.maskImageUrl,
  });

  factory ZoneOverlayData.fromJson(Map<String, dynamic> json) {
    return ZoneOverlayData(
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      maskImageUrl: json['maskImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'maskImageUrl': maskImageUrl,
    };
  }
}
