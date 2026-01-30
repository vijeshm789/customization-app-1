import 'package:flutter/material.dart';

class MafatlalLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const MafatlalLogo({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'M',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF0D9488),
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class MafatlalLogoWithText extends StatelessWidget {
  final double logoSize;
  final double? fontSize;
  final Color? color;
  final bool showTagline;

  const MafatlalLogoWithText({
    super.key,
    this.logoSize = 60,
    this.fontSize,
    this.color,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MafatlalLogo(size: logoSize, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'MAFATLAL',
              style: TextStyle(
                fontSize: fontSize ?? logoSize * 0.35,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
                letterSpacing: 2,
                fontFamily: 'Poppins',
              ),
            ),
            if (showTagline)
              Text(
                'VISUALIZER',
                style: TextStyle(
                  fontSize: (fontSize ?? logoSize * 0.35) * 0.6,
                  fontWeight: FontWeight.w500,
                  color: (color ?? Colors.white).withOpacity(0.8),
                  letterSpacing: 4,
                  fontFamily: 'Poppins',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
