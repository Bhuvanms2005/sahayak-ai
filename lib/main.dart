import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/chatbot_provider.dart';
import 'providers/eligibility_provider.dart';
import 'providers/scheme_provider.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env').catchError((_) {});
  await Firebase.initializeApp().catchError((_) => null);
  runApp(const SahayakAI());
}

class SahayakAI extends StatelessWidget {
  const SahayakAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()..loadSchemes()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        ChangeNotifierProvider(create: (_) => EligibilityProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Sahayak AI',
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.createRouter(context),
          );
        },
      ),
    );
  }
}
