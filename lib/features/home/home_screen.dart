import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final schemes = context.watch<SchemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final notifs = context.watch<NotificationsProvider>();
    final userId = auth.user?.uid ?? 'demo-user';

    return RefreshIndicator(
      onRefresh: schemes.loadSchemes,
      child: CustomScrollView(
        slivers: [
          // ── Hero greeting card ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryDark,
                    AppTheme.primary,
                    AppTheme.teal
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.24),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${lang.t('hello')}, '
                          '${auth.user?.name.split(' ').first ?? 'Citizen'} 👋',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                        ),
                      ),

                      // ── Language badge ────────────────────────────
                      GestureDetector(
                        onTap: () => context.push('/language-select'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(lang.currentLanguage.flag,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                lang.currentLanguage.code.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Notification bell with badge ──────────────
                      const SizedBox(width: 4),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () =>
                                context.push('/notifications'),
                            icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white),
                            tooltip: lang.t('notifications'),
                          ),
                          if (notifs.unreadCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    notifs.unreadCount > 9
                                        ? '9+'
                                        : '${notifs.unreadCount}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // ── AI chatbot button ─────────────────────────
                      IconButton(
                        onPressed: () => context.push('/chatbot'),
                        icon: const Icon(Icons.smart_toy_rounded,
                            color: Colors.white),
                        tooltip: lang.t('aiAssistant'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover benefits, check eligibility, and track schemes in one place.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: schemes.setSearchQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: lang.t('searchHint'),
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Colors.white70),
                      suffixIcon: IconButton(
                        onPressed: () => context.push('/eligibility'),
                        icon: const Icon(Icons.fact_check_outlined,
                            color: Colors.white70),
                        tooltip: lang.t('eligibilityChecker'),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.white70),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category chips ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                children: AppConstants.categories
                    .map((category) => CategoryChip(
                          label: category,
                          selected:
                              schemes.selectedCategory == category,
                          onTap: () =>
                              schemes.setCategory(category),
                        ))
                    .toList(),
              ),
            ),
          ),

          // ── Section header ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 22, 16, 12),
              child: Row(
                children: [
                  Text(
                    lang.t('recommended'),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/home'),
                    child: Text(lang.t('viewAll')),
                  ),
                ],
              ),
            ),
          ),

          // ── Scheme list ────────────────────────────────────────────
          if (schemes.isLoading)
            const SliverFillRemaining(child: LoadingShimmer())
          else if (schemes.filteredSchemes.isEmpty)
            SliverFillRemaining(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: lang.t('noSchemes'),
                message: lang.t('tryDifferent'),
              ),
            )
          else
            SliverList.separated(
              itemCount: schemes.filteredSchemes.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final scheme = schemes.filteredSchemes[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      index ==
                              schemes.filteredSchemes.length - 1
                          ? 24
                          : 0),
                  child: SchemeCard(
                    scheme: scheme,
                    isSaved: schemes.isSaved(scheme.id),
                    onSave: () =>
                        schemes.toggleSave(userId, scheme.id),
                    onTap: () => context.push(
                        '/scheme/${scheme.id}',
                        extra: scheme),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}