import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/chatbot/chatbot_screen.dart';
import '../features/eligibility/eligibility_screen.dart';
import '../features/home/main_navigation.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/complete_profile_screen.dart';
import '../features/schemes/scheme_detail_screen.dart';
import '../features/splash/splash_screen.dart';
import '../models/scheme_model.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const schemeDetail = '/scheme/:id';
  static const chatbot = '/chatbot';
  static const eligibility = '/eligibility';
  static const completeProfile = '/complete-profile';

  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      refreshListenable: Provider.of<AuthProvider>(context, listen: false),
      redirect: (context, state) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final location = state.matchedLocation;
        final publicRoutes = {splash, onboarding, login, signup, forgotPassword};
        if (auth.status == AuthStatus.initial) return null;
        if (!auth.isAuthenticated && !publicRoutes.contains(location)) return login;
        if (auth.isAuthenticated && {login, signup, onboarding}.contains(location)) return home;
        return null;
      },
      routes: [
        GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
        GoRoute(path: onboarding, builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: login, builder: (_, __) => const LoginScreen()),
        GoRoute(path: signup, builder: (_, __) => const SignupScreen()),
        GoRoute(path: forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(path: home, builder: (_, __) => const MainNavigation()),
        GoRoute(
          path: schemeDetail,
          builder: (_, state) => SchemeDetailScreen(
            schemeId: state.pathParameters['id']!,
            scheme: state.extra as SchemeModel?,
          ),
        ),
        GoRoute(path: chatbot, builder: (_, __) => const ChatbotScreen()),
        GoRoute(
          path: eligibility,
          builder: (_, state) => EligibilityScreen(scheme: state.extra as SchemeModel?),
        ),
        GoRoute(path: completeProfile, builder: (_, __) => const CompleteProfileScreen()),
      ],
    );
  }
}
