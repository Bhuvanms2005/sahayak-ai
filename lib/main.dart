import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/ai_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chatbot_provider.dart';
import 'providers/eligibility_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/scheme_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/tracker_provider.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: .env file not found. $e');
  }

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const SahayakAI());
}

class SahayakAI extends StatelessWidget {
  const SahayakAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()..loadSchemes()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        ChangeNotifierProvider(create: (_) => EligibilityProvider()),
        ChangeNotifierProvider(create: (_) => AiProvider()),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
        ChangeNotifierProvider(
            create: (_) => NotificationsProvider()), // ← NEW
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<ThemeProvider>();

          // Keep ChatbotProvider and AiProvider language in sync
          final lang = context.watch<LanguageProvider>();
          context.read<ChatbotProvider>().updateLanguage(lang.currentCode);
          context.read<AiProvider>().updateLanguage(lang.currentCode);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Sahayak AI',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.createRouter(context),
          );
        },
      ),
    );
  }
}