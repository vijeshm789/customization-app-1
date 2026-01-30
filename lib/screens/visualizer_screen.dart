import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/fabric.dart';
import '../models/garment_zone.dart';
import '../providers/fabric_provider.dart';
import '../providers/visualizer_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/model_selector_sheet.dart';
import '../widgets/zone_selector.dart';
import '../widgets/export_dialog.dart';
import '../widgets/model_display.dart';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final visualizerProvider = context.read<VisualizerProvider>();
      final fabricProvider = context.read<FabricProvider>();
      visualizerProvider.initialize(fabricProvider.selectedFabrics);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildVisualizerContent(),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              AppStrings.visualizer,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _showExportDialog,
            icon: const Icon(
              Icons.share_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizerContent() {
    return Consumer<VisualizerProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Model Preview Area
              Expanded(
                flex: 3,
                child: _buildModelPreview(provider),
              ),
              const SizedBox(height: 16),
              // Zone Selector
              SizedBox(
                height: 60,
                child: ZoneSelector(
                  availableZones: provider.currentModel?.availableZones ?? [],
                  selectedZone: provider.selectedZone,
                  zones: provider.zones,
                  onZoneSelected: (zone) {
                    provider.selectZone(zone);
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Fabric Swatches
              Expanded(
                flex: 1,
                child: _buildFabricSwatches(provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelPreview(VisualizerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Model Display with applied fabrics
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade50,
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
                ),
              ),
              child: ModelDisplay(
                model: provider.currentModel,
                zones: provider.zones,
                selectedZone: provider.selectedZone,
                onTap: _showModelSelector,
              ),
            ),
          ),
          // Change Model Button
          Positioned(
            top: 12,
            right: 12,
            child: _buildChangeModelButton(),
          ),
          // Add Logo Button
          Positioned(
            top: 12,
            left: 12,
            child: _buildAddLogoButton(),
          ),
          // Logo overlay if exists
          if (provider.logoOverlay != null)
            Positioned(
              left: provider.logoOverlay!.x,
              top: provider.logoOverlay!.y,
              child: _buildLogoOverlay(provider),
            ),
          // Selected zone indicator
          if (provider.selectedZone != null)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _buildZoneIndicator(provider.selectedZone!),
            ),
        ],
      ),
    );
  }

  Widget _buildZoneIndicator(GarmentZoneType zone) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Tap fabric to apply to ${zone.displayName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeModelButton() {
    return GestureDetector(
      onTap: _showModelSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryTeal.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text(
              'Model',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddLogoButton() {
    return GestureDetector(
      onTap: _pickLogo,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate, color: AppColors.primaryTeal, size: 18),
            SizedBox(width: 4),
            Text(
              'Logo',
              style: TextStyle(
                color: AppColors.primaryTeal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoOverlay(VisualizerProvider provider) {
    return GestureDetector(
      onPanUpdate: (details) {
        provider.updateLogoPosition(
          provider.logoOverlay!.x + details.delta.dx,
          provider.logoOverlay!.y + details.delta.dy,
        );
      },
      child: Container(
        width: provider.logoOverlay!.width,
        height: provider.logoOverlay!.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryTeal.withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildLogoImage(provider.logoOverlay!.imagePath),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap: () => provider.removeLogo(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
            // Resize handle
            Positioned(
              bottom: -6,
              right: -6,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final newWidth = (provider.logoOverlay!.width + details.delta.dx).clamp(30.0, 150.0);
                  final newHeight = (provider.logoOverlay!.height + details.delta.dy).clamp(30.0, 150.0);
                  provider.updateLogoSize(newWidth, newHeight);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.open_in_full,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoImage(String imagePath) {
    // Check if it's a file path or asset path
    if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
      return Image.file(
        File(imagePath.replaceFirst('file://', '')),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildLogoPlaceholder(),
      );
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildLogoPlaceholder(),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 24),
      ),
    );
  }

  Widget _buildFabricSwatches(VisualizerProvider provider) {
    final fabrics = provider.availableFabrics;

    if (fabrics.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No fabrics selected. Go back to select fabrics.',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Available Fabrics (${fabrics.length})',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: fabrics.length,
              itemBuilder: (context, index) {
                final fabric = fabrics[index];
                return _buildFabricSwatch(fabric, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricSwatch(Fabric fabric, VisualizerProvider provider) {
    final isApplied = provider.selectedZone != null &&
        provider.zones[provider.selectedZone]?.appliedFabric?.id == fabric.id;

    return GestureDetector(
      onTap: () {
        if (provider.selectedZone != null) {
          provider.applyFabricToZone(fabric);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Select a zone first'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: _getFabricSwatchColor(fabric),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isApplied ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: isApplied
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Pattern overlay for special fabrics
            if (_hasPattern(fabric))
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: CustomPaint(
                    painter: _FabricPatternPainter(
                      patternType: _getPatternType(fabric),
                      baseColor: _getFabricSwatchColor(fabric),
                    ),
                  ),
                ),
              ),
            // Fabric info
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fabric.code.split('-').last,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isApplied)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.success,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _hasPattern(Fabric fabric) {
    final name = fabric.name.toLowerCase();
    return name.contains('stripe') ||
        name.contains('check') ||
        name.contains('plaid') ||
        name.contains('herringbone') ||
        name.contains('pinstripe');
  }

  String _getPatternType(Fabric fabric) {
    final name = fabric.name.toLowerCase();
    if (name.contains('stripe') || name.contains('pinstripe')) return 'stripe';
    if (name.contains('check') || name.contains('plaid')) return 'check';
    if (name.contains('herringbone')) return 'herringbone';
    return 'solid';
  }

  Color _getFabricSwatchColor(Fabric fabric) {
    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    final colorMap = {
      'navy': const Color(0xFF1E3A5F),
      'royal blue': const Color(0xFF4169E1),
      'sky blue': const Color(0xFF87CEEB),
      'ceil blue': const Color(0xFF92A8D1),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFE8E8E8),
      'bright white': const Color(0xFFF5F5F5),
      'off white': const Color(0xFFFAF0E6),
      'grey': const Color(0xFF9E9E9E),
      'charcoal': const Color(0xFF36454F),
      'black': const Color(0xFF212121),
      'maroon': const Color(0xFF800000),
      'burgundy': const Color(0xFF800020),
      'green': const Color(0xFF4CAF50),
      'hunter': const Color(0xFF355E3B),
      'yellow': const Color(0xFFFFC107),
      'gold': const Color(0xFFFFD700),
      'cream': const Color(0xFFFFFDD0),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
      'lavender': const Color(0xFFE6E6FA),
      'orange': const Color(0xFFFF9800),
      'pink': const Color(0xFFE91E63),
      'khaki': const Color(0xFFC3B091),
      'tan': const Color(0xFFD2B48C),
      'olive': const Color(0xFF808000),
      'platinum': const Color(0xFFE5E4E2),
      'silver': const Color(0xFFC0C0C0),
      'denim': const Color(0xFF1560BD),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    return AppColors.primaryTeal;
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildControlButton(
              icon: Icons.refresh,
              label: AppStrings.reset,
              onTap: () {
                context.read<VisualizerProvider>().resetZones();
              },
              isPrimary: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _buildControlButton(
              icon: Icons.save_alt,
              label: AppStrings.saveArticle,
              onTap: _saveDesign,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? AppColors.primaryTeal : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? AppColors.primaryTeal : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModelSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ModelSelectorSheet(),
    );
  }

  Future<void> _pickLogo() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null && mounted) {
        context.read<VisualizerProvider>().setLogo(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  void _saveDesign() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Save Design',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter design name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.design_services),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a design name')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Design "$name" saved successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ExportDialog(),
    );
  }
}

/// Custom painter for fabric patterns
class _FabricPatternPainter extends CustomPainter {
  final String patternType;
  final Color baseColor;

  _FabricPatternPainter({
    required this.patternType,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2;

    switch (patternType) {
      case 'stripe':
        for (double i = -size.height; i < size.width + size.height; i += 8) {
          canvas.drawLine(
            Offset(i, 0),
            Offset(i + size.height, size.height),
            paint,
          );
        }
        break;
      case 'check':
        paint.style = PaintingStyle.fill;
        const checkSize = 10.0;
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
        break;
      case 'herringbone':
        for (double y = 0; y < size.height; y += 12) {
          for (double x = 0; x < size.width; x += 12) {
            canvas.drawLine(
              Offset(x, y),
              Offset(x + 6, y + 6),
              paint,
            );
            canvas.drawLine(
              Offset(x + 6, y + 6),
              Offset(x + 12, y),
              paint,
            );
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
