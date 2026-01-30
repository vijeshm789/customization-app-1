import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';

/// Generates model images with customizable zone colors
class ModelImageGenerator {
  /// Zone colors for rendering
  final Map<GarmentZoneType, Color> zoneColors;
  final ModelCategory category;
  final String modelType;

  ModelImageGenerator({
    required this.zoneColors,
    required this.category,
    required this.modelType,
  });

  /// Default zone colors
  static Map<GarmentZoneType, Color> get defaultColors => {
        GarmentZoneType.collar: const Color(0xFFE8E8E8),
        GarmentZoneType.leftSleeve: const Color(0xFFA8C4D3),
        GarmentZoneType.rightSleeve: const Color(0xFFA8C4D3),
        GarmentZoneType.buttonStrip: const Color(0xFFD0D0D0),
        GarmentZoneType.body: const Color(0xFFB8D4E3),
        GarmentZoneType.kurta: const Color(0xFFB8D4E3),
        GarmentZoneType.pajama: const Color(0xFF4A5568),
        GarmentZoneType.pant: const Color(0xFF4A5568),
        GarmentZoneType.pajamaStrip: const Color(0xFF3A4558),
      };
}

/// Custom painter for rendering boy model
class BoyModelPainter extends CustomPainter {
  final Map<GarmentZoneType, Color> zoneColors;
  final bool showZoneOutlines;

