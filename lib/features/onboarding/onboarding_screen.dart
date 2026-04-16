import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPage(
      icon: Icons.travel_explore_rounded,
      title: 'Discover Schemes',
      body:
          'Access hundreds of government welfare schemes for education, health, housing, agriculture and more — all in one place.',
    ),
    _OnboardPage(
      icon: Icons.smart_toy_rounded,
      title: 'AI-Powered Assistant',
      body:
          'Ask Sahayak AI anything about eligibility, documents, or how to apply. Get instant, personalized answers in your language.',
    ),
    _OnboardPage(
      icon: Icons.track_changes_rounded,
      title: 'Track Your Applications',
      body:
          'Never lose track of an application. Monitor status, set reminders, and get notified about deadlines.',
    ),
    _OnboardPage(
      icon: Icons.language_rounded,
      title: 'Your Language, Your Way',
      body:
          'Sahayak AI supports 10 Indian languages. Switch anytime and interact in the language you\'re most comfortable with.',
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      // Go to language selection before login
      context.go('/language-select?onboarding=true');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () =>
                      context.go('/language-select?onboarding=true'),
                  child: const Text('Skip',
                      style: TextStyle(color: Colors.white70)),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _pages[i],
                ),
              ),

              // Dots + button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    // Page dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _page ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _page == _pages.length - 1
                              ? lang.t('continueBtn')
                              : 'Next',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.2),
          ),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white70, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}