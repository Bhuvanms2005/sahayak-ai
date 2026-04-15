import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthProvider() {
    _bootstrap();
  }

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get canUseFirebase => Firebase.apps.isNotEmpty;

  void _bootstrap() {
    if (!canUseFirebase) {
      _status = AuthStatus.unauthenticated;
      return;
    }
    fb.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = await _loadOrCreateUser(firebaseUser);
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<UserModel> _loadOrCreateUser(fb.User firebaseUser) async {
    final existing = await _firestore.getUser(firebaseUser.uid);
    if (existing != null) return existing;
    final created = UserModel(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'Citizen',
      email: firebaseUser.email ?? '',
      createdAt: DateTime.now(),
    );
    await _firestore.createUser(created);
    return created;
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading();
    try {
      if (canUseFirebase) {
        final credential = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        _user = await _loadOrCreateUser(credential.user!);
      } else {
        _user = _demoUser(email);
      }
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _setError(_friendlyAuthError(e));
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      if (canUseFirebase) {
        final credential = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        await credential.user?.updateDisplayName(name);
        _user = UserModel(
          uid: credential.user!.uid,
          name: name,
          email: email.trim(),
          createdAt: DateTime.now(),
        );
        await _firestore.createUser(_user!);
      } else {
        _user = _demoUser(email, name: name);
      }
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _setError(_friendlyAuthError(e));
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading();
    try {
      if (canUseFirebase) {
        await fb.FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      }
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    if (canUseFirebase) await fb.FirebaseAuth.instance.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _user = updatedUser.copyWith(updatedAt: DateTime.now());
    notifyListeners();
    if (canUseFirebase) await _firestore.updateUser(_user!);
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    }
    notifyListeners();
  }

  UserModel _demoUser(String email, {String name = 'Demo Citizen'}) {
    return UserModel(
      uid: 'demo-user',
      name: name,
      email: email.trim().isEmpty ? 'demo@sahayak.ai' : email.trim(),
      state: 'Karnataka',
      occupation: 'Student',
      annualIncome: 240000,
      category: 'General',
      createdAt: DateTime.now(),
    );
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _friendlyAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account exists for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Use at least 6 characters for the password.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