  BoyModelPainter({
    required this.zoneColors,
    this.showZoneOutlines = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 32 * scale),
        width: 50 * scale,
        height: 48 * scale,
      ),
      paint,
    );

    // Hair
    paint.color = const Color(0xFF3D2314);
    final hairPath = Path()
      ..moveTo(centerX - 25 * scale, 32 * scale)
      ..quadraticBezierTo(
        centerX - 30 * scale,
        12 * scale,
        centerX,
        8 * scale,
      )
      ..quadraticBezierTo(
        centerX + 30 * scale,
        12 * scale,
        centerX + 25 * scale,
        32 * scale,
      )
      ..close();
    canvas.drawPath(hairPath, paint);

    // Neck
    paint.color = const Color(0xFFDEB887);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 68 * scale),
        width: 24 * scale,
        height: 20 * scale,
      ),
      paint,
    );

    // Collar
    paint.color = zoneColors[GarmentZoneType.collar] ?? const Color(0xFFE8E8E8);
    final collarPath = Path()
      ..moveTo(centerX - 40 * scale, 72 * scale)
      ..lineTo(centerX - 15 * scale, 90 * scale)
      ..lineTo(centerX, 85 * scale)
      ..lineTo(centerX + 15 * scale, 90 * scale)
      ..lineTo(centerX + 40 * scale, 72 * scale)
      ..lineTo(centerX + 35 * scale, 78 * scale)
      ..lineTo(centerX, 95 * scale)
      ..lineTo(centerX - 35 * scale, 78 * scale)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Body/Shirt
    paint.color = zoneColors[GarmentZoneType.body] ?? const Color(0xFFB8D4E3);
    final bodyPath = Path()
      ..moveTo(centerX - 70 * scale, 80 * scale)
      ..lineTo(centerX - 70 * scale, 220 * scale)
      ..lineTo(centerX + 70 * scale, 220 * scale)
      ..lineTo(centerX + 70 * scale, 80 * scale)
      ..lineTo(centerX + 40 * scale, 72 * scale)
      ..lineTo(centerX, 85 * scale)
      ..lineTo(centerX - 40 * scale, 72 * scale)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Button strip
    paint.color =
        zoneColors[GarmentZoneType.buttonStrip] ?? const Color(0xFFD0D0D0);
    canvas.drawRect(
      Rect.fromLTWH(
        centerX - 8 * scale,
        95 * scale,
        16 * scale,
        125 * scale,
      ),
      paint,
    );

    // Buttons
    paint.color = const Color(0xFFFFFFFF);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(centerX, (105 + i * 25) * scale),
        4 * scale,
        paint,
      );
    }

    // Left Sleeve
    paint.color =
        zoneColors[GarmentZoneType.leftSleeve] ?? const Color(0xFFA8C4D3);
    final leftSleevePath = Path()
      ..moveTo(centerX - 70 * scale, 80 * scale)
      ..lineTo(centerX - 100 * scale, 140 * scale)
      ..lineTo(centerX - 90 * scale, 150 * scale)
      ..lineTo(centerX - 70 * scale, 120 * scale)
      ..close();
    canvas.drawPath(leftSleevePath, paint);

    // Right Sleeve
    paint.color =
        zoneColors[GarmentZoneType.rightSleeve] ?? const Color(0xFFA8C4D3);
    final rightSleevePath = Path()
      ..moveTo(centerX + 70 * scale, 80 * scale)
      ..lineTo(centerX + 100 * scale, 140 * scale)
      ..lineTo(centerX + 90 * scale, 150 * scale)
      ..lineTo(centerX + 70 * scale, 120 * scale)
      ..close();
    canvas.drawPath(rightSleevePath, paint);

    // Left Arm
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 95 * scale, 170 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );
    // Left Hand
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 95 * scale, 205 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );

    // Right Arm
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 95 * scale, 170 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );
    // Right Hand
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 95 * scale, 205 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );

    // Pants
    paint.color = zoneColors[GarmentZoneType.pant] ?? const Color(0xFF4A5568);

    // Left leg
    final leftLegPath = Path()
      ..moveTo(centerX - 50 * scale, 220 * scale)
      ..lineTo(centerX - 55 * scale, 380 * scale)
      ..lineTo(centerX - 15 * scale, 380 * scale)
      ..lineTo(centerX - 10 * scale, 220 * scale)
      ..close();
    canvas.drawPath(leftLegPath, paint);

    // Right leg
    final rightLegPath = Path()
      ..moveTo(centerX + 50 * scale, 220 * scale)
      ..lineTo(centerX + 55 * scale, 380 * scale)
      ..lineTo(centerX + 15 * scale, 380 * scale)
      ..lineTo(centerX + 10 * scale, 220 * scale)
      ..close();
    canvas.drawPath(rightLegPath, paint);

    // Shoes
    paint.color = const Color(0xFF2D2D2D);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - 60 * scale,
          378 * scale,
          50 * scale,
          18 * scale,
        ),
        Radius.circular(6 * scale),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + 10 * scale,
          378 * scale,
          50 * scale,
          18 * scale,
        ),
        Radius.circular(6 * scale),
      ),
      paint,
    );

    // Zone outlines (for debugging)
    if (showZoneOutlines) {
      final outlinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.red;
      canvas.drawPath(collarPath, outlinePaint);
      canvas.drawPath(bodyPath, outlinePaint);
      canvas.drawPath(leftSleevePath, outlinePaint);
      canvas.drawPath(rightSleevePath, outlinePaint);
      canvas.drawPath(leftLegPath, outlinePaint);
      canvas.drawPath(rightLegPath, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant BoyModelPainter oldDelegate) {
    return oldDelegate.zoneColors != zoneColors ||
        oldDelegate.showZoneOutlines != showZoneOutlines;
  }
}

/// Custom painter for rendering girl model
class GirlModelPainter extends CustomPainter {
  final Map<GarmentZoneType, Color> zoneColors;
  final bool showZoneOutlines;

