import 'package:cloud_firestore/cloud_firestore.dart';

class SchemeModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String benefits;
  final String eligibility;
  final List<String> documents;
  final List<String> targetGroups;
  final String ministry;
  final String applicationMode;
  final String deadline;
  final int popularity;

  const SchemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.benefits,
    required this.eligibility,
    required this.documents,
    required this.targetGroups,
    required this.ministry,
    required this.applicationMode,
    required this.deadline,
    required this.popularity,
  });

  factory SchemeModel.fromMap(Map<String, dynamic> map, String id) {
    return SchemeModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      benefits: map['benefits'] as String? ?? '',
      eligibility: map['eligibility'] as String? ?? '',
      documents: List<String>.from(map['documents'] as List? ?? const []),
      targetGroups: List<String>.from(map['targetGroups'] as List? ?? const []),
      ministry: map['ministry'] as String? ?? 'Government of India',
      applicationMode: map['applicationMode'] as String? ?? 'Online',
      deadline: map['deadline'] as String? ?? 'Open',
      popularity: (map['popularity'] as num?)?.toInt() ?? 0,
    );
  }

  factory SchemeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return SchemeModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'benefits': benefits,
      'eligibility': eligibility,
      'documents': documents,
      'targetGroups': targetGroups,
      'ministry': ministry,
      'applicationMode': applicationMode,
      'deadline': deadline,
      'popularity': popularity,
    };
  }
}
