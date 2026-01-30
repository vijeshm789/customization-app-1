import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/garment_zone.dart';

class ZoneSelector extends StatelessWidget {
  final List<GarmentZoneType> availableZones;
  final GarmentZoneType? selectedZone;
  final Map<GarmentZoneType, GarmentZone> zones;
  final Function(GarmentZoneType) onZoneSelected;

  const ZoneSelector({
    super.key,
    required this.availableZones,
    required this.selectedZone,
    required this.zones,
    required this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableZones.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Select a model to customize zones',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
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
        itemCount: availableZones.length,
        itemBuilder: (context, index) {
          final zone = availableZones[index];
          final isSelected = selectedZone == zone;
          final hasAppliedFabric = zones[zone]?.appliedFabric != null;

          return _buildZoneChip(zone, isSelected, hasAppliedFabric);
        },
      ),
    );
  }

  Widget _buildZoneChip(
      GarmentZoneType zone, bool isSelected, bool hasAppliedFabric) {
    return GestureDetector(
      onTap: () => onZoneSelected(zone),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryTeal
                : hasAppliedFabric
                    ? AppColors.success
                    : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getZoneIcon(zone),
              size: 16,
              color: isSelected ? AppColors.primaryTeal : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              zone.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Poppins',
                color: isSelected ? AppColors.primaryTeal : Colors.white,
              ),
            ),
            if (hasAppliedFabric) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                size: 14,
                color: isSelected ? AppColors.success : Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getZoneIcon(GarmentZoneType zone) {
    switch (zone) {
      case GarmentZoneType.collar:
        return Icons.radio_button_unchecked;
      case GarmentZoneType.leftSleeve:
        return Icons.arrow_back;
      case GarmentZoneType.rightSleeve:
        return Icons.arrow_forward;
      case GarmentZoneType.buttonStrip:
        return Icons.more_vert;
      case GarmentZoneType.body:
        return Icons.crop_square;
      case GarmentZoneType.kurta:
        return Icons.crop_portrait;
      case GarmentZoneType.pajama:
        return Icons.straighten;
      case GarmentZoneType.pant:
        return Icons.straighten;
      case GarmentZoneType.pajamaStrip:
        return Icons.remove;
    }
  }
}
