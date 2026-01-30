import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_design.dart';

class SavedDesignsProvider with ChangeNotifier {
  List<SavedDesign> _designs = [];
  bool _isLoading = false;
  String? _errorMessage;

  static const String _storageKey = 'saved_designs';

  // Getters
  List<SavedDesign> get designs => _designs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get designCount => _designs.length;
  bool get hasDesigns => _designs.isNotEmpty;

  // Load saved designs from storage
  Future<void> loadDesigns() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? designsJson = prefs.getString(_storageKey);

      if (designsJson != null) {
        final List<dynamic> decoded = jsonDecode(designsJson);
        _designs = decoded
            .map((d) => SavedDesign.fromJson(d as Map<String, dynamic>))
            .toList();
        // Sort by creation date, newest first
        _designs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load saved designs';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save design
  Future<bool> saveDesign(SavedDesign design) async {
    try {
      // Check if design with same ID exists
      final existingIndex = _designs.indexWhere((d) => d.id == design.id);

      if (existingIndex != -1) {
        // Update existing design
        _designs[existingIndex] = design.copyWith(updatedAt: DateTime.now());
      } else {
        // Add new design
        _designs.insert(0, design);
      }

      await _persistDesigns();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save design';
      notifyListeners();
      return false;
    }
  }

  // Delete design
  Future<bool> deleteDesign(String designId) async {
    try {
      _designs.removeWhere((d) => d.id == designId);
      await _persistDesigns();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete design';
      notifyListeners();
      return false;
    }
  }

  // Update design name
  Future<bool> updateDesignName(String designId, String newName) async {
    try {
      final index = _designs.indexWhere((d) => d.id == designId);
      if (index != -1) {
        _designs[index] = _designs[index].copyWith(
          name: newName,
          updatedAt: DateTime.now(),
        );
        await _persistDesigns();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update design';
      notifyListeners();
      return false;
    }
  }

  // Get design by ID
  SavedDesign? getDesignById(String designId) {
    try {
      return _designs.firstWhere((d) => d.id == designId);
    } catch (e) {
      return null;
    }
  }

  // Persist designs to storage
  Future<void> _persistDesigns() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _designs.map((d) => d.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  // Clear all designs
  Future<void> clearAllDesigns() async {
    _designs.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }
}
