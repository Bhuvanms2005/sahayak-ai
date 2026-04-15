class AppConstants {
  // App Info
  static const String appName = 'Sahayak AI';
  static const String appTagline = 'Your Government Scheme Navigator';
  static const String teamName = 'IntelliFusion';
  static const String appVersion = '1.0.0';

  // Gemini
  static const String geminiModel = 'gemini-1.5-flash';
  static const int geminiMaxTokens = 2048;
  static const double geminiTemperature = 0.7;

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String schemesCollection = 'schemes';
  static const String savedSchemesCollection = 'saved_schemes';
  static const String chatHistoryCollection = 'chat_history';
  static const String notificationsCollection = 'notifications';

  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyUserProfile = 'user_profile';

  // Scheme Categories
  static const List<String> schemeCategories = [
    'Agriculture',
    'Education',
    'Health',
    'Housing',
    'Employment',
    'Women',
    'Senior Citizens',
    'Startup',
    'Social Welfare',
    'Financial Inclusion',
  ];

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'kn': 'ಕನ್ನಡ',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'bn': 'বাংলা',
    'gu': 'ગુજરાતી',
  };

  // Gemini System Prompt
  static const String geminiSystemPrompt = '''
You are Sahayak AI, an expert assistant for Indian government welfare schemes. 
Your role is to help citizens discover, understand, and apply for government schemes.

GUIDELINES:
- Always respond in a friendly, clear, and simple language
- Provide accurate information about government schemes
- When recommending schemes, always structure your response as follows:

**Scheme Name:** [Name]
**Eligibility Status:** [Eligible/Not Eligible/Partially Eligible]
**Key Benefits:** [List main benefits]
**Required Documents:** [List documents]
**Application Steps:** [Step-by-step guide]
**Official Link:** [URL if available]

- If the user is not eligible, explain why and suggest alternative schemes
- Always prioritize schemes that are currently active
- Be sensitive to the user's socio-economic background
- If asked in Hindi or regional languages, respond in that language
- Never make up scheme details — only provide verified information
''';

  // Sample Scheme Prompt Template
  static const String schemeRecommendationPrompt = '''
Based on the following user profile, recommend the most relevant Indian government schemes:

User Profile:
- Name: {name}
- Age: {age}
- Gender: {gender}
- State: {state}
- Occupation: {occupation}
- Annual Income: ₹{income}
- Category: {category}
- Education: {education}

Please provide top 5 most relevant schemes with complete details.
''';
}