import 'package:flutter/material.dart';

import '../models/scheme_model.dart';
import '../models/user_model.dart';

class EligibilityResult {
  final int score;
  final List<String> matches;
  final List<String> gaps;

  const EligibilityResult({
    required this.score,
    required this.matches,
    required this.gaps,
  });
}

class EligibilityProvider extends ChangeNotifier {
  EligibilityResult? _result;
  bool _isChecking = false;

  EligibilityResult? get result => _result;
  bool get isChecking => _isChecking;

  Future<void> checkEligibility({
    required SchemeModel scheme,
    required UserModel? user,
    required int age,
    required double income,
    required String occupation,
    required String category,
  }) async {
    _isChecking = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final matches = <String>[];
    final gaps = <String>[];
    var score = 45;

    if (scheme.targetGroups.any((g) => g.toLowerCase().contains(occupation.toLowerCase()))) {
      score += 20;
      matches.add('Your occupation aligns with the target group.');
    } else {
      gaps.add('Occupation match is unclear; verify the scheme-specific category.');
    }
    if (income <= 300000) {
      score += 15;
      matches.add('Income range fits many welfare scheme requirements.');
    } else {
      gaps.add('Income may exceed limits for some subsidy components.');
    }
    if (age >= 18 || scheme.category == 'Education') {
      score += 10;
      matches.add('Age information is broadly acceptable for this scheme.');
    }
    if (category.isNotEmpty) {
      score += 10;
      matches.add('Category details are available for reserved benefits checks.');
    }

    _result = EligibilityResult(
      score: score.clamp(0, 100),
      matches: matches,
      gaps: gaps.isEmpty ? ['Keep original documents ready before applying.'] : gaps,
    );
    _isChecking = false;
    notifyListeners();
  }

  void reset() {
    _result = null;
    notifyListeners();
  }
}
