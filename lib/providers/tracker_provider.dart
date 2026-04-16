import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tracked_application.dart';

class TrackerProvider extends ChangeNotifier {
  static const _key = 'tracked_applications';
  final List<TrackedApplication> _applications = [];

  List<TrackedApplication> get applications => List.unmodifiable(_applications);

  int get totalCount => _applications.length;
  int get approvedCount =>
      _applications.where((a) => a.status == ApplicationStatus.approved).length;
  int get inProgressCount =>
      _applications.where((a) => a.status == ApplicationStatus.inProgress).length;
  int get submittedCount =>
      _applications.where((a) => a.status == ApplicationStatus.submitted).length;

  TrackerProvider() {
    _load();
  }

  bool isTracked(String schemeId) =>
      _applications.any((a) => a.schemeId == schemeId);

  TrackedApplication? getById(String schemeId) {
    try {
      return _applications.firstWhere((a) => a.schemeId == schemeId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addApplication({
    required String schemeId,
    required String schemeName,
    required String category,
  }) async {
    if (isTracked(schemeId)) return;
    _applications.add(TrackedApplication(
      schemeId: schemeId,
      schemeName: schemeName,
      category: category,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    await _save();
    notifyListeners();
  }

  Future<void> updateStatus(String schemeId, ApplicationStatus status) async {
    final app = getById(schemeId);
    if (app == null) return;
    app.status = status;
    app.updatedAt = DateTime.now();
    await _save();
    notifyListeners();
  }

  Future<void> updateNotes(String schemeId, String notes) async {
    final app = getById(schemeId);
    if (app == null) return;
    app.notes = notes;
    app.updatedAt = DateTime.now();
    await _save();
    notifyListeners();
  }

  Future<void> removeApplication(String schemeId) async {
    _applications.removeWhere((a) => a.schemeId == schemeId);
    await _save();
    notifyListeners();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final list = jsonDecode(raw) as List;
      _applications.clear();
      _applications.addAll(list.map(
          (e) => TrackedApplication.fromMap(e as Map<String, dynamic>)));
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _key, jsonEncode(_applications.map((a) => a.toMap()).toList()));
    } catch (_) {}
  }
}