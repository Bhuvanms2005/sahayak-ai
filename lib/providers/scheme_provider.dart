import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/scheme_model.dart';

class SchemeProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<SchemeModel> _allSchemes = [];
  List<SchemeModel> _filteredSchemes = [];
  List<String> _savedSchemeIds = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<SchemeModel> get allSchemes => _allSchemes;
  List<SchemeModel> get filteredSchemes => _filteredSchemes;
  List<String> get savedSchemeIds => _savedSchemeIds;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<SchemeModel> get savedSchemes =>
      _allSchemes.where((s) => _savedSchemeIds.contains(s.id)).toList();

  Future<void> loadSchemes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.seedSchemes();
      _allSchemes = await _firestoreService.getAllSchemes();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedSchemes(String userId) async {
    _savedSchemeIds = await _firestoreService.getSavedSchemeIds(userId);
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var schemes = List<SchemeModel>.from(_allSchemes);

    if (_selectedCategory != 'All') {
      schemes = schemes.where((s) => s.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      schemes = schemes
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q) ||
              s.category.toLowerCase().contains(q) ||
              s.targetGroups.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }

    _filteredSchemes = schemes;
  }

  Future<void> toggleSave(String userId, String schemeId) async {
    final isSaved = _savedSchemeIds.contains(schemeId);
    if (isSaved) {
      _savedSchemeIds.remove(schemeId);
      await _firestoreService.unsaveScheme(userId, schemeId);
    } else {
      _savedSchemeIds.add(schemeId);
      await _firestoreService.saveScheme(userId, schemeId);
    }
    notifyListeners();
  }

  bool isSaved(String schemeId) => _savedSchemeIds.contains(schemeId);

  List<SchemeModel> getSchemesByCategory(String category) {
    return _allSchemes.where((s) => s.category == category).toList();
  }

  Future<void> incrementView(String schemeId) async {
    await _firestoreService.incrementViewCount(schemeId);
  }

  List<SchemeModel> get featuredSchemes =>
      _allSchemes.take(5).toList();

  Map<String, int> get categoryCounts {
    final counts = <String, int>{};
    for (final scheme in _allSchemes) {
      counts[scheme.category] = (counts[scheme.category] ?? 0) + 1;
    }
    return counts;
  }
}