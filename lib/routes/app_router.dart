import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/home/main_navigation.dart';
import '../features/schemes/scheme_detail_screen.dart';
import '../features/chatbot/chatbot_screen.dart';
import '../features/eligibility/eligibility_screen.dart';
import '../features/profile/complete_profile_screen.dart';
import '../models/scheme_model.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String schemeDetail = '/scheme/:id';
  static const String chatbot = '/chatbot';
  static const String eligibility = '/eligibility';
  static const String completeProfile = '/complete-profile';

  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isAuth = authProvider.isAuthenticated;
        final isOnAuthPage =
            state.matchedLocation == login ||
            state.matchedLocation == signup ||
            state.matchedLocation == onboarding ||
            state.matchedLocation == splash;

        if (authProvider.status == AuthStatus.initial) return null;
        if (!isAuth && !isOnAuthPage) return login;
        if (isAuth && (state.matchedLocation == login || state.matchedLocation == signup)) {
          return home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const MainNavigation(),
        ),
        GoRoute(
          path: '/scheme/:id',
          builder: (context, state) {
            final scheme = state.extra as SchemeModel?;
            final id = state.pathParameters['id']!;
            return SchemeDetailScreen(schemeId: id, scheme: scheme);
          },
        ),
        GoRoute(
          path: chatbot,
          builder: (context, state) => const ChatbotScreen(),
        ),
        GoRoute(
          path: eligibility,
          builder: (context, state) {
            final scheme = state.extra as SchemeModel?;
            return EligibilityScreen(scheme: scheme);
          },
        ),
        GoRoute(
          path: completeProfile,
          builder: (context, state) => const CompleteProfileScreen(),
        ),
      ],
    );
  }
}