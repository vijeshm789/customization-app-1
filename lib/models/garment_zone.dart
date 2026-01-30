import 'fabric.dart';

enum GarmentZoneType {
  collar,
  leftSleeve,
  rightSleeve,
  buttonStrip,
  body,
  kurta,
  pajama,
  pant,
  pajamaStrip,
}

extension GarmentZoneTypeExtension on GarmentZoneType {
  String get displayName {
    switch (this) {
      case GarmentZoneType.collar:
        return 'Collar';
      case GarmentZoneType.leftSleeve:
        return 'Left Sleeve';
      case GarmentZoneType.rightSleeve:
        return 'Right Sleeve';
      case GarmentZoneType.buttonStrip:
        return 'Button Strip';
      case GarmentZoneType.body:
        return 'Body';
      case GarmentZoneType.kurta:
        return 'Kurta';
      case GarmentZoneType.pajama:
        return 'Pajama';
      case GarmentZoneType.pant:
        return 'Pant';
      case GarmentZoneType.pajamaStrip:
        return 'Pajama Strip';
    }
  }

  String get iconName {
    switch (this) {
      case GarmentZoneType.collar:
        return 'collar';
      case GarmentZoneType.leftSleeve:
        return 'left_sleeve';
      case GarmentZoneType.rightSleeve:
        return 'right_sleeve';
      case GarmentZoneType.buttonStrip:
        return 'button_strip';
      case GarmentZoneType.body:
        return 'body';
      case GarmentZoneType.kurta:
        return 'kurta';
      case GarmentZoneType.pajama:
        return 'pajama';
      case GarmentZoneType.pant:
        return 'pant';
      case GarmentZoneType.pajamaStrip:
        return 'pajama_strip';
    }
  }
}

class GarmentZone {
  final GarmentZoneType type;
  final Fabric? appliedFabric;
  final bool isAvailable;

  const GarmentZone({
    required this.type,
    this.appliedFabric,
    this.isAvailable = true,
  });

  GarmentZone copyWith({
    GarmentZoneType? type,
    Fabric? appliedFabric,
    bool? isAvailable,
    bool clearFabric = false,
  }) {
    return GarmentZone(
      type: type ?? this.type,
      appliedFabric: clearFabric ? null : (appliedFabric ?? this.appliedFabric),
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'appliedFabric': appliedFabric?.toJson(),
      'isAvailable': isAvailable,
    };
  }

  factory GarmentZone.fromJson(Map<String, dynamic> json) {
    return GarmentZone(
      type: GarmentZoneType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GarmentZoneType.body,
      ),
      appliedFabric: json['appliedFabric'] != null
          ? Fabric.fromJson(json['appliedFabric'] as Map<String, dynamic>)
          : null,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }
}
