import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';
import '../providers/visualizer_provider.dart';
import '../utils/mock_data.dart';
import '../utils/model_painters.dart';

class ModelSelectorSheet extends StatefulWidget {
  const ModelSelectorSheet({super.key});

  @override
  State<ModelSelectorSheet> createState() => _ModelSelectorSheetState();
}

class _ModelSelectorSheetState extends State<ModelSelectorSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<UniformModel> _models = MockData.getUniformModels();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ModelCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ModelCategory.values.map((category) {
                return _buildModelGrid(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'Select Model',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryTeal,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        dividerColor: Colors.transparent,
        tabs: ModelCategory.values.map((category) {
          return Tab(text: category.displayName);
        }).toList(),
      ),
    );
  }

  Widget _buildModelGrid(ModelCategory category) {
    final categoryModels =
        _models.where((m) => m.category == category).toList();

    if (categoryModels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No models available',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: categoryModels.length,
      itemBuilder: (context, index) {
        final model = categoryModels[index];
        return _buildModelCard(model);
      },
    );
  }

  Widget _buildModelCard(UniformModel model) {
    return Consumer<VisualizerProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.currentModel?.id == model.id;

        return GestureDetector(
          onTap: () {
            provider.selectModel(model);
            Navigator.pop(context);
          },
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
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: _buildModelPreview(model),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: isSelected
                                ? AppColors.primaryTeal
                                : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModelPreview(UniformModel model) {
    // Use the new realistic model painters
    final defaultColors = ModelImageGenerator.defaultColors;

    CustomPainter painter;
    switch (model.category) {
      case ModelCategory.boys:
        if (model.id.contains('kurta')) {
          painter = KurtaPajamaModelPainter(zoneColors: defaultColors);
        } else {
          painter = BoyModelPainter(zoneColors: defaultColors);
        }
        break;
      case ModelCategory.girls:
        painter = GirlModelPainter(zoneColors: defaultColors);
        break;
      case ModelCategory.corporate:
        painter = CorporateModelPainter(zoneColors: defaultColors);
        break;
      case ModelCategory.medical:
        painter = MedicalModelPainter(zoneColors: defaultColors);
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              size: const Size(80, 120),
              painter: painter,
            ),
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: model.availableZones.take(3).map((zone) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                zone.displayName,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.primaryTeal,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
