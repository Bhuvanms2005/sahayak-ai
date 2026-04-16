import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in Sahayak AI
class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class LanguageProvider extends ChangeNotifier {
  static const _keyLanguageCode = 'language_code';
  static const _keyLanguageSelected = 'language_selected';

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    AppLanguage(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
    AppLanguage(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
    AppLanguage(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
    AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇮🇳'),
    AppLanguage(code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
    AppLanguage(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
    AppLanguage(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳'),
    AppLanguage(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳'),
  ];

  String _currentCode = 'en';
  bool _hasSelectedLanguage = false;

  String get currentCode => _currentCode;
  bool get hasSelectedLanguage => _hasSelectedLanguage;

  AppLanguage get currentLanguage =>
      supportedLanguages.firstWhere((l) => l.code == _currentCode,
          orElse: () => supportedLanguages.first);

  LanguageProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCode = prefs.getString(_keyLanguageCode) ?? 'en';
    _hasSelectedLanguage = prefs.getBool(_keyLanguageSelected) ?? false;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _currentCode = code;
    _hasSelectedLanguage = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, code);
    await prefs.setBool(_keyLanguageSelected, true);
    notifyListeners();
  }

  /// Returns a Locale for this language code
  Locale get locale => Locale(_currentCode);

  /// UI strings translated per language. Falls back to English.
  String t(String key) {
    final map = _translations[_currentCode] ?? _translations['en']!;
    return map[key] ?? _translations['en']![key] ?? key;
  }

  /// All in-app UI translations
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'appName': 'Sahayak AI',
      'tagline': 'Your Government Scheme Navigator',
      'home': 'Home',
      'explore': 'Explore',
      'assistant': 'AI',
      'eligibility': 'Check',
      'profile': 'Profile',
      'searchHint': 'Search scholarships, health, housing...',
      'recommended': 'Recommended schemes',
      'viewAll': 'View all',
      'hello': 'Hello',
      'noSchemes': 'No schemes found',
      'tryDifferent': 'Try a different keyword or category.',
      'savedSchemes': 'Saved schemes',
      'noSaved': 'No saved schemes',
      'noSavedMsg': 'Save schemes from Home or Explore to track them here.',
      'logout': 'Logout',
      'completeProfile': 'Complete Profile',
      'language': 'Language',
      'changeLanguage': 'Change Language',
      'selectLanguage': 'Select Language',
      'languageSubtitle': 'Choose your preferred language',
      'continueBtn': 'Continue',
      'darkMode': 'Dark Mode',
      'notifications': 'Notifications',
      'settings': 'Settings',
      'help': 'Help & Support',
      'aboutApp': 'About Sahayak AI',
      'version': 'Version',
      'schemeDetails': 'Scheme Details',
      'eligibilityChecker': 'Eligibility Checker',
      'aiAssistant': 'AI Assistant',
      'typeMessage': 'Ask about eligibility, documents, or schemes...',
      'send': 'Send',
      'clearChat': 'Clear Chat',
      'apply': 'Apply Now',
      'benefits': 'Benefits',
      'requiredDocs': 'Required Documents',
      'howToApply': 'How to Apply',
      'deadline': 'Deadline',
      'ministry': 'Ministry',
      'targetGroup': 'Target Group',
      'checkEligibility': 'Check My Eligibility',
      'tracker': 'Progress Tracker',
      'applicationStatus': 'Application Status',
      'notStarted': 'Not Started',
      'inProgress': 'In Progress',
      'submitted': 'Submitted',
      'approved': 'Approved',
      'rejected': 'Rejected',
      'markAs': 'Mark As',
      'myApplications': 'My Applications',
      'noApplications': 'No applications tracked',
      'noApplicationsMsg': 'Start tracking your scheme applications here.',
      'addToTracker': 'Track Application',
      'voiceInput': 'Voice Input',
      'listening': 'Listening...',
      'tapToSpeak': 'Tap to speak',
    },
    'hi': {
      'appName': 'सहायक AI',
      'tagline': 'आपका सरकारी योजना नेवीगेटर',
      'home': 'होम',
      'explore': 'खोजें',
      'assistant': 'AI',
      'eligibility': 'जांचें',
      'profile': 'प्रोफ़ाइल',
      'searchHint': 'छात्रवृत्ति, स्वास्थ्य, आवास खोजें...',
      'recommended': 'अनुशंसित योजनाएँ',
      'viewAll': 'सभी देखें',
      'hello': 'नमस्ते',
      'noSchemes': 'कोई योजना नहीं मिली',
      'tryDifferent': 'कोई अलग कीवर्ड या श्रेणी आज़माएँ।',
      'savedSchemes': 'सहेजी गई योजनाएँ',
      'noSaved': 'कोई सहेजी गई योजना नहीं',
      'noSavedMsg': 'होम या एक्सप्लोर से योजनाएँ सहेजें।',
      'logout': 'लॉग आउट',
      'completeProfile': 'प्रोफ़ाइल पूर्ण करें',
      'language': 'भाषा',
      'changeLanguage': 'भाषा बदलें',
      'selectLanguage': 'भाषा चुनें',
      'languageSubtitle': 'अपनी पसंदीदा भाषा चुनें',
      'continueBtn': 'जारी रखें',
      'darkMode': 'डार्क मोड',
      'notifications': 'सूचनाएँ',
      'settings': 'सेटिंग्स',
      'help': 'सहायता',
      'aboutApp': 'सहायक AI के बारे में',
      'version': 'संस्करण',
      'schemeDetails': 'योजना विवरण',
      'eligibilityChecker': 'पात्रता जाँचकर्ता',
      'aiAssistant': 'AI सहायक',
      'typeMessage': 'पात्रता, दस्तावेज़ या योजनाओं के बारे में पूछें...',
      'send': 'भेजें',
      'clearChat': 'चैट साफ़ करें',
      'apply': 'अभी आवेदन करें',
      'benefits': 'लाभ',
      'requiredDocs': 'आवश्यक दस्तावेज़',
      'howToApply': 'आवेदन कैसे करें',
      'deadline': 'अंतिम तिथि',
      'ministry': 'मंत्रालय',
      'targetGroup': 'लक्षित समूह',
      'checkEligibility': 'पात्रता जांचें',
      'tracker': 'प्रगति ट्रैकर',
      'applicationStatus': 'आवेदन स्थिति',
      'notStarted': 'शुरू नहीं हुआ',
      'inProgress': 'प्रगति में',
      'submitted': 'जमा किया गया',
      'approved': 'स्वीकृत',
      'rejected': 'अस्वीकृत',
      'markAs': 'इस रूप में चिह्नित करें',
      'myApplications': 'मेरे आवेदन',
      'noApplications': 'कोई आवेदन ट्रैक नहीं',
      'noApplicationsMsg': 'यहाँ अपनी योजना के आवेदनों को ट्रैक करें।',
      'addToTracker': 'आवेदन ट्रैक करें',
      'voiceInput': 'वॉइस इनपुट',
      'listening': 'सुन रहा है...',
      'tapToSpeak': 'बोलने के लिए टैप करें',
    },
    'kn': {
      'appName': 'ಸಹಾಯಕ AI',
      'tagline': 'ನಿಮ್ಮ ಸರ್ಕಾರಿ ಯೋಜನೆ ನ್ಯಾವಿಗೇಟರ್',
      'home': 'ಮನೆ',
      'explore': 'ಅನ್ವೇಷಿಸಿ',
      'assistant': 'AI',
      'eligibility': 'ಪರಿಶೀಲಿಸಿ',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'searchHint': 'ವಿದ್ಯಾರ್ಥಿವೇತನ, ಆರೋಗ್ಯ, ವಸತಿ ಹುಡುಕಿ...',
      'recommended': 'ಶಿಫಾರಸು ಮಾಡಲಾದ ಯೋಜನೆಗಳು',
      'viewAll': 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ',
      'hello': 'ನಮಸ್ಕಾರ',
      'noSchemes': 'ಯಾವುದೇ ಯೋಜನೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ',
      'tryDifferent': 'ಬೇರೆ ಕೀವರ್ಡ್ ಅಥವಾ ವರ್ಗ ಪ್ರಯತ್ನಿಸಿ.',
      'savedSchemes': 'ಉಳಿಸಿದ ಯೋಜನೆಗಳು',
      'noSaved': 'ಯಾವುದೇ ಉಳಿಸಿದ ಯೋಜನೆಗಳಿಲ್ಲ',
      'noSavedMsg': 'ಮನೆ ಅಥವಾ ಅನ್ವೇಷಣೆಯಿಂದ ಯೋಜನೆಗಳನ್ನು ಉಳಿಸಿ.',
      'logout': 'ಲಾಗ್ ಔಟ್',
      'completeProfile': 'ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಿ',
      'language': 'ಭಾಷೆ',
      'changeLanguage': 'ಭಾಷೆ ಬದಲಾಯಿಸಿ',
      'selectLanguage': 'ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ',
      'languageSubtitle': 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿ',
      'continueBtn': 'ಮುಂದುವರಿಸಿ',
      'darkMode': 'ಡಾರ್ಕ್ ಮೋಡ್',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'help': 'ಸಹಾಯ',
      'myApplications': 'ನನ್ನ ಅರ್ಜಿಗಳು',
      'addToTracker': 'ಅರ್ಜಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ',
      'apply': 'ಈಗ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
      'benefits': 'ಪ್ರಯೋಜನಗಳು',
      'checkEligibility': 'ಅರ್ಹತೆ ಪರಿಶೀಲಿಸಿ',
      'voiceInput': 'ಧ್ವನಿ ಇನ್‌ಪುಟ್',
      'listening': 'ಆಲಿಸುತ್ತಿದ್ದೇನೆ...',
      'tapToSpeak': 'ಮಾತನಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ',
    },
    'ta': {
      'appName': 'சகாயக் AI',
      'tagline': 'உங்கள் அரசு திட்ட வழிகாட்டி',
      'home': 'முகப்பு',
      'explore': 'ஆராய்',
      'assistant': 'AI',
      'eligibility': 'சரிபார்',
      'profile': 'சுயவிவரம்',
      'searchHint': 'உதவித்தொகை, சுகாதாரம், வீட்டுவசதி தேடுங்கள்...',
      'recommended': 'பரிந்துரைக்கப்பட்ட திட்டங்கள்',
      'viewAll': 'அனைத்தையும் காண்க',
      'hello': 'வணக்கம்',
      'noSchemes': 'திட்டங்கள் எதுவும் கிடைக்கவில்லை',
      'logout': 'வெளியேறு',
      'language': 'மொழி',
      'changeLanguage': 'மொழி மாற்றவும்',
      'selectLanguage': 'மொழியை தேர்ந்தெடுக்கவும்',
      'continueBtn': 'தொடரவும்',
      'apply': 'இப்போது விண்ணப்பிக்கவும்',
      'benefits': 'நன்மைகள்',
      'checkEligibility': 'தகுதியை சரிபார்க்கவும்',
      'myApplications': 'என் விண்ணப்பங்கள்',
      'addToTracker': 'விண்ணப்பத்தை கண்காணி',
      'voiceInput': 'குரல் உள்ளீடு',
      'listening': 'கேட்கிறது...',
      'tapToSpeak': 'பேசுவதற்கு தட்டவும்',
    },
    'te': {
      'appName': 'సహాయక్ AI',
      'tagline': 'మీ ప్రభుత్వ పథకం నావిగేటర్',
      'home': 'హోమ్',
      'explore': 'అన్వేషించు',
      'assistant': 'AI',
      'eligibility': 'తనిఖీ',
      'profile': 'ప్రొఫైల్',
      'searchHint': 'స్కాలర్‌షిప్‌లు, ఆరోగ్యం, గృహాలు వెతకండి...',
      'recommended': 'సిఫారసు చేయబడిన పథకాలు',
      'viewAll': 'అన్నీ చూడండి',
      'hello': 'నమస్కారం',
      'noSchemes': 'పథకాలు కనుగొనబడలేదు',
      'logout': 'లాగ్ అవుట్',
      'language': 'భాష',
      'changeLanguage': 'భాష మార్చండి',
      'selectLanguage': 'భాష ఎంచుకోండి',
      'continueBtn': 'కొనసాగించు',
      'apply': 'ఇప్పుడు దరఖాస్తు చేయండి',
      'benefits': 'ప్రయోజనాలు',
      'checkEligibility': 'అర్హతను తనిఖీ చేయండి',
      'myApplications': 'నా దరఖాస్తులు',
      'addToTracker': 'దరఖాస్తును ట్రాక్ చేయండి',
      'voiceInput': 'వాయిస్ ఇన్‌పుట్',
      'listening': 'వింటున్నాను...',
      'tapToSpeak': 'మాట్లాడటానికి నొక్కండి',
    },
    'bn': {
      'appName': 'সহায়ক AI',
      'tagline': 'আপনার সরকারি প্রকল্প নেভিগেটর',
      'home': 'হোম',
      'explore': 'অন্বেষণ',
      'assistant': 'AI',
      'eligibility': 'যাচাই',
      'profile': 'প্রোফাইল',
      'searchHint': 'বৃত্তি, স্বাস্থ্য, আবাসন খুঁজুন...',
      'recommended': 'প্রস্তাবিত প্রকল্পসমূহ',
      'viewAll': 'সব দেখুন',
      'hello': 'নমস্কার',
      'noSchemes': 'কোনো প্রকল্প পাওয়া যায়নি',
      'logout': 'লগ আউট',
      'language': 'ভাষা',
      'changeLanguage': 'ভাষা পরিবর্তন',
      'selectLanguage': 'ভাষা নির্বাচন করুন',
      'continueBtn': 'চালিয়ে যান',
      'apply': 'এখনই আবেদন করুন',
      'benefits': 'সুবিধাসমূহ',
      'checkEligibility': 'যোগ্যতা যাচাই করুন',
      'myApplications': 'আমার আবেদন',
      'addToTracker': 'আবেদন ট্র্যাক করুন',
      'voiceInput': 'ভয়েস ইনপুট',
      'listening': 'শুনছি...',
      'tapToSpeak': 'কথা বলতে ট্যাপ করুন',
    },
  };
}