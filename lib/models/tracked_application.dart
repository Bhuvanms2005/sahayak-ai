// ─── Application Tracker Model ───────────────────────────────────────────────

enum ApplicationStatus {
  notStarted,
  inProgress,
  submitted,
  approved,
  rejected,
}

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.notStarted:
        return 'Not Started';
      case ApplicationStatus.inProgress:
        return 'In Progress';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  String get emoji {
    switch (this) {
      case ApplicationStatus.notStarted:
        return '📋';
      case ApplicationStatus.inProgress:
        return '⏳';
      case ApplicationStatus.submitted:
        return '📤';
      case ApplicationStatus.approved:
        return '✅';
      case ApplicationStatus.rejected:
        return '❌';
    }
  }
}

class TrackedApplication {
  final String schemeId;
  final String schemeName;
  final String category;
  ApplicationStatus status;
  final DateTime addedAt;
  DateTime updatedAt;
  String? notes;

  TrackedApplication({
    required this.schemeId,
    required this.schemeName,
    required this.category,
    this.status = ApplicationStatus.notStarted,
    required this.addedAt,
    required this.updatedAt,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'schemeId': schemeId,
        'schemeName': schemeName,
        'category': category,
        'status': status.index,
        'addedAt': addedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'notes': notes,
      };

  factory TrackedApplication.fromMap(Map<String, dynamic> map) {
    return TrackedApplication(
      schemeId: map['schemeId'] ?? '',
      schemeName: map['schemeName'] ?? '',
      category: map['category'] ?? '',
      status: ApplicationStatus.values[map['status'] ?? 0],
      addedAt: DateTime.parse(map['addedAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      notes: map['notes'],
    );
  }
}