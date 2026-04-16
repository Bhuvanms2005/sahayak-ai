import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../chatbot/chatbot_screen.dart';
import '../eligibility/eligibility_screen.dart';
import '../profile/profile_screen.dart';
import '../schemes/explore_schemes_screen.dart';
import '../tracker/tracker_screen.dart';
import 'home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ExploreSchemesScreen(),
    ChatbotScreen(),
    TrackerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: SafeArea(child: _screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: lang.t('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: lang.t('explore'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_toy_outlined),
            selectedIcon: const Icon(Icons.smart_toy_rounded),
            label: lang.t('assistant'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.track_changes_outlined),
            selectedIcon: const Icon(Icons.track_changes_rounded),
            label: lang.t('tracker'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person_rounded),
            label: lang.t('profile'),
          ),
        ],
      ),
    );
  }
}