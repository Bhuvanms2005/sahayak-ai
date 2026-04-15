class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final int? age;
  final String? gender;
  final String? state;
  final String? district;
  final String? occupation;
  final double? annualIncome;
  final String? category; // General / OBC / SC / ST
  final String? education;
  final bool? isMarried;
  final bool? hasDisability;
  final String preferredLanguage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.age,
    this.gender,
    this.state,
    this.district,
    this.occupation,
    this.annualIncome,
    this.category,
    this.education,
    this.isMarried,
    this.hasDisability,
    this.preferredLanguage = 'en',
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      age: map['age'],
      gender: map['gender'],
      state: map['state'],
      district: map['district'],
      occupation: map['occupation'],
      annualIncome: map['annualIncome']?.toDouble(),
      category: map['category'],
      education: map['education'],
      isMarried: map['isMarried'],
      hasDisability: map['hasDisability'],
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'age': age,
      'gender': gender,
      'state': state,
      'district': district,
      'occupation': occupation,
      'annualIncome': annualIncome,
      'category': category,
      'education': education,
      'isMarried': isMarried,
      'hasDisability': hasDisability,
      'preferredLanguage': preferredLanguage,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    int? age,
    String? gender,
    String? state,
    String? district,
    String? occupation,
    double? annualIncome,
    String? category,
    String? education,
    bool? isMarried,
    bool? hasDisability,
    String? preferredLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      district: district ?? this.district,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      category: category ?? this.category,
      education: education ?? this.education,
      isMarried: isMarried ?? this.isMarried,
      hasDisability: hasDisability ?? this.hasDisability,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get profileSummary {
    final parts = <String>[];
    if (age != null) parts.add('Age: $age');
    if (gender != null) parts.add('Gender: $gender');
    if (state != null) parts.add('State: $state');
    if (occupation != null) parts.add('Occupation: $occupation');
    if (annualIncome != null) parts.add('Income: ₹${annualIncome!.toStringAsFixed(0)}');
    if (category != null) parts.add('Category: $category');
    return parts.join(' | ');
  }

  bool get isProfileComplete {
    return age != null &&
        gender != null &&
        state != null &&
        occupation != null &&
        annualIncome != null &&
        category != null;
  }
}