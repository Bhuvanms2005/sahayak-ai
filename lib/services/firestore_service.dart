import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/scheme_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _db.collection(AppConstants.usersCollection).doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(AppConstants.usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection(AppConstants.usersCollection).doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<List<SchemeModel>> getAllSchemes() async {
    final snapshot = await _db.collection(AppConstants.schemesCollection).get();
    return snapshot.docs.map((doc) => SchemeModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> seedSchemes() async {
    final existing = await _db.collection(AppConstants.schemesCollection).limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = _db.batch();
    for (final scheme in AppConstants.demoSchemes) {
      batch.set(_db.collection(AppConstants.schemesCollection).doc(scheme.id), scheme.toMap());
    }
    await batch.commit();
  }

  Future<void> saveScheme(String userId, String schemeId) async {
    await _db.collection(AppConstants.savedSchemesCollection).doc('${userId}_$schemeId').set({
      'userId': userId,
      'schemeId': schemeId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsaveScheme(String userId, String schemeId) async {
    await _db.collection(AppConstants.savedSchemesCollection).doc('${userId}_$schemeId').delete();
  }

  Future<List<String>> getSavedSchemeIds(String userId) async {
    final snapshot = await _db
        .collection(AppConstants.savedSchemesCollection)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()['schemeId'] as String).toList();
  }
}
