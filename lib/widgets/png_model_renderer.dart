import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/fabric.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';

/// PNG-based model renderer using layered images with color blending
///
/// This approach uses:
/// 1. Base model image (skin, hair, shoes - non-customizable parts)
/// 2. Zone layer images (one per customizable zone with transparency)
/// 3. ColorFiltered widgets to apply fabric colors to each zone
/// 4. Shadow/fold overlay for realistic 3D effect
class PngModelRenderer extends StatelessWidget {
  final UniformModel model;
  final Map<GarmentZoneType, GarmentZone> zones;
  final Widget? logoOverlay;
  final GarmentZoneType? highlightedZone;

  const PngModelRenderer({
    super.key,
    required this.model,
    required this.zones,
    this.logoOverlay,
    this.highlightedZone,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
                ),
              ),
            ),

            // Model layers
            SizedBox(
              width: constraints.maxWidth * 0.85,
              height: constraints.maxHeight * 0.95,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base layer (non-customizable parts: skin, hair, shoes)
                  _buildBaseLayer(),

                  // Customizable zone layers
                  ...model.availableZones.map((zoneType) {
                    return _buildZoneLayer(zoneType);
                  }),

                  // Shadow/fold overlay for realism
                  _buildShadowOverlay(),

                  // Highlight for selected zone
                  if (highlightedZone != null)
                    _buildZoneHighlight(highlightedZone!),

                  // Logo overlay
                  if (logoOverlay != null) logoOverlay!,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBaseLayer() {
    // In production, this would be an actual PNG image
    // Image.asset('assets/images/models/${model.id}_base.png')

    // For now, using a placeholder that simulates the base layer
    return _PlaceholderModelBase(
      category: model.category,
    );
  }

  Widget _buildZoneLayer(GarmentZoneType zoneType) {
    final zone = zones[zoneType];
    final fabricColor = _getFabricColor(zone?.appliedFabric);

    // In production, load actual zone PNG:
    // final zonePath = 'assets/images/models/${model.id}_${zoneType.name}.png';

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        fabricColor,
        BlendMode.srcIn, // Applies color while preserving transparency
      ),
      child: _PlaceholderZoneLayer(
        zoneType: zoneType,
        category: model.category,
      ),
    );
  }

  Widget _buildShadowOverlay() {
    // In production, this would be a semi-transparent PNG with shadows/folds
    // Image.asset('assets/images/models/${model.id}_shadows.png')

    return Opacity(
      opacity: 0.15,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
            radius: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildZoneHighlight(GarmentZoneType zone) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Color _getFabricColor(Fabric? fabric) {
    if (fabric == null) return Colors.grey.shade300;

    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    // Extensive color mapping
    final colorMap = <String, Color>{
      'navy': const Color(0xFF1E3A5F),
      'royal blue': const Color(0xFF4169E1),
      'sky blue': const Color(0xFF87CEEB),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFF8F8F8),
      'grey': const Color(0xFF9E9E9E),
      'charcoal': const Color(0xFF36454F),
      'black': const Color(0xFF212121),
      'maroon': const Color(0xFF800000),
      'green': const Color(0xFF4CAF50),
      'yellow': const Color(0xFFFFC107),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
      'pink': const Color(0xFFE91E63),
      'orange': const Color(0xFFFF9800),
      'cream': const Color(0xFFFFFDD0),
      'khaki': const Color(0xFFC3B091),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    return const Color(0xFF0D9488);
  }
}

/// Placeholder for base model layer (skin, hair, shoes)
/// Replace with actual PNG images in production
class _PlaceholderModelBase extends StatelessWidget {
  final ModelCategory category;

  const _PlaceholderModelBase({required this.category});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 350),
      painter: _BaseModelPainter(category: category),
    );
  }
}

/// Placeholder for zone layers
/// Replace with actual PNG images in production
class _PlaceholderZoneLayer extends StatelessWidget {
  final GarmentZoneType zoneType;
  final ModelCategory category;

  const _PlaceholderZoneLayer({
    required this.zoneType,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 350),
      painter: _ZoneLayerPainter(
        zoneType: zoneType,
        category: category,
      ),
    );
  }
}

/// Paints only the base (non-customizable) parts of the model
class _BaseModelPainter extends CustomPainter {
  final ModelCategory category;

  _BaseModelPainter({required this.category});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Skin color
    paint.color = const Color(0xFFDEB887);

    // Head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 32 * scale),
        width: 50 * scale,
        height: 48 * scale,
      ),
      paint,
    );

    // Neck
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 62 * scale),
        width: 24 * scale,
        height: 16 * scale,
      ),
      paint,
    );

    // Arms (visible below sleeves)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 85 * scale, 165 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 85 * scale, 165 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );

    // Hands
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 85 * scale, 200 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 85 * scale, 200 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );

    // Hair
    paint.color = const Color(0xFF3D2314);
    final hairPath = Path()
      ..moveTo(centerX - 25 * scale, 32 * scale)
      ..quadraticBezierTo(
        centerX - 28 * scale,
        12 * scale,
        centerX,
        8 * scale,
      )
      ..quadraticBezierTo(
        centerX + 28 * scale,
        12 * scale,
        centerX + 25 * scale,
        32 * scale,
      )
      ..close();
    canvas.drawPath(hairPath, paint);

    // Shoes
    paint.color = const Color(0xFF2D2D2D);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 55 * scale, 378 * scale, 45 * scale, 18 * scale),
        Radius.circular(6 * scale),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 10 * scale, 378 * scale, 45 * scale, 18 * scale),
        Radius.circular(6 * scale),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints individual zone layers
