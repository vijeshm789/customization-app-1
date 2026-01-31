import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/fabric.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';

/// Production-ready SVG-based model renderer using layered images with color blending
///
/// This approach uses:
/// 1. Base model SVG (skin, hair, shoes - non-customizable parts)
/// 2. Zone layer SVGs (one per customizable zone)
/// 3. ColorFiltered widgets to apply fabric colors to each zone
/// 4. Shadow/fold overlay for realistic 3D effect
class SvgModelRenderer extends StatelessWidget {
  final UniformModel model;
  final Map<GarmentZoneType, GarmentZone> zones;
  final Widget? logoOverlay;
  final GarmentZoneType? highlightedZone;
  final bool showZoneLabels;

  const SvgModelRenderer({
    super.key,
    required this.model,
    required this.zones,
    this.logoOverlay,
    this.highlightedZone,
    this.showZoneLabels = false,
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

                  // Customizable zone layers (rendered in specific order)
                  ..._getOrderedZones().map((zoneType) {
                    return _buildZoneLayer(zoneType);
                  }),

                  // Shadow/fold overlay for realism
                  _buildShadowOverlay(),

                  // Highlight for selected zone
                  if (highlightedZone != null)
                    _buildZoneHighlight(highlightedZone!),

                  // Zone labels (for debugging/development)
                  if (showZoneLabels) _buildZoneLabels(),

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

  /// Returns zones in correct render order (back to front)
  List<GarmentZoneType> _getOrderedZones() {
    final renderOrder = <GarmentZoneType>[];
    final availableZones = model.availableZones;

    // Define render order: body first, then details on top
    const zoneOrder = [
      GarmentZoneType.body,
      GarmentZoneType.kurta,
      GarmentZoneType.pant,
      GarmentZoneType.pajama,
      GarmentZoneType.leftSleeve,
      GarmentZoneType.rightSleeve,
      GarmentZoneType.collar,
      GarmentZoneType.buttonStrip,
      GarmentZoneType.pajamaStrip,
    ];

    for (final zone in zoneOrder) {
      if (availableZones.contains(zone)) {
        renderOrder.add(zone);
      }
    }

    return renderOrder;
  }

  Widget _buildBaseLayer() {
    final categoryPrefix = _getCategoryPrefix();
    final basePath = 'assets/images/models/${categoryPrefix}_base.svg';

    return SvgPicture.asset(
      basePath,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => _buildPlaceholderBase(),
    );
  }

  Widget _buildZoneLayer(GarmentZoneType zoneType) {
    final zone = zones[zoneType];
    final fabricColor = _getFabricColor(zone?.appliedFabric);
    final categoryPrefix = _getCategoryPrefix();
    final zoneName = _getZoneSvgName(zoneType);
    final zonePath = 'assets/images/models/${categoryPrefix}_$zoneName.svg';

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        fabricColor,
        BlendMode.srcIn, // Applies color while preserving transparency
      ),
      child: SvgPicture.asset(
        zonePath,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildShadowOverlay() {
    final categoryPrefix = _getCategoryPrefix();
    final shadowPath = 'assets/images/models/${categoryPrefix}_shadows.svg';

    return Opacity(
      opacity: 0.8,
      child: SvgPicture.asset(
        shadowPath,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildZoneHighlight(GarmentZoneType zone) {
    final categoryPrefix = _getCategoryPrefix();
    final zoneName = _getZoneSvgName(zone);
    final zonePath = 'assets/images/models/${categoryPrefix}_$zoneName.svg';

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.blue.withOpacity(0.3),
        BlendMode.srcIn,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: SvgPicture.asset(
          zonePath,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderBase() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.person_outline, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildZoneLabels() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: model.availableZones.map((zone) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                zone.name,
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getCategoryPrefix() {
    switch (model.category) {
      case ModelCategory.schoolBoy:
        return 'boy';
      case ModelCategory.schoolGirl:
        return 'girl';
      case ModelCategory.corporate:
        return 'corporate';
      case ModelCategory.medical:
        return 'medical';
      case ModelCategory.kurtaPajama:
        return 'kurta';
    }
  }

  String _getZoneSvgName(GarmentZoneType zoneType) {
    switch (zoneType) {
      case GarmentZoneType.body:
      case GarmentZoneType.kurta:
        return 'body';
      case GarmentZoneType.collar:
        return 'collar';
      case GarmentZoneType.leftSleeve:
        return 'left_sleeve';
      case GarmentZoneType.rightSleeve:
        return 'right_sleeve';
      case GarmentZoneType.pant:
      case GarmentZoneType.pajama:
        return 'pant';
      case GarmentZoneType.buttonStrip:
        return 'tie'; // For corporate
      case GarmentZoneType.pajamaStrip:
        return 'pocket'; // For medical
    }
  }

  Color _getFabricColor(Fabric? fabric) {
    if (fabric == null) return Colors.grey.shade300;

    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    // Extensive color mapping for all Mafatlal fabric colors
    final colorMap = <String, Color>{
      // Blues
      'navy': const Color(0xFF1E3A5F),
      'royal blue': const Color(0xFF4169E1),
      'sky blue': const Color(0xFF87CEEB),
      'light blue': const Color(0xFFADD8E6),
      'blue': const Color(0xFF2196F3),
      'dark blue': const Color(0xFF1A237E),
      'ocean blue': const Color(0xFF0077BE),
      'powder blue': const Color(0xFFB0E0E6),
      'steel blue': const Color(0xFF4682B4),
      'teal': const Color(0xFF008080),
      'turquoise': const Color(0xFF40E0D0),

      // Neutrals
      'white': const Color(0xFFF8F8F8),
      'off-white': const Color(0xFFFAF9F6),
      'cream': const Color(0xFFFFFDD0),
      'ivory': const Color(0xFFFFFFF0),
      'grey': const Color(0xFF9E9E9E),
      'light grey': const Color(0xFFD3D3D3),
      'charcoal': const Color(0xFF36454F),
      'slate': const Color(0xFF708090),
      'black': const Color(0xFF212121),

      // Earth tones
      'khaki': const Color(0xFFC3B091),
      'beige': const Color(0xFFF5F5DC),
      'tan': const Color(0xFFD2B48C),
      'brown': const Color(0xFF8B4513),
      'coffee': const Color(0xFF6F4E37),
      'chocolate': const Color(0xFF7B3F00),
      'olive': const Color(0xFF808000),

      // Reds & Pinks
      'maroon': const Color(0xFF800000),
      'burgundy': const Color(0xFF722F37),
      'red': const Color(0xFFF44336),
      'crimson': const Color(0xFFDC143C),
      'wine': const Color(0xFF722F37),
      'pink': const Color(0xFFE91E63),
      'blush': const Color(0xFFDE5D83),
      'coral': const Color(0xFFFF7F50),
      'peach': const Color(0xFFFFDAB9),

      // Greens
      'green': const Color(0xFF4CAF50),
      'forest green': const Color(0xFF228B22),
      'sage': const Color(0xFF9DC183),
      'mint': const Color(0xFF98FB98),
      'emerald': const Color(0xFF50C878),
      'lime': const Color(0xFF32CD32),
      'hunter green': const Color(0xFF355E3B),

      // Yellows & Oranges
      'yellow': const Color(0xFFFFC107),
      'gold': const Color(0xFFFFD700),
      'mustard': const Color(0xFFFFDB58),
      'amber': const Color(0xFFFFBF00),
      'orange': const Color(0xFFFF9800),
      'rust': const Color(0xFFB7410E),
      'terracotta': const Color(0xFFE2725B),

      // Purples
      'purple': const Color(0xFF9C27B0),
      'violet': const Color(0xFFEE82EE),
      'lavender': const Color(0xFFE6E6FA),
      'plum': const Color(0xFFDDA0DD),
      'mauve': const Color(0xFFE0B0FF),
      'indigo': const Color(0xFF4B0082),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default Mafatlal teal
    return const Color(0xFF0D9488);
  }
}

/// Widget to apply fabric texture/pattern on top of colored zones
class FabricPatternOverlay extends StatelessWidget {
  final Widget child;
  final Fabric? fabric;

  const FabricPatternOverlay({
    super.key,
    required this.child,
    this.fabric,
  });

  @override
  Widget build(BuildContext context) {
    if (fabric == null) return child;

    final patternType = _getPatternType(fabric!);

    if (patternType == PatternType.solid) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: CustomPaint(
            painter: _PatternPainter(patternType: patternType),
          ),
        ),
      ],
    );
  }

  PatternType _getPatternType(Fabric fabric) {
    final name = fabric.name.toLowerCase();
    if (name.contains('stripe') || name.contains('stripes')) {
      return PatternType.stripes;
    }
    if (name.contains('check') || name.contains('checks')) {
      return PatternType.checks;
    }
    if (name.contains('herringbone')) {
      return PatternType.herringbone;
    }
    if (name.contains('plaid')) {
      return PatternType.plaid;
    }
    if (name.contains('dot') || name.contains('polka')) {
      return PatternType.dots;
    }
    return PatternType.solid;
  }
}

enum PatternType { solid, stripes, checks, herringbone, plaid, dots }

class _PatternPainter extends CustomPainter {
  final PatternType patternType;

  _PatternPainter({required this.patternType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    switch (patternType) {
      case PatternType.stripes:
        _paintStripes(canvas, size, paint);
        break;
      case PatternType.checks:
        _paintChecks(canvas, size, paint);
        break;
      case PatternType.herringbone:
        _paintHerringbone(canvas, size, paint);
        break;
      case PatternType.plaid:
        _paintPlaid(canvas, size, paint);
        break;
      case PatternType.dots:
        _paintDots(canvas, size, paint);
        break;
      case PatternType.solid:
        break;
    }
  }

  void _paintStripes(Canvas canvas, Size size, Paint paint) {
    const spacing = 8.0;
    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  void _paintChecks(Canvas canvas, Size size, Paint paint) {
    const spacing = 12.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        if ((x ~/ spacing + y ~/ spacing) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, spacing / 2, spacing / 2),
            paint,
          );
        }
      }
    }
  }

  void _paintHerringbone(Canvas canvas, Size size, Paint paint) {
    const spacing = 6.0;
    for (double y = 0; y < size.height; y += spacing * 2) {
      for (double x = 0; x < size.width; x += spacing * 2) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x + spacing, y + spacing),
          paint,
        );
        canvas.drawLine(
          Offset(x + spacing, y),
          Offset(x, y + spacing),
          paint,
        );
      }
    }
  }

  void _paintPlaid(Canvas canvas, Size size, Paint paint) {
    const spacing = 20.0;
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintDots(Canvas canvas, Size size, Paint paint) {
    const spacing = 10.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A complete production-ready model viewer with all features
class ProductionModelViewer extends StatefulWidget {
  final UniformModel model;
  final Map<GarmentZoneType, GarmentZone> zones;
  final GarmentZoneType? selectedZone;
  final Widget? logoOverlay;
  final ValueChanged<GarmentZoneType>? onZoneTap;
  final bool enableZoom;
  final bool enableRotation;

  const ProductionModelViewer({
    super.key,
    required this.model,
    required this.zones,
    this.selectedZone,
    this.logoOverlay,
    this.onZoneTap,
    this.enableZoom = true,
    this.enableRotation = false,
  });

  @override
  State<ProductionModelViewer> createState() => _ProductionModelViewerState();
}

class _ProductionModelViewerState extends State<ProductionModelViewer> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: widget.enableZoom ? _onScaleStart : null,
      onScaleUpdate: widget.enableZoom ? _onScaleUpdate : null,
      onScaleEnd: widget.enableZoom ? _onScaleEnd : null,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale)
            ..rotateY(widget.enableRotation ? _rotation : 0),
          alignment: Alignment.center,
          child: SvgModelRenderer(
            model: widget.model,
            zones: widget.zones,
            highlightedZone: widget.selectedZone,
            logoOverlay: widget.logoOverlay,
          ),
        ),
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    // Store initial values
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_scale * details.scale).clamp(0.5, 3.0);
      _offset += details.focalPointDelta;

      if (widget.enableRotation) {
        _rotation += details.rotation;
      }
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // Reset if zoomed out too much
    if (_scale < 0.8) {
      setState(() {
        _scale = 1.0;
        _offset = Offset.zero;
      });
    }
  }
}
