import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/fabric.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';
import '../providers/fabric_provider.dart';
import '../providers/visualizer_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/model_selector_sheet.dart';
import '../widgets/zone_selector.dart';
import '../widgets/export_dialog.dart';

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
    return GestureDetector(
      onTap: _showModelSelector,
      child: Container(
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
            // Model Image with applied fabrics
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _buildModelWithFabrics(provider),
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
          ],
        ),
      ),
    );
  }

  Widget _buildModelWithFabrics(VisualizerProvider provider) {
    final model = provider.currentModel;

    return Container(
      width: double.infinity,
      height: double.infinity,
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base model silhouette
          Center(
            child: _buildModelSilhouette(model, provider),
          ),
          // Zone indicators
          ...provider.zones.entries.map((entry) {
            if (entry.value.appliedFabric != null) {
              return _buildZoneIndicator(entry.key, entry.value);
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildModelSilhouette(UniformModel? model, VisualizerProvider provider) {
    return CustomPaint(
      size: const Size(200, 350),
      painter: _ModelPainter(
        modelCategory: model?.category ?? ModelCategory.boys,
        zones: provider.zones,
      ),
    );
  }

  Widget _buildZoneIndicator(GarmentZoneType zoneType, GarmentZone zone) {
    if (zone.appliedFabric == null) return const SizedBox.shrink();

    return const SizedBox.shrink();
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                provider.logoOverlay!.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
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
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: fabrics.length,
        itemBuilder: (context, index) {
          final fabric = fabrics[index];
          return _buildFabricSwatch(fabric, provider);
        },
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
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
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
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                fabric.code.split('-').last,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (isApplied)
              const Positioned(
                bottom: 4,
                right: 4,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getFabricSwatchColor(Fabric fabric) {
    final colorName = fabric.colors?.firstOrNull?.toLowerCase() ?? '';

    final colorMap = {
      'navy': const Color(0xFF1E3A5F),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFE0E0E0),
      'grey': const Color(0xFF9E9E9E),
      'black': const Color(0xFF212121),
      'maroon': const Color(0xFF800000),
      'green': const Color(0xFF4CAF50),
      'yellow': const Color(0xFFFFC107),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
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
              decoration: InputDecoration(
                hintText: 'Design name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.designSaved),
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

class _ModelPainter extends CustomPainter {
  final ModelCategory modelCategory;
  final Map<GarmentZoneType, GarmentZone> zones;

  _ModelPainter({
    required this.modelCategory,
    required this.zones,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw body based on model category
    _drawBody(canvas, size, paint);
  }

  void _drawBody(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width / 2;

    // Head
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.08),
        width: size.width * 0.25,
        height: size.height * 0.12,
      ),
      paint,
    );

    // Neck
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.16),
        width: size.width * 0.12,
        height: size.height * 0.05,
      ),
      paint,
    );

    // Collar
    final collarZone = zones[GarmentZoneType.collar];
    paint.color = _getZoneColor(collarZone, const Color(0xFFE8E8E8));
    final collarPath = Path()
      ..moveTo(centerX - size.width * 0.18, size.height * 0.18)
      ..lineTo(centerX - size.width * 0.08, size.height * 0.22)
      ..lineTo(centerX, size.height * 0.20)
      ..lineTo(centerX + size.width * 0.08, size.height * 0.22)
      ..lineTo(centerX + size.width * 0.18, size.height * 0.18)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Body/Shirt
    final bodyZone = zones[GarmentZoneType.body];
    paint.color = _getZoneColor(bodyZone, const Color(0xFFB8D4E3));
    final bodyPath = Path()
      ..moveTo(centerX - size.width * 0.35, size.height * 0.20)
      ..lineTo(centerX - size.width * 0.35, size.height * 0.55)
      ..lineTo(centerX + size.width * 0.35, size.height * 0.55)
      ..lineTo(centerX + size.width * 0.35, size.height * 0.20)
      ..lineTo(centerX + size.width * 0.18, size.height * 0.18)
      ..lineTo(centerX, size.height * 0.20)
      ..lineTo(centerX - size.width * 0.18, size.height * 0.18)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Left Sleeve
    final leftSleeveZone = zones[GarmentZoneType.leftSleeve];
    paint.color = _getZoneColor(leftSleeveZone, const Color(0xFFA8C4D3));
    final leftSleevePath = Path()
      ..moveTo(centerX - size.width * 0.35, size.height * 0.20)
      ..lineTo(centerX - size.width * 0.5, size.height * 0.35)
      ..lineTo(centerX - size.width * 0.45, size.height * 0.40)
      ..lineTo(centerX - size.width * 0.35, size.height * 0.30)
      ..close();
    canvas.drawPath(leftSleevePath, paint);

    // Right Sleeve
    final rightSleeveZone = zones[GarmentZoneType.rightSleeve];
    paint.color = _getZoneColor(rightSleeveZone, const Color(0xFFA8C4D3));
    final rightSleevePath = Path()
      ..moveTo(centerX + size.width * 0.35, size.height * 0.20)
      ..lineTo(centerX + size.width * 0.5, size.height * 0.35)
      ..lineTo(centerX + size.width * 0.45, size.height * 0.40)
      ..lineTo(centerX + size.width * 0.35, size.height * 0.30)
      ..close();
    canvas.drawPath(rightSleevePath, paint);

    // Arms
    paint.color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - size.width * 0.48, size.height * 0.45),
        width: size.width * 0.08,
        height: size.height * 0.15,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + size.width * 0.48, size.height * 0.45),
        width: size.width * 0.08,
        height: size.height * 0.15,
      ),
      paint,
    );

    // Pants
    final pantZone = zones[GarmentZoneType.pant];
    paint.color = _getZoneColor(pantZone, const Color(0xFF4A5568));

    // Left leg
    final leftLegPath = Path()
      ..moveTo(centerX - size.width * 0.25, size.height * 0.55)
      ..lineTo(centerX - size.width * 0.28, size.height * 0.95)
      ..lineTo(centerX - size.width * 0.08, size.height * 0.95)
      ..lineTo(centerX - size.width * 0.05, size.height * 0.55)
      ..close();
    canvas.drawPath(leftLegPath, paint);

    // Right leg
    final rightLegPath = Path()
      ..moveTo(centerX + size.width * 0.25, size.height * 0.55)
      ..lineTo(centerX + size.width * 0.28, size.height * 0.95)
      ..lineTo(centerX + size.width * 0.08, size.height * 0.95)
      ..lineTo(centerX + size.width * 0.05, size.height * 0.55)
      ..close();
    canvas.drawPath(rightLegPath, paint);
  }

  Color _getZoneColor(GarmentZone? zone, Color defaultColor) {
    if (zone?.appliedFabric == null) return defaultColor;

    final colorName = zone!.appliedFabric!.colors?.firstOrNull?.toLowerCase() ?? '';

    final colorMap = {
      'navy': const Color(0xFF1E3A5F),
      'blue': const Color(0xFF2196F3),
      'white': const Color(0xFFF5F5F5),
      'grey': const Color(0xFF9E9E9E),
      'black': const Color(0xFF212121),
      'maroon': const Color(0xFF800000),
      'green': const Color(0xFF4CAF50),
      'yellow': const Color(0xFFFFC107),
      'red': const Color(0xFFF44336),
    };

    for (final entry in colorMap.entries) {
      if (colorName.contains(entry.key)) {
        return entry.value;
      }
    }

    return defaultColor;
  }

  @override
  bool shouldRepaint(covariant _ModelPainter oldDelegate) {
    return oldDelegate.zones != zones || oldDelegate.modelCategory != modelCategory;
  }
}