  GirlModelPainter({
    required this.zoneColors,
    this.showZoneOutlines = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 32 * scale),
        width: 48 * scale,
        height: 46 * scale,
      ),
      paint,
    );

    // Hair (longer for girl)
    paint.color = const Color(0xFF3D2314);
    final hairPath = Path()
      ..moveTo(centerX - 30 * scale, 55 * scale)
      ..quadraticBezierTo(
        centerX - 35 * scale,
        10 * scale,
        centerX,
        5 * scale,
      )
      ..quadraticBezierTo(
        centerX + 35 * scale,
        10 * scale,
        centerX + 30 * scale,
        55 * scale,
      )
      ..lineTo(centerX + 35 * scale, 100 * scale)
      ..lineTo(centerX - 35 * scale, 100 * scale)
      ..close();
    canvas.drawPath(hairPath, paint);

    // Neck
    paint.color = const Color(0xFFDEB887);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 65 * scale),
        width: 20 * scale,
        height: 16 * scale,
      ),
      paint,
    );

    // Collar
    paint.color = zoneColors[GarmentZoneType.collar] ?? const Color(0xFFE8E8E8);
    final collarPath = Path()
      ..moveTo(centerX - 35 * scale, 70 * scale)
      ..lineTo(centerX - 12 * scale, 85 * scale)
      ..lineTo(centerX, 80 * scale)
      ..lineTo(centerX + 12 * scale, 85 * scale)
      ..lineTo(centerX + 35 * scale, 70 * scale)
      ..lineTo(centerX + 30 * scale, 78 * scale)
      ..lineTo(centerX, 90 * scale)
      ..lineTo(centerX - 30 * scale, 78 * scale)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Body/Blouse
    paint.color = zoneColors[GarmentZoneType.body] ?? const Color(0xFFFFB6C1);
    final bodyPath = Path()
      ..moveTo(centerX - 55 * scale, 75 * scale)
      ..lineTo(centerX - 50 * scale, 160 * scale)
      ..lineTo(centerX + 50 * scale, 160 * scale)
      ..lineTo(centerX + 55 * scale, 75 * scale)
      ..lineTo(centerX + 35 * scale, 70 * scale)
      ..lineTo(centerX, 80 * scale)
      ..lineTo(centerX - 35 * scale, 70 * scale)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Left Sleeve
    paint.color =
        zoneColors[GarmentZoneType.leftSleeve] ?? const Color(0xFFFFB6C1);
    final leftSleevePath = Path()
      ..moveTo(centerX - 55 * scale, 75 * scale)
      ..lineTo(centerX - 80 * scale, 130 * scale)
      ..lineTo(centerX - 70 * scale, 138 * scale)
      ..lineTo(centerX - 55 * scale, 100 * scale)
      ..close();
    canvas.drawPath(leftSleevePath, paint);

    // Right Sleeve
    paint.color =
        zoneColors[GarmentZoneType.rightSleeve] ?? const Color(0xFFFFB6C1);
    final rightSleevePath = Path()
      ..moveTo(centerX + 55 * scale, 75 * scale)
      ..lineTo(centerX + 80 * scale, 130 * scale)
      ..lineTo(centerX + 70 * scale, 138 * scale)
      ..lineTo(centerX + 55 * scale, 100 * scale)
      ..close();
    canvas.drawPath(rightSleevePath, paint);

    // Arms
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 75 * scale, 155 * scale),
        width: 14 * scale,
        height: 45 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 75 * scale, 188 * scale),
        width: 18 * scale,
        height: 22 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 75 * scale, 155 * scale),
        width: 14 * scale,
        height: 45 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 75 * scale, 188 * scale),
        width: 18 * scale,
        height: 22 * scale,
      ),
      paint,
    );

    // Skirt
    paint.color = zoneColors[GarmentZoneType.pant] ?? const Color(0xFF4A5568);
    final skirtPath = Path()
      ..moveTo(centerX - 50 * scale, 160 * scale)
      ..lineTo(centerX - 70 * scale, 280 * scale)
      ..lineTo(centerX + 70 * scale, 280 * scale)
      ..lineTo(centerX + 50 * scale, 160 * scale)
      ..close();
    canvas.drawPath(skirtPath, paint);

    // Legs
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 30 * scale, 320 * scale),
        width: 22 * scale,
        height: 80 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 30 * scale, 320 * scale),
        width: 22 * scale,
        height: 80 * scale,
      ),
      paint,
    );

    // Shoes
    paint.color = const Color(0xFF2D2D2D);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - 45 * scale,
          378 * scale,
          35 * scale,
          16 * scale,
        ),
        Radius.circular(5 * scale),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + 10 * scale,
          378 * scale,
          35 * scale,
          16 * scale,
        ),
        Radius.circular(5 * scale),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GirlModelPainter oldDelegate) {
    return oldDelegate.zoneColors != zoneColors;
  }
}

