import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/scheme_model.dart';
import '../services/firestore_service.dart';

class SchemeProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<SchemeModel> _allSchemes = AppConstants.demoSchemes;
  List<SchemeModel> _filteredSchemes = AppConstants.demoSchemes;
  final Set<String> _savedSchemeIds = {};
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<SchemeModel> get allSchemes => _allSchemes;
  List<SchemeModel> get filteredSchemes => _filteredSchemes;
  List<SchemeModel> get featuredSchemes => [..._allSchemes]..sort((a, b) => b.popularity.compareTo(a.popularity));
  List<SchemeModel> get savedSchemes => _allSchemes.where((s) => _savedSchemeIds.contains(s.id)).toList();
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSchemes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      if (Firebase.apps.isNotEmpty) {
        await _firestore.seedSchemes();
        final remote = await _firestore.getAllSchemes();
        if (remote.isNotEmpty) _allSchemes = remote;
      }
    } catch (e) {
      _error = 'Showing curated demo schemes. Firebase sync failed: $e';
      _allSchemes = AppConstants.demoSchemes;
    }
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSavedSchemes(String userId) async {
    if (Firebase.apps.isEmpty) return;
    try {
      _savedSchemeIds
        ..clear()
        ..addAll(await _firestore.getSavedSchemeIds(userId));
      notifyListeners();
    } catch (_) {}
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

  SchemeModel? byId(String id) {
    for (final scheme in _allSchemes) {
      if (scheme.id == id) return scheme;
    }
    return null;
  }

  Future<void> toggleSave(String userId, String schemeId) async {
    final isSaved = _savedSchemeIds.contains(schemeId);
    isSaved ? _savedSchemeIds.remove(schemeId) : _savedSchemeIds.add(schemeId);
    notifyListeners();
    if (Firebase.apps.isEmpty) return;
    if (isSaved) {
      await _firestore.unsaveScheme(userId, schemeId);
    } else {
      await _firestore.saveScheme(userId, schemeId);
    }
  }

  bool isSaved(String schemeId) => _savedSchemeIds.contains(schemeId);

  void _applyFilters() {
    final query = _searchQuery.trim().toLowerCase();
    _filteredSchemes = _allSchemes.where((scheme) {
      final categoryMatch = _selectedCategory == 'All' || scheme.category == _selectedCategory;
      final queryMatch = query.isEmpty ||
          scheme.name.toLowerCase().contains(query) ||
          scheme.description.toLowerCase().contains(query) ||
          scheme.category.toLowerCase().contains(query) ||
          scheme.targetGroups.any((group) => group.toLowerCase().contains(query));
      return categoryMatch && queryMatch;
    }).toList();
  }
}
