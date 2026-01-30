import 'package:flutter/foundation.dart';
import '../models/fabric.dart';
import '../models/fabric_category.dart';
import '../utils/mock_data.dart';

class FabricProvider with ChangeNotifier {
  List<FabricCategory> _categories = [];
  List<Fabric> _allFabrics = [];
  List<Fabric> _filteredFabrics = [];
  List<Fabric> _selectedFabrics = [];
  String _searchQuery = '';
  String? _selectedCategoryId;
  String? _selectedFolderId;
  bool _isLoading = false;
  String? _errorMessage;

  static const int maxSelectionLimit = 10;

  // Getters
  List<FabricCategory> get categories => _categories;
  List<Fabric> get allFabrics => _allFabrics;
  List<Fabric> get filteredFabrics => _filteredFabrics;
  List<Fabric> get selectedFabrics => _selectedFabrics;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedFolderId => _selectedFolderId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedCount => _selectedFabrics.length;
  bool get canSelectMore => _selectedFabrics.length < maxSelectionLimit;

  FabricCategory? get selectedCategory => _selectedCategoryId != null
      ? _categories.firstWhere(
          (c) => c.id == _selectedCategoryId,
          orElse: () => _categories.first,
        )
      : null;

  List<FabricFolder> get currentFolders =>
      selectedCategory?.folders ?? [];

  List<Fabric> get currentFabrics {
    if (_selectedFolderId == null) return [];
    return _allFabrics
        .where((f) => f.folderId == _selectedFolderId)
        .toList();
  }

  // Initialize data
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      _categories = MockData.getCategories();
      _allFabrics = MockData.getAllFabrics();
      _filteredFabrics = _allFabrics;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Category selection
  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _selectedFolderId = null;
    _applyFilters();
    notifyListeners();
  }

  // Folder selection
  void selectFolder(String folderId) {
    _selectedFolderId = folderId;
    _applyFilters();
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // Apply filters
  void _applyFilters() {
    _filteredFabrics = _allFabrics.where((fabric) {
      bool matchesCategory = _selectedCategoryId == null ||
          fabric.categoryId == _selectedCategoryId;
      bool matchesFolder = _selectedFolderId == null ||
          fabric.folderId == _selectedFolderId;
      bool matchesSearch = _searchQuery.isEmpty ||
          fabric.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fabric.code.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesFolder && matchesSearch;
    }).toList();
  }

  // Selection management
  void toggleFabricSelection(Fabric fabric) {
    if (_selectedFabrics.contains(fabric)) {
      _selectedFabrics.remove(fabric);
    } else if (canSelectMore) {
      _selectedFabrics.add(fabric);
    }
    notifyListeners();
  }

  bool isFabricSelected(Fabric fabric) {
    return _selectedFabrics.contains(fabric);
  }

  void clearSelection() {
    _selectedFabrics.clear();
    notifyListeners();
  }

  void removeFromSelection(Fabric fabric) {
    _selectedFabrics.remove(fabric);
    notifyListeners();
  }

  // Navigation helpers
  void goBack() {
    if (_selectedFolderId != null) {
      _selectedFolderId = null;
    } else if (_selectedCategoryId != null) {
      _selectedCategoryId = null;
    }
    _applyFilters();
    notifyListeners();
  }

  void resetNavigation() {
    _selectedCategoryId = null;
    _selectedFolderId = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
}