/// Custom painter for corporate model
class CorporateModelPainter extends CustomPainter {
  final Map<GarmentZoneType, Color> zoneColors;

  CorporateModelPainter({required this.zoneColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 30 * scale),
        width: 45 * scale,
        height: 45 * scale,
      ),
      paint,
    );

    // Hair
    paint.color = const Color(0xFF2D2D2D);
    final hairPath = Path()
      ..moveTo(centerX - 22 * scale, 30 * scale)
      ..quadraticBezierTo(centerX - 25 * scale, 10 * scale, centerX, 8 * scale)
      ..quadraticBezierTo(centerX + 25 * scale, 10 * scale, centerX + 22 * scale, 30 * scale)
      ..close();
    canvas.drawPath(hairPath, paint);

    // Neck
    paint.color = const Color(0xFFDEB887);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 60 * scale),
        width: 20 * scale,
        height: 18 * scale,
      ),
      paint,
    );

    // Suit Jacket Body
    paint.color = zoneColors[GarmentZoneType.body] ?? const Color(0xFF1E3A5F);
    final jacketPath = Path()
      ..moveTo(centerX - 65 * scale, 68 * scale)
      ..lineTo(centerX - 60 * scale, 200 * scale)
      ..lineTo(centerX + 60 * scale, 200 * scale)
      ..lineTo(centerX + 65 * scale, 68 * scale)
      ..lineTo(centerX + 30 * scale, 65 * scale)
      ..lineTo(centerX, 75 * scale)
      ..lineTo(centerX - 30 * scale, 65 * scale)
      ..close();
    canvas.drawPath(jacketPath, paint);

    // Shirt (visible in V)
    paint.color = const Color(0xFFFFFFFF);
    final shirtPath = Path()
      ..moveTo(centerX - 20 * scale, 68 * scale)
      ..lineTo(centerX - 15 * scale, 120 * scale)
      ..lineTo(centerX + 15 * scale, 120 * scale)
      ..lineTo(centerX + 20 * scale, 68 * scale)
      ..lineTo(centerX, 75 * scale)
      ..close();
    canvas.drawPath(shirtPath, paint);

    // Tie
    paint.color = const Color(0xFF8B0000);
    final tiePath = Path()
      ..moveTo(centerX - 8 * scale, 75 * scale)
      ..lineTo(centerX - 10 * scale, 140 * scale)
      ..lineTo(centerX, 155 * scale)
      ..lineTo(centerX + 10 * scale, 140 * scale)
      ..lineTo(centerX + 8 * scale, 75 * scale)
      ..lineTo(centerX, 85 * scale)
      ..close();
    canvas.drawPath(tiePath, paint);

    // Collar
    paint.color = zoneColors[GarmentZoneType.collar] ?? const Color(0xFF1E3A5F);
    final collarPath = Path()
      ..moveTo(centerX - 30 * scale, 65 * scale)
      ..lineTo(centerX - 35 * scale, 85 * scale)
      ..lineTo(centerX - 20 * scale, 85 * scale)
      ..lineTo(centerX, 75 * scale)
      ..lineTo(centerX + 20 * scale, 85 * scale)
      ..lineTo(centerX + 35 * scale, 85 * scale)
      ..lineTo(centerX + 30 * scale, 65 * scale)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Left Sleeve
    paint.color = zoneColors[GarmentZoneType.leftSleeve] ?? const Color(0xFF1E3A5F);
    final leftSleevePath = Path()
      ..moveTo(centerX - 65 * scale, 68 * scale)
      ..lineTo(centerX - 90 * scale, 150 * scale)
      ..lineTo(centerX - 78 * scale, 158 * scale)
      ..lineTo(centerX - 65 * scale, 100 * scale)
      ..close();
    canvas.drawPath(leftSleevePath, paint);

    // Right Sleeve
    paint.color = zoneColors[GarmentZoneType.rightSleeve] ?? const Color(0xFF1E3A5F);
    final rightSleevePath = Path()
      ..moveTo(centerX + 65 * scale, 68 * scale)
      ..lineTo(centerX + 90 * scale, 150 * scale)
      ..lineTo(centerX + 78 * scale, 158 * scale)
      ..lineTo(centerX + 65 * scale, 100 * scale)
      ..close();
    canvas.drawPath(rightSleevePath, paint);

    // Arms/Hands
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 85 * scale, 175 * scale),
        width: 15 * scale,
        height: 45 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 85 * scale, 205 * scale),
        width: 18 * scale,
        height: 22 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 85 * scale, 175 * scale),
        width: 15 * scale,
        height: 45 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 85 * scale, 205 * scale),
        width: 18 * scale,
        height: 22 * scale,
      ),
      paint,
    );

    // Pants
    paint.color = zoneColors[GarmentZoneType.pant] ?? const Color(0xFF2D3748);
    final leftLegPath = Path()
      ..moveTo(centerX - 45 * scale, 200 * scale)
      ..lineTo(centerX - 48 * scale, 380 * scale)
      ..lineTo(centerX - 12 * scale, 380 * scale)
      ..lineTo(centerX - 10 * scale, 200 * scale)
      ..close();
    canvas.drawPath(leftLegPath, paint);

    final rightLegPath = Path()
      ..moveTo(centerX + 45 * scale, 200 * scale)
      ..lineTo(centerX + 48 * scale, 380 * scale)
      ..lineTo(centerX + 12 * scale, 380 * scale)
      ..lineTo(centerX + 10 * scale, 200 * scale)
      ..close();
    canvas.drawPath(rightLegPath, paint);

    // Shoes
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 53 * scale, 378 * scale, 45 * scale, 18 * scale),
        Radius.circular(5 * scale),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 8 * scale, 378 * scale, 45 * scale, 18 * scale),
        Radius.circular(5 * scale),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CorporateModelPainter oldDelegate) {
    return oldDelegate.zoneColors != zoneColors;
  }
}

