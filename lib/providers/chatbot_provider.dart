import 'package:flutter/material.dart';

import '../core/services/gemini_service.dart';
import '../models/chat_message_model.dart';

class ChatbotProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final List<ChatMessage> _messages = [
    ChatMessage.assistant(
      'Namaste. I am Sahayak AI. Tell me your profile or goal, and I will help you find relevant government schemes.',
    ),
  ];
  bool _isSending = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isSending => _isSending;

  Future<void> sendMessage(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty || _isSending) return;
    _messages.add(ChatMessage.user(prompt));
    _messages.add(ChatMessage.loading());
    _isSending = true;
    notifyListeners();

    final response = await _geminiService.getAIResponse(prompt);
    _messages.removeWhere((message) => message.isLoading);
    _messages.add(ChatMessage.assistant(response));
    _isSending = false;
    notifyListeners();
  }

  void clear() {
    _messages
      ..clear()
      ..add(ChatMessage.assistant('Fresh chat started. What kind of support do you need today?'));
    notifyListeners();
  }
}
