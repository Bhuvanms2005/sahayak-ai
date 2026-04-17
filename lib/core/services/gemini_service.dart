import 'package:google_generative_ai/google_generative_ai.dart';

import '../constants/app_constants.dart';

class GeminiService {
  GeminiService({
    String apiKey = AppConstants.geminiApiKey,
    String languageCode = 'en',
  })  : _apiKey = apiKey,
        _languageCode = languageCode;

  final String _apiKey;
  final String _languageCode;

  /// Returns a response from Gemini, using the current language in the system
  /// prompt. Falls back to a built-in offline response when no API key is set.
  Future<String> getAIResponse(String prompt) async {
    if (_apiKey == AppConstants.geminiApiKey || _apiKey.trim().isEmpty) {
      return _offlineResponse(prompt);
    }

    try {
      final model = GenerativeModel(
        model: AppConstants.geminiModel,
        apiKey: _apiKey,
        systemInstruction: Content.system(
          AppConstants.systemPromptForLanguage(_languageCode),
        ),
      );
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim().isNotEmpty == true
          ? response.text!.trim()
          : 'I could not generate a response. Try adding more profile details.';
    } catch (e) {
      return 'Gemini is unavailable right now. '
          'As a next step: search by category on the Home screen, '
          'open a scheme card, and verify eligibility documents before applying.\n'
          'Error: $e';
    }
  }

  String _offlineResponse(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('student') || lower.contains('education') ||
        lower.contains('scholarship') || lower.contains('college')) {
      return 'You may be a fit for National Scholarship Portal schemes. '
          'Keep Aadhaar, income certificate, marksheets, and bank details ready. '
          'Share your state, course, category, and annual family income for a sharper recommendation.';
    }
    if (lower.contains('farmer') || lower.contains('agriculture') ||
        lower.contains('kisan') || lower.contains('crop')) {
      return 'PM-KISAN and state agriculture subsidy schemes are worth checking. '
          'Land records, Aadhaar, bank details, and mobile verification are usually required.';
    }
    if (lower.contains('health') || lower.contains('hospital') ||
        lower.contains('medical') || lower.contains('ayushman')) {
      return 'Ayushman Bharat PM-JAY can help eligible families get cashless hospital care up to ₹5 lakh per year. '
          'Confirm eligibility through the PM-JAY portal or an empanelled hospital helpdesk.';
    }
    if (lower.contains('house') || lower.contains('home') ||
        lower.contains('awas') || lower.contains('housing')) {
      return 'Pradhan Mantri Awas Yojana (PMAY) provides housing assistance for eligible households. '
          'Keep Aadhaar, income certificate, address proof, and bank details ready.';
    }
    if (lower.contains('business') || lower.contains('startup') ||
        lower.contains('loan') || lower.contains('mudra')) {
      return 'PM Mudra Yojana offers collateral-free loans up to ₹10 lakh for micro-enterprises. '
          'Approach your nearest bank or MFI with a business plan, identity proof, and bank statements.';
    }
    if (lower.contains('senior') || lower.contains('old age') ||
        lower.contains('pension') || lower.contains('elderly')) {
      return 'The Indira Gandhi National Old Age Pension Scheme provides monthly support for BPL senior citizens aged 60+. '
          'Contact your local Gram Panchayat or Block Development Office to apply.';
    }
    if (lower.contains('women') || lower.contains('girl') ||
        lower.contains('daughter') || lower.contains('sukanya')) {
      return 'Sukanya Samriddhi Yojana is a great savings scheme for girl children under 10. '
          'Open an account at any post office or authorised bank with the child\'s birth certificate and guardian ID.';
    }
    return 'Namaste! Tell me your age, state, occupation, annual income, and category (General/OBC/SC/ST). '
        'I will suggest relevant schemes, check likely eligibility, and guide you on documents and application steps.';
  }
}