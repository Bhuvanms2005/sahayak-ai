import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/scheme_model.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────

  Future<void> createUser(UserModel user) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .update(user.toMap());
  }

  // ── Schemes ────────────────────────────────────────────

  Future<List<SchemeModel>> getAllSchemes() async {
    final snapshot = await _db
        .collection(AppConstants.schemesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SchemeModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<SchemeModel>> getSchemesByCategory(String category) async {
    final snapshot = await _db
        .collection(AppConstants.schemesCollection)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => SchemeModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<SchemeModel?> getScheme(String id) async {
    final doc = await _db
        .collection(AppConstants.schemesCollection)
        .doc(id)
        .get();
    if (!doc.exists) return null;
    return SchemeModel.fromMap(doc.data()!, doc.id);
  }

  Future<List<SchemeModel>> searchSchemes(String query) async {
    final snapshot = await _db
        .collection(AppConstants.schemesCollection)
        .where('isActive', isEqualTo: true)
        .get();

    final lowerQuery = query.toLowerCase();
    return snapshot.docs
        .map((doc) => SchemeModel.fromMap(doc.data(), doc.id))
        .where((scheme) =>
            scheme.name.toLowerCase().contains(lowerQuery) ||
            scheme.description.toLowerCase().contains(lowerQuery) ||
            scheme.category.toLowerCase().contains(lowerQuery) ||
            scheme.targetGroups.any(
              (g) => g.toLowerCase().contains(lowerQuery),
            ))
        .toList();
  }

  // Seed sample schemes (call once)
  Future<void> seedSchemes() async {
    final existing = await _db
        .collection(AppConstants.schemesCollection)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return;

    final batch = _db.batch();
    for (final schemeData in SampleSchemes.data) {
      final docRef = _db.collection(AppConstants.schemesCollection).doc();
      final scheme = {
        ...schemeData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'viewCount': 0,
      };
      batch.set(docRef, scheme);
    }
    await batch.commit();
  }

  // ── Saved Schemes ──────────────────────────────────────

  Future<void> saveScheme(String userId, String schemeId) async {
    await _db
        .collection(AppConstants.savedSchemesCollection)
        .doc('${userId}_$schemeId')
        .set({
      'userId': userId,
      'schemeId': schemeId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsaveScheme(String userId, String schemeId) async {
    await _db
        .collection(AppConstants.savedSchemesCollection)
        .doc('${userId}_$schemeId')
        .delete();
  }

  Future<bool> isSchemeaved(String userId, String schemeId) async {
    final doc = await _db
        .collection(AppConstants.savedSchemesCollection)
        .doc('${userId}_$schemeId')
        .get();
    return doc.exists;
  }

  Future<List<String>> getSavedSchemeIds(String userId) async {
    final snapshot = await _db
        .collection(AppConstants.savedSchemesCollection)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => doc.data()['schemeId'] as String)
        .toList();
  }

  Stream<List<String>> savedSchemeIdsStream(String userId) {
    return _db
        .collection(AppConstants.savedSchemesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()['schemeId'] as String).toList());
  }

  // ── View Count ─────────────────────────────────────────

  Future<void> incrementViewCount(String schemeId) async {
    await _db
        .collection(AppConstants.schemesCollection)
        .doc(schemeId)
        .update({'viewCount': FieldValue.increment(1)});
  }
}