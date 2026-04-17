import 'package:flutter/material.dart';

import '../core/services/gemini_service.dart';
import '../models/chat_message_model.dart';

class ChatbotProvider extends ChangeNotifier {
  GeminiService _geminiService = GeminiService();
  final List<ChatMessage> _messages = [
    ChatMessage.assistant(
      'Namaste! 🙏 I am Sahayak AI.\n\n'
      'Tell me your profile or goal and I will help you find relevant '
      'government schemes, check eligibility, and guide you through the application process.',
    ),
  ];
  bool _isSending = false;
  String _currentLanguageCode = 'en';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isSending => _isSending;

  /// Call this whenever the user changes their language so the next Gemini
  /// request uses the correct system prompt.
  void updateLanguage(String languageCode) {
    if (_currentLanguageCode == languageCode) return;
    _currentLanguageCode = languageCode;
    _geminiService = GeminiService(languageCode: languageCode);
    // Don't clear messages — just silently update for future requests.
  }

  Future<void> sendMessage(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty || _isSending) return;
    _messages.add(ChatMessage.user(prompt));
    _messages.add(ChatMessage.loading());
    _isSending = true;
    notifyListeners();

    final response = await _geminiService.getAIResponse(prompt);
    _messages.removeWhere((m) => m.isLoading);
    _messages.add(ChatMessage.assistant(response));
    _isSending = false;
    notifyListeners();
  }

  void clear() {
    _messages
      ..clear()
      ..add(ChatMessage.assistant(
          'Fresh chat started. 🙏\nWhat kind of government scheme support do you need today?'));
    notifyListeners();
  }
}