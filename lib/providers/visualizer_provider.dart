import 'package:flutter/foundation.dart';
import '../models/fabric.dart';
import '../models/garment_zone.dart';
import '../models/uniform_model.dart';
import '../models/saved_design.dart';
import '../utils/mock_data.dart';

class VisualizerProvider with ChangeNotifier {
  UniformModel? _currentModel;
  Map<GarmentZoneType, GarmentZone> _zones = {};
  GarmentZoneType? _selectedZone;
  List<Fabric> _availableFabrics = [];
  LogoOverlay? _logoOverlay;
  bool _isLoading = false;
  String? _errorMessage;

  // Available models
  List<UniformModel> _availableModels = [];

  // Getters
  UniformModel? get currentModel => _currentModel;
  Map<GarmentZoneType, GarmentZone> get zones => _zones;
  GarmentZoneType? get selectedZone => _selectedZone;
  List<Fabric> get availableFabrics => _availableFabrics;
  LogoOverlay? get logoOverlay => _logoOverlay;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UniformModel> get availableModels => _availableModels;

  List<GarmentZoneType> get availableZones =>
      _currentModel?.availableZones ?? [];

  GarmentZone? get currentZone =>
      _selectedZone != null ? _zones[_selectedZone] : null;

  bool get hasAnyFabricApplied =>
      _zones.values.any((zone) => zone.appliedFabric != null);

  // Initialize visualizer
  Future<void> initialize(List<Fabric> fabrics) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _availableModels = MockData.getUniformModels();
      _availableFabrics = fabrics;

      // Set default model
      if (_availableModels.isNotEmpty && _currentModel == null) {
        await selectModel(_availableModels.first);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize visualizer';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Model selection
  Future<void> selectModel(UniformModel model) async {
    _currentModel = model;
    _initializeZones();
    _selectedZone = model.availableZones.isNotEmpty
        ? model.availableZones.first
        : null;
    notifyListeners();
  }

  void _initializeZones() {
    _zones = {};
    if (_currentModel != null) {
      for (var zoneType in _currentModel!.availableZones) {
        _zones[zoneType] = GarmentZone(type: zoneType);
      }
    }
  }

  // Zone selection
  void selectZone(GarmentZoneType zoneType) {
    if (_currentModel?.availableZones.contains(zoneType) ?? false) {
      _selectedZone = zoneType;
      notifyListeners();
    }
  }

  // Apply fabric to zone
  void applyFabricToZone(Fabric fabric, {GarmentZoneType? zoneType}) {
    final targetZone = zoneType ?? _selectedZone;
    if (targetZone == null) return;

    if (_zones.containsKey(targetZone)) {
      _zones[targetZone] = _zones[targetZone]!.copyWith(
        appliedFabric: fabric,
      );
      notifyListeners();
    }
  }

  // Clear fabric from zone
  void clearZoneFabric({GarmentZoneType? zoneType}) {
    final targetZone = zoneType ?? _selectedZone;
    if (targetZone == null) return;

    if (_zones.containsKey(targetZone)) {
      _zones[targetZone] = _zones[targetZone]!.copyWith(clearFabric: true);
      notifyListeners();
    }
  }

  // Apply same fabric to all zones
  void applyFabricToAllZones(Fabric fabric) {
    for (var zoneType in _zones.keys) {
      _zones[zoneType] = _zones[zoneType]!.copyWith(appliedFabric: fabric);
    }
    notifyListeners();
  }

  // Reset all zones
  void resetAllZones() {
    _initializeZones();
    _logoOverlay = null;
    notifyListeners();
  }

  // Logo management
  void setLogoOverlay(LogoOverlay logo) {
    _logoOverlay = logo;
    notifyListeners();
  }

  void setLogo(String imagePath) {
    _logoOverlay = LogoOverlay(
      imagePath: imagePath,
      x: 80,
      y: 100,
      width: 60,
      height: 60,
    );
    notifyListeners();
  }

  void resetZones() {
    _initializeZones();
    notifyListeners();
  }

  void updateLogoPosition(double x, double y) {
    if (_logoOverlay != null) {
      _logoOverlay = _logoOverlay!.copyWith(x: x, y: y);
      notifyListeners();
    }
  }

  void updateLogoSize(double width, double height) {
    if (_logoOverlay != null) {
      _logoOverlay = _logoOverlay!.copyWith(width: width, height: height);
      notifyListeners();
    }
  }

  void updateLogoRotation(double rotation) {
    if (_logoOverlay != null) {
      _logoOverlay = _logoOverlay!.copyWith(rotation: rotation);
      notifyListeners();
    }
  }

  void removeLogo() {
    _logoOverlay = null;
    notifyListeners();
  }

  // Create SavedDesign from current state
  SavedDesign createSavedDesign(String name) {
    if (_currentModel == null) {
      throw Exception('No model selected');
    }

    return SavedDesign(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
      model: _currentModel!,
      zones: Map.from(_zones),
      logoOverlay: _logoOverlay,
    );
  }

  // Load from saved design
  void loadFromSavedDesign(SavedDesign design) {
    _currentModel = design.model;
    _zones = Map.from(design.zones);
    _logoOverlay = design.logoOverlay;
    _selectedZone = design.model.availableZones.isNotEmpty
        ? design.model.availableZones.first
        : null;
    notifyListeners();
  }

  // Update available fabrics
  void updateAvailableFabrics(List<Fabric> fabrics) {
    _availableFabrics = fabrics;
    notifyListeners();
  }

  // Get models by category
  List<UniformModel> getModelsByCategory(ModelCategory category) {
    return _availableModels.where((m) => m.category == category).toList();
  }
}