/// Custom painter for medical scrubs model
class MedicalModelPainter extends CustomPainter {
  final Map<GarmentZoneType, Color> zoneColors;

  MedicalModelPainter({required this.zoneColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 30 * scale),
        width: 45 * scale,
        height: 45 * scale,
      ),
      paint,
    );

    // Hair
    paint.color = const Color(0xFF3D2314);
    final hairPath = Path()
      ..moveTo(centerX - 22 * scale, 30 * scale)
      ..quadraticBezierTo(centerX - 25 * scale, 10 * scale, centerX, 8 * scale)
      ..quadraticBezierTo(centerX + 25 * scale, 10 * scale, centerX + 22 * scale, 30 * scale)
      ..close();
    canvas.drawPath(hairPath, paint);

    // Neck
    paint.color = const Color(0xFFDEB887);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 58 * scale),
        width: 22 * scale,
        height: 16 * scale,
      ),
      paint,
    );

    // Scrub Top Body
    paint.color = zoneColors[GarmentZoneType.body] ?? const Color(0xFF0891B2);
    final scrubTopPath = Path()
      ..moveTo(centerX - 60 * scale, 65 * scale)
      ..lineTo(centerX - 55 * scale, 200 * scale)
      ..lineTo(centerX + 55 * scale, 200 * scale)
      ..lineTo(centerX + 60 * scale, 65 * scale)
      ..quadraticBezierTo(centerX + 40 * scale, 60 * scale, centerX + 15 * scale, 68 * scale)
      ..lineTo(centerX, 80 * scale)
      ..lineTo(centerX - 15 * scale, 68 * scale)
      ..quadraticBezierTo(centerX - 40 * scale, 60 * scale, centerX - 60 * scale, 65 * scale)
      ..close();
    canvas.drawPath(scrubTopPath, paint);

    // V-neck
    paint.color = const Color(0xFFDEB887);
    final vneckPath = Path()
      ..moveTo(centerX - 15 * scale, 68 * scale)
      ..lineTo(centerX, 95 * scale)
      ..lineTo(centerX + 15 * scale, 68 * scale)
      ..close();
    canvas.drawPath(vneckPath, paint);

    // Pocket
    paint.color = zoneColors[GarmentZoneType.body]?.withOpacity(0.8) ?? const Color(0xFF0891B2).withOpacity(0.8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 45 * scale, 120 * scale, 35 * scale, 40 * scale),
        Radius.circular(3 * scale),
      ),
      paint,
    );

    // Left Sleeve
    paint.color = zoneColors[GarmentZoneType.leftSleeve] ?? const Color(0xFF0891B2);
    final leftSleevePath = Path()
      ..moveTo(centerX - 60 * scale, 65 * scale)
      ..lineTo(centerX - 85 * scale, 130 * scale)
      ..lineTo(centerX - 73 * scale, 138 * scale)
      ..lineTo(centerX - 60 * scale, 95 * scale)
      ..close();
    canvas.drawPath(leftSleevePath, paint);

    // Right Sleeve
    paint.color = zoneColors[GarmentZoneType.rightSleeve] ?? const Color(0xFF0891B2);
    final rightSleevePath = Path()
      ..moveTo(centerX + 60 * scale, 65 * scale)
      ..lineTo(centerX + 85 * scale, 130 * scale)
      ..lineTo(centerX + 73 * scale, 138 * scale)
      ..lineTo(centerX + 60 * scale, 95 * scale)
      ..close();
    canvas.drawPath(rightSleevePath, paint);

    // Arms
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 80 * scale, 160 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 80 * scale, 195 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 80 * scale, 160 * scale),
        width: 16 * scale,
        height: 50 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 80 * scale, 195 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );

    // Scrub Pants
    paint.color = zoneColors[GarmentZoneType.pant] ?? const Color(0xFF0891B2);
    final leftLegPath = Path()
      ..moveTo(centerX - 45 * scale, 200 * scale)
      ..lineTo(centerX - 50 * scale, 380 * scale)
      ..lineTo(centerX - 10 * scale, 380 * scale)
      ..lineTo(centerX - 8 * scale, 200 * scale)
      ..close();
    canvas.drawPath(leftLegPath, paint);

    final rightLegPath = Path()
      ..moveTo(centerX + 45 * scale, 200 * scale)
      ..lineTo(centerX + 50 * scale, 380 * scale)
      ..lineTo(centerX + 10 * scale, 380 * scale)
      ..lineTo(centerX + 8 * scale, 200 * scale)
      ..close();
    canvas.drawPath(rightLegPath, paint);

    // Shoes
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 55 * scale, 378 * scale, 48 * scale, 18 * scale),
        Radius.circular(6 * scale),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 7 * scale, 378 * scale, 48 * scale, 18 * scale),
        Radius.circular(6 * scale),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MedicalModelPainter oldDelegate) {
    return oldDelegate.zoneColors != zoneColors;
  }
}