class _ZoneLayerPainter extends CustomPainter {
  final GarmentZoneType zoneType;
  final ModelCategory category;

  _ZoneLayerPainter({
    required this.zoneType,
    required this.category,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white; // Will be color-filtered

    final centerX = size.width / 2;
    final scale = size.height / 400;

    switch (zoneType) {
      case GarmentZoneType.collar:
        _paintCollar(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.body:
      case GarmentZoneType.kurta:
        _paintBody(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.leftSleeve:
        _paintLeftSleeve(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.rightSleeve:
        _paintRightSleeve(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.pant:
      case GarmentZoneType.pajama:
        _paintPants(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.buttonStrip:
        _paintButtonStrip(canvas, centerX, scale, paint);
        break;
      case GarmentZoneType.pajamaStrip:
        _paintPajamaStrip(canvas, centerX, scale, paint);
        break;
    }
  }

  void _paintCollar(Canvas canvas, double centerX, double scale, Paint paint) {
    final path = Path()
      ..moveTo(centerX - 40 * scale, 68 * scale)
      ..lineTo(centerX - 15 * scale, 88 * scale)
      ..lineTo(centerX, 82 * scale)
      ..lineTo(centerX + 15 * scale, 88 * scale)
      ..lineTo(centerX + 40 * scale, 68 * scale)
      ..lineTo(centerX + 35 * scale, 75 * scale)
      ..lineTo(centerX, 92 * scale)
      ..lineTo(centerX - 35 * scale, 75 * scale)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintBody(Canvas canvas, double centerX, double scale, Paint paint) {
    final path = Path()
      ..moveTo(centerX - 65 * scale, 75 * scale)
      ..lineTo(centerX - 60 * scale, 210 * scale)
      ..lineTo(centerX + 60 * scale, 210 * scale)
      ..lineTo(centerX + 65 * scale, 75 * scale)
      ..lineTo(centerX + 40 * scale, 68 * scale)
      ..lineTo(centerX, 82 * scale)
      ..lineTo(centerX - 40 * scale, 68 * scale)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintLeftSleeve(Canvas canvas, double centerX, double scale, Paint paint) {
    final path = Path()
      ..moveTo(centerX - 65 * scale, 75 * scale)
      ..lineTo(centerX - 95 * scale, 140 * scale)
      ..lineTo(centerX - 82 * scale, 150 * scale)
      ..lineTo(centerX - 65 * scale, 110 * scale)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintRightSleeve(Canvas canvas, double centerX, double scale, Paint paint) {
    final path = Path()
      ..moveTo(centerX + 65 * scale, 75 * scale)
      ..lineTo(centerX + 95 * scale, 140 * scale)
      ..lineTo(centerX + 82 * scale, 150 * scale)
      ..lineTo(centerX + 65 * scale, 110 * scale)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintPants(Canvas canvas, double centerX, double scale, Paint paint) {
    // Left leg
    final leftPath = Path()
      ..moveTo(centerX - 48 * scale, 210 * scale)
      ..lineTo(centerX - 52 * scale, 378 * scale)
      ..lineTo(centerX - 12 * scale, 378 * scale)
      ..lineTo(centerX - 8 * scale, 210 * scale)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Right leg
    final rightPath = Path()
      ..moveTo(centerX + 48 * scale, 210 * scale)
      ..lineTo(centerX + 52 * scale, 378 * scale)
      ..lineTo(centerX + 12 * scale, 378 * scale)
      ..lineTo(centerX + 8 * scale, 210 * scale)
      ..close();
    canvas.drawPath(rightPath, paint);
  }

  void _paintButtonStrip(Canvas canvas, double centerX, double scale, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(centerX - 8 * scale, 92 * scale, 16 * scale, 118 * scale),
      paint,
    );
  }

  void _paintPajamaStrip(Canvas canvas, double centerX, double scale, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(centerX - 30 * scale, 208 * scale, 60 * scale, 8 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// Widget to apply fabric texture/pattern on zones
/// Uses ShaderMask for advanced pattern effects
class FabricTextureOverlay extends StatelessWidget {
  final Widget child;
  final Fabric? fabric;
  final GarmentZoneType zone;

  const FabricTextureOverlay({
    super.key,
    required this.child,
    this.fabric,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    if (fabric == null) return child;

    final patternType = _getPatternType(fabric!);

    if (patternType == 'solid') {
      return child;
    }

    return ShaderMask(
      shaderCallback: (bounds) {
        return _createPatternShader(bounds, patternType);
      },
      blendMode: BlendMode.overlay,
      child: child,
    );
  }

  String _getPatternType(Fabric fabric) {
    final name = fabric.name.toLowerCase();
    if (name.contains('stripe')) return 'stripe';
    if (name.contains('check')) return 'check';
    if (name.contains('herringbone')) return 'herringbone';
    return 'solid';
  }

  Shader _createPatternShader(Rect bounds, String patternType) {
    // Create gradient-based patterns
    switch (patternType) {
      case 'stripe':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white10,
            Colors.transparent,
            Colors.white10,
            Colors.transparent,
          ],
          stops: [0.0, 0.25, 0.5, 0.75],
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      default:
        return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ).createShader(bounds);
    }
  }
}
