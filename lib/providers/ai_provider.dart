import 'package:flutter/material.dart';

import '../core/services/gemini_service.dart';
import '../models/chat_message_model.dart';
import '../models/scheme_model.dart';
import '../models/user_model.dart';

class AiProvider extends ChangeNotifier {
  GeminiService _geminiService = GeminiService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _eligibilityResult;
  bool _isCheckingEligibility = false;
  String _currentLanguageCode = 'en';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get eligibilityResult => _eligibilityResult;
  bool get isCheckingEligibility => _isCheckingEligibility;

  AiProvider() {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage.assistant(
      'Namaste! 🙏 I am Sahayak AI, your personal Government Scheme Assistant.\n\n'
      'I can help you:\n'
      '• Discover government schemes suitable for you\n'
      '• Check your eligibility for specific schemes\n'
      '• Understand application procedures\n'
      '• Find nearby assistance centers\n\n'
      'Tell me about yourself or ask me about any government scheme!',
    ));
  }

  /// Updates the language so the next Gemini call uses the correct system prompt.
  void updateLanguage(String languageCode) {
    if (_currentLanguageCode == languageCode) return;
    _currentLanguageCode = languageCode;
    _geminiService = GeminiService(languageCode: languageCode);
  }

  Future<void> sendMessage(String userMessage, {UserModel? user}) async {
    if (userMessage.trim().isEmpty) return;

    _messages.add(ChatMessage.user(userMessage));
    _messages.add(ChatMessage.loading());
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String contextualMessage = userMessage;
      if (user != null && user.isProfileComplete) {
        contextualMessage =
            '$userMessage\n\n[User Context: ${user.profileSummary}]';
      }

      final response = await _geminiService.getAIResponse(contextualMessage);
      _messages.removeWhere((m) => m.isLoading);
      _messages.add(ChatMessage.assistant(response));
    } catch (e) {
      _messages.removeWhere((m) => m.isLoading);
      _messages.add(ChatMessage.error(
        'Sorry, I encountered an error. Please try again.\n${e.toString()}',
      ));
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPersonalizedRecommendations(UserModel user) async {
    final prompt =
        'Recommend top 5 Indian government schemes for: ${user.profileSummary}';
    await sendMessage(prompt, user: user);
  }

  Future<String?> checkEligibility({
    required SchemeModel scheme,
    required UserModel user,
  }) async {
    _isCheckingEligibility = true;
    _eligibilityResult = null;
    notifyListeners();

    try {
      final prompt = '''
Check eligibility for "${scheme.name}".
Eligibility criteria: ${scheme.eligibility}
User profile: ${user.profileSummary}
Please provide: eligibility status, matching criteria, gaps, required documents, and next steps.
''';
      final result = await _geminiService.getAIResponse(prompt);
      _eligibilityResult = result;
      return result;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isCheckingEligibility = false;
      notifyListeners();
    }
  }

  Future<String?> explainScheme(SchemeModel scheme) async {
    try {
      final prompt =
          'Explain "${scheme.name}" in simple, friendly language for a first-time applicant. '
          'Benefits: ${scheme.benefits}. How to apply: ${scheme.applicationMode}.';
      return await _geminiService.getAIResponse(prompt);
    } catch (e) {
      return null;
    }
  }

  void clearChat() {
    _messages.clear();
    _addWelcomeMessage();
    _error = null;
    notifyListeners();
  }

  void clearEligibilityResult() {
    _eligibilityResult = null;
    notifyListeners();
  }
}