/// Custom painter for Kurta Pajama model
class KurtaPajamaModelPainter extends CustomPainter {
  final Map<GarmentZoneType, Color> zoneColors;

  KurtaPajamaModelPainter({required this.zoneColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final scale = size.height / 400;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 30 * scale),
        width: 45 * scale,
        height: 45 * scale,
      ),
      paint,
    );

    // Hair
    paint.color = const Color(0xFF1A1A1A);
    final hairPath = Path()
      ..moveTo(centerX - 22 * scale, 30 * scale)
      ..quadraticBezierTo(centerX - 25 * scale, 10 * scale, centerX, 8 * scale)
      ..quadraticBezierTo(centerX + 25 * scale, 10 * scale, centerX + 22 * scale, 30 * scale)
      ..close();
    canvas.drawPath(hairPath, paint);

    // Neck
    paint.color = const Color(0xFFDEB887);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 58 * scale),
        width: 22 * scale,
        height: 16 * scale,
      ),
      paint,
    );

    // Kurta
    paint.color = zoneColors[GarmentZoneType.kurta] ?? const Color(0xFFF5F5DC);
    final kurtaPath = Path()
      ..moveTo(centerX - 55 * scale, 65 * scale)
      ..lineTo(centerX - 50 * scale, 260 * scale)
      ..lineTo(centerX + 50 * scale, 260 * scale)
      ..lineTo(centerX + 55 * scale, 65 * scale)
      ..lineTo(centerX + 20 * scale, 62 * scale)
      ..lineTo(centerX, 75 * scale)
      ..lineTo(centerX - 20 * scale, 62 * scale)
      ..close();
    canvas.drawPath(kurtaPath, paint);

    // Collar (Mandarin style)
    paint.color = zoneColors[GarmentZoneType.collar] ?? const Color(0xFFE8DCC8);
    final collarPath = Path()
      ..moveTo(centerX - 20 * scale, 62 * scale)
      ..lineTo(centerX - 15 * scale, 85 * scale)
      ..lineTo(centerX, 75 * scale)
      ..lineTo(centerX + 15 * scale, 85 * scale)
      ..lineTo(centerX + 20 * scale, 62 * scale)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Button placket
    paint.color = zoneColors[GarmentZoneType.collar]?.withOpacity(0.9) ?? const Color(0xFFE8DCC8);
    canvas.drawRect(
      Rect.fromLTWH(centerX - 8 * scale, 85 * scale, 16 * scale, 100 * scale),
      paint,
    );

    // Buttons
    paint.color = const Color(0xFFD4AF37);
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(centerX, (95 + i * 22) * scale),
        4 * scale,
        paint,
      );
    }

    // Arms (short kurta sleeves)
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 70 * scale, 120 * scale),
        width: 18 * scale,
        height: 55 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 70 * scale, 160 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 70 * scale, 120 * scale),
        width: 18 * scale,
        height: 55 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 70 * scale, 160 * scale),
        width: 20 * scale,
        height: 24 * scale,
      ),
      paint,
    );

    // Pajama
    paint.color = zoneColors[GarmentZoneType.pajama] ?? const Color(0xFFF5F5DC);
    final leftLegPath = Path()
      ..moveTo(centerX - 40 * scale, 260 * scale)
      ..lineTo(centerX - 35 * scale, 380 * scale)
      ..lineTo(centerX - 5 * scale, 380 * scale)
      ..lineTo(centerX - 8 * scale, 260 * scale)
      ..close();
    canvas.drawPath(leftLegPath, paint);

    final rightLegPath = Path()
      ..moveTo(centerX + 40 * scale, 260 * scale)
      ..lineTo(centerX + 35 * scale, 380 * scale)
      ..lineTo(centerX + 5 * scale, 380 * scale)
      ..lineTo(centerX + 8 * scale, 260 * scale)
      ..close();
    canvas.drawPath(rightLegPath, paint);

    // Pajama strip (naada)
    paint.color = zoneColors[GarmentZoneType.pajamaStrip] ?? const Color(0xFFD4AF37);
    canvas.drawRect(
      Rect.fromLTWH(centerX - 30 * scale, 258 * scale, 60 * scale, 8 * scale),
      paint,
    );

    // Feet
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 20 * scale, 390 * scale),
        width: 30 * scale,
        height: 15 * scale,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 20 * scale, 390 * scale),
        width: 30 * scale,
        height: 15 * scale,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant KurtaPajamaModelPainter oldDelegate) {
    return oldDelegate.zoneColors != zoneColors;
  }
}
