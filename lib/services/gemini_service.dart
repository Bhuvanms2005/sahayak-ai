import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class GeminiService {
  static GeminiService? _instance;
  GenerativeModel? _model;
  ChatSession? _chatSession;

  GeminiService._();

  static GeminiService get instance {
    _instance ??= GeminiService._();
    return _instance!;
  }

  void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      throw Exception(
        'GEMINI_API_KEY not set. Please update your .env file.',
      );
    }

    _model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: AppConstants.geminiMaxTokens,
        temperature: AppConstants.geminiTemperature,
        topP: 0.95,
        topK: 40,
      ),
      systemInstruction: Content.system(AppConstants.geminiSystemPrompt),
    );
  }

  void startNewChat() {
    if (_model == null) initialize();
    _chatSession = _model!.startChat();
  }

  Future<String> sendMessage(String message) async {
    if (_model == null) initialize();
    _chatSession ??= _model!.startChat();

    try {
      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );
      return response.text ?? 'Sorry, I could not generate a response.';
    } on GenerativeAIException catch (e) {
      throw Exception('Gemini AI Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get response: $e');
    }
  }

  Future<String> getSchemeRecommendations(UserModel user) async {
    if (_model == null) initialize();

    final prompt = AppConstants.schemeRecommendationPrompt
        .replaceAll('{name}', user.name)
        .replaceAll('{age}', user.age?.toString() ?? 'Not specified')
        .replaceAll('{gender}', user.gender ?? 'Not specified')
        .replaceAll('{state}', user.state ?? 'Not specified')
        .replaceAll('{occupation}', user.occupation ?? 'Not specified')
        .replaceAll('{income}', user.annualIncome?.toStringAsFixed(0) ?? 'Not specified')
        .replaceAll('{category}', user.category ?? 'General')
        .replaceAll('{education}', user.education ?? 'Not specified');

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Unable to fetch recommendations.';
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }

  Future<String> checkEligibility({
    required String schemeName,
    required UserModel user,
    required List<String> eligibilityCriteria,
  }) async {
    if (_model == null) initialize();

    final prompt = '''
Check if the following user is eligible for "$schemeName".

Eligibility Criteria:
${eligibilityCriteria.map((e) => '- $e').join('\n')}

User Profile:
${user.profileSummary}

Please provide:
1. Eligibility Status (Eligible/Not Eligible/Partially Eligible)
2. Matching criteria
3. Missing criteria (if any)
4. Tips to become eligible (if not eligible)
5. Next steps (if eligible)

Keep the response concise and helpful.
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Unable to check eligibility.';
    } catch (e) {
      throw Exception('Failed to check eligibility: $e');
    }
  }

  Future<String> explainScheme(String schemeName, String description) async {
    if (_model == null) initialize();

    final prompt = '''
Explain the "$schemeName" government scheme in simple, easy-to-understand language.

Description: $description

Please provide:
1. What is this scheme?
2. Who should apply?
3. Key benefits in simple terms
4. How to apply (simplified steps)

Keep it conversational and friendly.
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Unable to explain the scheme.';
    } catch (e) {
      throw Exception('Failed to explain scheme: $e');
    }
  }
}