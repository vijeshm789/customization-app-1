import 'package:flutter/material.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';
import '../models/fabric.dart';
import '../utils/model_painters.dart';

/// Widget that displays a customizable uniform model
class ModelDisplay extends StatelessWidget {
  final UniformModel? model;
  final Map<GarmentZoneType, GarmentZone> zones;
  final GarmentZoneType? selectedZone;
  final VoidCallback? onTap;
  final bool showZoneHighlight;

  const ModelDisplay({
    super.key,
    required this.model,
    required this.zones,
    this.selectedZone,
    this.onTap,
    this.showZoneHighlight = true,
  });

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return _buildPlaceholder();
    }

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return Stack(
            children: [
              // Model with applied fabrics
              Center(
                child: CustomPaint(
                  size: Size(size.width * 0.8, size.height * 0.95),
                  painter: _getPainter(),
                ),
              ),
              // Zone highlight overlay
              if (showZoneHighlight && selectedZone != null)
                _buildZoneHighlight(selectedZone!, size),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a model to start',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  CustomPainter _getPainter() {
    final zoneColors = _getZoneColors();

    switch (model!.category) {
      case ModelCategory.boys:
        if (model!.id.contains('kurta')) {
          return KurtaPajamaModelPainter(zoneColors: zoneColors);
        }
        return BoyModelPainter(zoneColors: zoneColors);
      case ModelCategory.girls:
        return GirlModelPainter(zoneColors: zoneColors);
      case ModelCategory.corporate:
        return CorporateModelPainter(zoneColors: zoneColors);
      case ModelCategory.medical:
        return MedicalModelPainter(zoneColors: zoneColors);
    }
  }

  Map<GarmentZoneType, Color> _getZoneColors() {
    final Map<GarmentZoneType, Color> colors = {};

    for (final entry in zones.entries) {
      if (entry.value.appliedFabric != null) {
        colors[entry.key] = _getFabricColor(entry.value.appliedFabric!);
      } else {
        colors[entry.key] = _getDefaultZoneColor(entry.key);
      }
    }

    return colors;
  }

  Color _getFabricColor(Fabric fabric) {
    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    final colorMap = {
      'navy': const Color(0xFF1E3A5F),
      'navy blue': const Color(0xFF1E3A5F),
      'royal blue': const Color(0xFF4169E1),
      'sky blue': const Color(0xFF87CEEB),
      'ceil blue': const Color(0xFF92A8D1),
      'caribbean blue': const Color(0xFF00CED1),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFF8F8F8),
      'bright white': const Color(0xFFFFFFFF),
      'off white': const Color(0xFFFAF0E6),
      'natural white': const Color(0xFFFDF5E6),
      'grey': const Color(0xFF9E9E9E),
      'gray': const Color(0xFF9E9E9E),
      'light grey': const Color(0xFFBDBDBD),
      'charcoal': const Color(0xFF36454F),
      'dark grey': const Color(0xFF424242),
      'steel': const Color(0xFF71797E),
      'black': const Color(0xFF212121),
      'midnight': const Color(0xFF191970),
      'onyx': const Color(0xFF353839),
      'maroon': const Color(0xFF800000),
      'burgundy': const Color(0xFF800020),
      'ruby': const Color(0xFFE0115F),
      'green': const Color(0xFF4CAF50),
      'hunter green': const Color(0xFF355E3B),
      'sage': const Color(0xFF9DC183),
      'emerald': const Color(0xFF50C878),
      'mint': const Color(0xFF98FF98),
      'olive': const Color(0xFF808000),
      'yellow': const Color(0xFFFFC107),
      'gold': const Color(0xFFFFD700),
      'topaz': const Color(0xFFFFCC00),
      'cream': const Color(0xFFFFFDD0),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
      'amethyst': const Color(0xFF9966CC),
      'regal': const Color(0xFF7851A9),
      'lavender': const Color(0xFFE6E6FA),
      'orange': const Color(0xFFFF9800),
      'peach': const Color(0xFFFFDAB9),
      'pink': const Color(0xFFE91E63),
      'soft pink': const Color(0xFFFFB6C1),
      'khaki': const Color(0xFFC3B091),
      'tan': const Color(0xFFD2B48C),
      'stone': const Color(0xFF928E85),
      'platinum': const Color(0xFFE5E4E2),
      'silver': const Color(0xFFC0C0C0),
      'pearl': const Color(0xFFF0EAD6),
      'diamond': const Color(0xFFB9F2FF),
      'sapphire': const Color(0xFF0F52BA),
      'denim': const Color(0xFF1560BD),
      'oxford': const Color(0xFF002147),
      'graphite': const Color(0xFF383838),
      'slate': const Color(0xFF708090),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default teal color for unknown fabrics
    return const Color(0xFF0D9488);
  }

  Color _getDefaultZoneColor(GarmentZoneType zone) {
    switch (zone) {
      case GarmentZoneType.collar:
        return const Color(0xFFE8E8E8);
      case GarmentZoneType.leftSleeve:
      case GarmentZoneType.rightSleeve:
        return const Color(0xFFA8C4D3);
      case GarmentZoneType.buttonStrip:
        return const Color(0xFFD0D0D0);
      case GarmentZoneType.body:
        return const Color(0xFFB8D4E3);
      case GarmentZoneType.kurta:
        return const Color(0xFFF5F5DC);
      case GarmentZoneType.pajama:
        return const Color(0xFFF5F5DC);
      case GarmentZoneType.pant:
        return const Color(0xFF4A5568);
      case GarmentZoneType.pajamaStrip:
        return const Color(0xFFD4AF37);
    }
  }

  Widget _buildZoneHighlight(GarmentZoneType zone, Size size) {
    // Simplified zone highlight - just shows a subtle indicator
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Editing: ${zone.displayName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget that displays a smaller model preview (for model selection)
class ModelPreview extends StatelessWidget {
  final UniformModel model;
  final bool isSelected;
  final VoidCallback? onTap;

  const ModelPreview({
    super.key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: CustomPaint(
            size: const Size(80, 120),
            painter: _getPreviewPainter(),
          ),
        ),
      ),
    );
  }

  CustomPainter _getPreviewPainter() {
    final defaultColors = ModelImageGenerator.defaultColors;

    switch (model.category) {
      case ModelCategory.boys:
        if (model.id.contains('kurta')) {
          return KurtaPajamaModelPainter(zoneColors: defaultColors);
        }
        return BoyModelPainter(zoneColors: defaultColors);
      case ModelCategory.girls:
        return GirlModelPainter(zoneColors: defaultColors);
      case ModelCategory.corporate:
        return CorporateModelPainter(zoneColors: defaultColors);
      case ModelCategory.medical:
        return MedicalModelPainter(zoneColors: defaultColors);
    }
  }
}
