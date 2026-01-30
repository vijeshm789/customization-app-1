import 'garment_zone.dart';
import 'uniform_model.dart';

class SavedDesign {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UniformModel model;
  final Map<GarmentZoneType, GarmentZone> zones;
  final LogoOverlay? logoOverlay;
  final String? previewImagePath;

  const SavedDesign({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
    required this.model,
    required this.zones,
    this.logoOverlay,
    this.previewImagePath,
  });

  SavedDesign copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    UniformModel? model,
    Map<GarmentZoneType, GarmentZone>? zones,
    LogoOverlay? logoOverlay,
    String? previewImagePath,
    bool clearLogo = false,
  }) {
    return SavedDesign(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      model: model ?? this.model,
      zones: zones ?? this.zones,
      logoOverlay: clearLogo ? null : (logoOverlay ?? this.logoOverlay),
      previewImagePath: previewImagePath ?? this.previewImagePath,
    );
  }

  factory SavedDesign.fromJson(Map<String, dynamic> json) {
    return SavedDesign(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      model: UniformModel.fromJson(json['model'] as Map<String, dynamic>),
      zones: (json['zones'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          GarmentZoneType.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GarmentZoneType.body,
          ),
          GarmentZone.fromJson(value as Map<String, dynamic>),
        ),
      ),
      logoOverlay: json['logoOverlay'] != null
          ? LogoOverlay.fromJson(json['logoOverlay'] as Map<String, dynamic>)
          : null,
      previewImagePath: json['previewImagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'model': model.toJson(),
      'zones': zones.map((key, value) => MapEntry(key.name, value.toJson())),
      'logoOverlay': logoOverlay?.toJson(),
      'previewImagePath': previewImagePath,
    };
  }
}

class LogoOverlay {
  final String imagePath;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;

  const LogoOverlay({
    required this.imagePath,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0,
  });

  LogoOverlay copyWith({
    String? imagePath,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) {
    return LogoOverlay(
      imagePath: imagePath ?? this.imagePath,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
    );
  }

  factory LogoOverlay.fromJson(Map<String, dynamic> json) {
    return LogoOverlay(
      imagePath: json['imagePath'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotation,
    };
  }
}
