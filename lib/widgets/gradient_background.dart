import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool useSoftGradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.useSoftGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: useSoftGradient
            ? AppColors.softBackgroundGradient
            : AppColors.backgroundGradient,
      ),
      child: child,
    );
  }
}

class SoftGradientBackground extends StatelessWidget {
  final Widget child;

  const SoftGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.softBackgroundGradient,
      ),
      child: child,
    );
  }
}
