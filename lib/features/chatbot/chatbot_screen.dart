import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/chat_message_model.dart';
import '../../providers/chatbot_provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatbotProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahayak AI Assistant'),
        actions: [IconButton(onPressed: chat.clear, icon: const Icon(Icons.refresh_rounded))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) => _Bubble(message: chat.messages[index]),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Ask about eligibility, documents, or schemes...'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: chat.isSending
                        ? null
                        : () {
                            chat.sendMessage(_controller.text);
                            _controller.clear();
                          },
                    style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.all(16)),
                    child: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 8))],
        ),
        child: message.isLoading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(
                message.content,
                style: TextStyle(color: isUser ? Colors.white : AppTheme.ink, height: 1.45),
              ),
      ),
    );
  }
}
