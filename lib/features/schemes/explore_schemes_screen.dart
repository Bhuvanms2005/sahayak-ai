import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class ExploreSchemesScreen extends StatelessWidget {
  const ExploreSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schemes = context.watch<SchemeProvider>();
    final userId = context.watch<AuthProvider>().user?.uid ?? 'demo-user';
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('explore'))),
      body: Column(
        children: [
          // ── Search + filter bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              onChanged: schemes.setSearchQuery,
              decoration: InputDecoration(
                hintText: lang.t('searchHint'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: schemes.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => schemes.setSearchQuery(''),
                      )
                    : null,
              ),
            ),
          ),

          // ── Category chips ────────────────────────────────────────
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: AppConstants.categories
                  .map((cat) => CategoryChip(
                        label: cat,
                        selected: schemes.selectedCategory == cat,
                        onTap: () => schemes.setCategory(cat),
                      ))
                  .toList(),
            ),
          ),

          // ── Results count ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${schemes.filteredSchemes.length} schemes',
                  style: const TextStyle(
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                const Spacer(),
                if (schemes.selectedCategory != 'All' ||
                    schemes.searchQuery.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      schemes.setCategory('All');
                      schemes.setSearchQuery('');
                    },
                    icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                    label: const Text('Clear filters',
                        style: TextStyle(fontSize: 13)),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Scheme list ───────────────────────────────────────────
          Expanded(
            child: schemes.isLoading
                ? const LoadingShimmer()
                : schemes.filteredSchemes.isEmpty
                    ? EmptyState(
                        icon: Icons.explore_off_rounded,
                        title: lang.t('noSchemes'),
                        message: lang.t('tryDifferent'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: schemes.filteredSchemes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final scheme = schemes.filteredSchemes[index];
                          return SchemeCard(
                            scheme: scheme,
                            isSaved: schemes.isSaved(scheme.id),
                            onSave: () =>
                                schemes.toggleSave(userId, scheme.id),
                            onTap: () => context.push(
                                '/scheme/${scheme.id}',
                                extra: scheme),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}