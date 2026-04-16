import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isOnboarding;
  const LanguageSelectionScreen({super.key, this.isOnboarding = true});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'en';

  @override
  void initState() {
    super.initState();
    final lang = context.read<LanguageProvider>();
    _selected = lang.currentCode;
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
              const SizedBox(height: 36),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.language_rounded,
                          color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t('selectLanguage'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.t('languageSubtitle'),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Language grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: LanguageProvider.supportedLanguages.length,
                        itemBuilder: (context, index) {
                          final language =
                              LanguageProvider.supportedLanguages[index];
                          final isSelected = _selected == language.code;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selected = language.code),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : Colors.grey.shade200,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? AppTheme.primary.withOpacity(0.25)
                                        : Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(language.flag,
                                          style: const TextStyle(fontSize: 22)),
                                      const Spacer(),
                                      if (isSelected)
                                        const Icon(Icons.check_circle_rounded,
                                            color: Colors.white, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    language.nativeName,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.ink,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    language.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white70
                                          : AppTheme.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await lang.setLanguage(_selected);
                            if (context.mounted) {
                              if (widget.isOnboarding) {
                                context.go('/login');
                              } else {
                                context.pop();
                              }
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            lang.t('continueBtn'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}