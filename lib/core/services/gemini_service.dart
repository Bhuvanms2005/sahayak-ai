import 'package:google_generative_ai/google_generative_ai.dart';

import '../constants/app_constants.dart';

class GeminiService {
  GeminiService({String apiKey = AppConstants.geminiApiKey}) : _apiKey = apiKey;

  final String _apiKey;

  Future<String> getAIResponse(String prompt) async {
    if (_apiKey == AppConstants.geminiApiKey || _apiKey.trim().isEmpty) {
      return _offlineResponse(prompt);
    }

    try {
      final model = GenerativeModel(
        model: AppConstants.geminiModel,
        apiKey: _apiKey,
        systemInstruction: Content.system(AppConstants.systemPrompt),
      );
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim().isNotEmpty == true
          ? response.text!.trim()
          : 'I could not generate a response. Try adding more profile details.';
    } catch (e) {
      return 'Gemini is unavailable right now, so here is a safe next step: search by category, open a scheme card, and verify eligibility documents before applying. Error: $e';
    }
  }

  String _offlineResponse(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('student') || lower.contains('education')) {
      return 'You may be a fit for National Scholarship Portal schemes. Keep Aadhaar, income certificate, marksheets, and bank details ready. Share your state, course, category, and annual family income for a sharper recommendation.';
    }
    if (lower.contains('farmer') || lower.contains('agriculture')) {
      return 'PM-KISAN and state agriculture subsidy schemes are worth checking. Land records, Aadhaar, bank details, and mobile verification are usually important.';
    }
    if (lower.contains('health') || lower.contains('hospital')) {
      return 'Ayushman Bharat PM-JAY can help eligible families get cashless hospital care. Confirm eligibility through the PM-JAY portal or an empanelled hospital helpdesk.';
    }
    return 'Tell me your age, state, occupation, annual income, category, and goal. I will suggest relevant schemes, likely eligibility, documents, and application steps.';
  }
}
