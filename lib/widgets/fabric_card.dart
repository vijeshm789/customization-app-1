import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/fabric.dart';

class FabricCard extends StatelessWidget {
  final Fabric fabric;
  final bool isSelected;
  final VoidCallback onTap;
  final bool canSelect;

  const FabricCard({
    super.key,
    required this.fabric,
    required this.isSelected,
    required this.onTap,
    this.canSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSelect ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryTeal.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: _buildFabricImage(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fabric.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fabric.code,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (fabric.material != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            fabric.material!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            if (!canSelect && !isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabricImage() {
    // Generate a placeholder pattern based on fabric colors
    final color = _getFabricColor();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          if (_hasStripes())
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _StripePainter(color: Colors.white.withOpacity(0.2)),
            ),
          if (_hasChecks())
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _CheckPainter(color: Colors.white.withOpacity(0.15)),
            ),
          // Fabric icon
          Center(
            child: Icon(
              Icons.texture,
              size: 32,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFabricColor() {
    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    final colorMap = {
      'navy': const Color(0xFF1E3A5F),
      'navy blue': const Color(0xFF1E3A5F),
      'royal blue': const Color(0xFF4169E1),
      'sky blue': const Color(0xFF87CEEB),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFF5F5F5),
      'grey': const Color(0xFF9E9E9E),
      'gray': const Color(0xFF9E9E9E),
      'black': const Color(0xFF212121),
      'maroon': const Color(0xFF800000),
      'green': const Color(0xFF4CAF50),
      'yellow': const Color(0xFFFFC107),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
      'orange': const Color(0xFFFF9800),
      'pink': const Color(0xFFE91E63),
      'cream': const Color(0xFFFFFDD0),
      'khaki': const Color(0xFFC3B091),
      'olive': const Color(0xFF808000),
      'tan': const Color(0xFFD2B48C),
      'charcoal': const Color(0xFF36454F),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    return AppColors.primaryTeal;
  }

  bool _hasStripes() {
    final name = fabric.name.toLowerCase();
    return name.contains('stripe') || name.contains('pinstripe');
  }

  bool _hasChecks() {
    final name = fabric.name.toLowerCase();
    return name.contains('check') || name.contains('plaid');
  }
}

class _StripePainter extends CustomPainter {
  final Color color;

  _StripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;

    for (double i = -size.height; i < size.width + size.height; i += 12) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CheckPainter extends CustomPainter {
  final Color color;

  _CheckPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const checkSize = 20.0;

    for (double y = 0; y < size.height; y += checkSize * 2) {
      for (double x = 0; x < size.width; x += checkSize * 2) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, checkSize, checkSize),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(x + checkSize, y + checkSize, checkSize, checkSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
