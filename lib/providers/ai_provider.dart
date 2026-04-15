import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../models/scheme_model.dart';

class AiProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService.instance;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _eligibilityResult;
  bool _isCheckingEligibility = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get eligibilityResult => _eligibilityResult;
  bool get isCheckingEligibility => _isCheckingEligibility;

  AiProvider() {
    _initGemini();
    _addWelcomeMessage();
  }

  void _initGemini() {
    try {
      _geminiService.initialize();
      _geminiService.startNewChat();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage.assistant(
      'Namaste! 🙏 I am Sahayak AI, your personal Government Scheme Assistant.\n\n'
      'I can help you:\n'
      '• **Discover** government schemes suitable for you\n'
      '• **Check** your eligibility for specific schemes\n'
      '• **Understand** application procedures\n'
      '• **Find** nearby assistance centers\n\n'
      'Tell me about yourself or ask me about any government scheme!',
    ));
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

      final response = await _geminiService.sendMessage(contextualMessage);
      _messages.removeLast(); // remove loading
      _messages.add(ChatMessage.assistant(response));
    } catch (e) {
      _messages.removeLast();
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
    _messages.add(ChatMessage.user(
      'Please recommend government schemes based on my profile.',
    ));
    _messages.add(ChatMessage.loading());
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _geminiService.getSchemeRecommendations(user);
      _messages.removeLast();
      _messages.add(ChatMessage.assistant(response));
    } catch (e) {
      _messages.removeLast();
      _messages.add(ChatMessage.error('Failed to get recommendations: $e'));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> checkEligibility({
    required SchemeModel scheme,
    required UserModel user,
  }) async {
    _isCheckingEligibility = true;
    _eligibilityResult = null;
    notifyListeners();

    try {
      final result = await _geminiService.checkEligibility(
        schemeName: scheme.name,
        user: user,
        eligibilityCriteria: scheme.eligibilityCriteria,
      );
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
      return await _geminiService.explainScheme(
        scheme.name,
        scheme.description,
      );
    } catch (e) {
      return null;
    }
  }

  void clearChat() {
    _messages.clear();
    _geminiService.startNewChat();
    _addWelcomeMessage();
    _error = null;
    notifyListeners();
  }

  void clearEligibilityResult() {
    _eligibilityResult = null;
    notifyListeners();
  }
}