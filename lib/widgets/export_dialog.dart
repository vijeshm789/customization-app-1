import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _selectedResolution = '2K';
  bool _isExporting = false;

  final List<Map<String, dynamic>> _resolutions = [
    {
      'name': '2K',
      'description': '2560 x 1440',
      'icon': Icons.image_outlined,
    },
    {
      'name': '4K',
      'description': '3840 x 2160',
      'icon': Icons.high_quality_outlined,
    },
    {
      'name': '8K',
      'description': '7680 x 4320',
      'icon': Icons.hd_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          const SizedBox(height: 16),
          const Text(
            AppStrings.exportOptions,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose resolution and export method',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildResolutionSelector(),
          const SizedBox(height: 24),
          _buildExportButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildResolutionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resolution',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _resolutions.map((resolution) {
            final isSelected = _selectedResolution == resolution['name'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedResolution = resolution['name'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryTeal.withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        resolution['icon'],
                        size: 28,
                        color: isSelected
                            ? AppColors.primaryTeal
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        resolution['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: isSelected
                              ? AppColors.primaryTeal
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        resolution['description'],
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          color: isSelected
                              ? AppColors.primaryTeal
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExportButtons() {
    return Column(
      children: [
        _buildExportButton(
          icon: Icons.save_alt_rounded,
          label: AppStrings.saveToDevice,
          description: 'Save to your device gallery',
          onTap: _saveToDevice,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildExportButton(
          icon: Icons.share_rounded,
          label: AppStrings.shareDesign,
          description: 'Share via WhatsApp, Email, etc.',
          onTap: _shareDesign,
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: _isExporting ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.border),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.primaryTeal.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : AppColors.primaryTeal,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: isPrimary ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: isPrimary
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_isExporting)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppColors.primaryTeal,
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: isPrimary ? Colors.white : AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToDevice() async {
    setState(() {
      _isExporting = true;
    });

    // Simulate export delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isExporting = false;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Design saved in $_selectedResolution resolution!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _shareDesign() async {
    setState(() {
      _isExporting = true;
    });

    // Simulate export delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isExporting = false;
    });

    if (mounted) {
      Navigator.pop(context);

      // Use share_plus to share
      await Share.share(
        'Check out my custom uniform design created with Mafatlal Visualizer!',
        subject: 'My Custom Uniform Design',
      );
    }
  }
}
