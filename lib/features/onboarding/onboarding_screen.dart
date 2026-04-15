import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.search_rounded,
      title: 'Find benefits made for you',
      text: 'Search schemes by need, category, age, income, occupation, and state.',
    ),
    _OnboardingPage(
      icon: Icons.fact_check_rounded,
      title: 'Check eligibility with clarity',
      text: 'Understand likely matches, missing details, and documents before applying.',
    ),
    _OnboardingPage(
      icon: Icons.smart_toy_rounded,
      title: 'Ask Sahayak AI anytime',
      text: 'Get guided recommendations and application steps in simple language.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => context.go('/login'), child: const Text('Skip')),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  children: _pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 28 : 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: i == _index ? AppTheme.primary : AppTheme.primary.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: _index == _pages.length - 1 ? 'Get Started' : 'Continue',
                onPressed: () {
                  if (_index == _pages.length - 1) {
                    context.go('/login');
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 86, color: AppTheme.primary),
        ),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted, height: 1.55)),
      ],
    );
  }
}
