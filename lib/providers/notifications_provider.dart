import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum NotificationType { scheme, deadline, tracker, general }

extension NotificationTypeX on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.scheme:
        return '📋';
      case NotificationType.deadline:
        return '⏰';
      case NotificationType.tracker:
        return '📊';
      case NotificationType.general:
        return '🔔';
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case NotificationType.scheme:
        return const Color(0xFF1A73E8);
      case NotificationType.deadline:
        return const Color(0xFFE85D75);
      case NotificationType.tracker:
        return const Color(0xFF00A896);
      case NotificationType.general:
        return const Color(0xFFFFB703);
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.index,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
      };

  factory AppNotification.fromMap(Map<String, dynamic> map) =>
      AppNotification(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        type: NotificationType.values[map['type'] ?? 0],
        createdAt: DateTime.parse(map['createdAt']),
        isRead: map['isRead'] ?? false,
      );
}

// ─── Provider ─────────────────────────────────────────────────────────────────

class NotificationsProvider extends ChangeNotifier {
  static const _key = 'app_notifications';
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt)));

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationsProvider() {
    _load();
  }

  // ── Seed default notifications on first launch ──────────────────────────────
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        _notifications.addAll(
            list.map((e) => AppNotification.fromMap(e as Map<String, dynamic>)));
      } else {
        // First-time defaults
        _seedDefaults();
      }
      notifyListeners();
    } catch (_) {
      _seedDefaults();
    }
  }

  void _seedDefaults() {
    final now = DateTime.now();
    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Welcome to Sahayak AI! 🎉',
        body:
            'Complete your profile to get personalised government scheme recommendations.',
        type: NotificationType.general,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: 'n2',
        title: 'New Scheme: PM-KISAN Update',
        body:
            'PM-KISAN 19th installment has been released. Check your eligibility and bank account.',
        type: NotificationType.scheme,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      AppNotification(
        id: 'n3',
        title: '⏰ Scholarship Deadline Approaching',
        body:
            'National Scholarship Portal applications close soon. Apply before the deadline!',
        type: NotificationType.deadline,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      AppNotification(
        id: 'n4',
        title: 'Ayushman Bharat Drive Nearby',
        body:
            'A PM-JAY enrollment camp is happening in your district this week. Bring your Aadhaar.',
        type: NotificationType.scheme,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: 'n5',
        title: 'Mudra Loan Interest Rates Revised',
        body:
            'Interest rates for Shishu category Mudra loans have been reduced. Check updated terms.',
        type: NotificationType.scheme,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      AppNotification(
        id: 'n6',
        title: 'Track Your Applications',
        body:
            'Use the Tracker tab to monitor your scheme application status and update progress.',
        type: NotificationType.tracker,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      AppNotification(
        id: 'n7',
        title: 'PMAY Urban 2.0 Launched',
        body:
            'Pradhan Mantri Awas Yojana Urban 2.0 is now accepting applications. Check eligibility.',
        type: NotificationType.scheme,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
    ]);
    _save();
    notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void markAsRead(String id) {
    final n = _notifications.firstWhere((n) => n.id == id,
        orElse: () => _notifications.first);
    if (!n.isRead) {
      n.isRead = true;
      _save();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    _save();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    _save();
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _save();
    notifyListeners();
  }

  /// Call this when user tracks a new scheme application
  void addTrackerNotification(String schemeName) {
    _notifications.add(AppNotification(
      id: 'tracker_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Application Tracked ✅',
      body: 'You are now tracking your "$schemeName" application.',
      type: NotificationType.tracker,
      createdAt: DateTime.now(),
    ));
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _key, jsonEncode(_notifications.map((n) => n.toMap()).toList()));
    } catch (_) {}
  }
}