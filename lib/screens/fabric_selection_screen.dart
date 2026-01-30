import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/fabric.dart';
import '../models/fabric_category.dart';
import '../providers/fabric_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/fabric_card.dart';
import 'visualizer_screen.dart';

class FabricSelectionScreen extends StatefulWidget {
  final FabricCategory category;

  const FabricSelectionScreen({
    super.key,
    required this.category,
  });

  @override
  State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
}

class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Consumer<FabricProvider>(
                  builder: (context, provider, child) {
                    if (provider.selectedFolderId == null) {
                      return _buildFolderGrid(provider);
                    }
                    return _buildFabricGrid(provider);
                  },
                ),
              ),
              _buildSelectionBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Consumer<FabricProvider>(
      builder: (context, provider, child) {
        final title = provider.selectedFolderId != null
            ? provider.currentFolders
                .firstWhere(
                  (f) => f.id == provider.selectedFolderId,
                  orElse: () => provider.currentFolders.first,
                )
                .name
            : widget.category.name;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (provider.selectedFolderId != null) {
                    provider.goBack();
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFolderGrid(FabricProvider provider) {
    final folders = provider.currentFolders;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return _buildFolderCard(folder, provider);
          },
        ),
      ),
    );
  }

  Widget _buildFolderCard(FabricFolder folder, FabricProvider provider) {
    return GestureDetector(
      onTap: () => provider.selectFolder(folder.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.folder_rounded,
                color: AppColors.primaryTeal,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${folder.fabricCount} fabrics',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabricGrid(FabricProvider provider) {
    final fabrics = provider.currentFabrics;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${fabrics.length} Fabrics',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${provider.selectedCount}/${FabricProvider.maxSelectionLimit} ${AppStrings.selectedCount}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: provider.selectedCount > 0
                          ? AppColors.primaryTeal
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: fabrics.length,
                itemBuilder: (context, index) {
                  final fabric = fabrics[index];
                  return FabricCard(
                    fabric: fabric,
                    isSelected: provider.isFabricSelected(fabric),
                    onTap: () => provider.toggleFabricSelection(fabric),
                    canSelect: provider.canSelectMore ||
                        provider.isFabricSelected(fabric),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Consumer<FabricProvider>(
      builder: (context, provider, child) {
        if (provider.selectedCount == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${provider.selectedCount} fabrics selected',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 32,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.selectedFabrics.length,
                          itemBuilder: (context, index) {
                            final fabric = provider.selectedFabrics[index];
                            return _buildSelectedFabricChip(fabric, provider);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VisualizerScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedFabricChip(Fabric fabric, FabricProvider provider) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryTeal.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fabric.code,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => provider.removeFromSelection(fabric),
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primaryTeal,
            ),
          ),
        ],
      ),
    );
  }
}
