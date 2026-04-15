import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final schemes = context.watch<SchemeProvider>();
    final userId = auth.user?.uid ?? 'demo-user';
    return RefreshIndicator(
      onRefresh: schemes.loadSchemes,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.24), blurRadius: 26, offset: const Offset(0, 14)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hello, ${auth.user?.name.split(' ').first ?? 'Citizen'}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/chatbot'),
                        icon: const Icon(Icons.smart_toy_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Discover benefits, check eligibility, and track schemes in one place.', style: TextStyle(color: Colors.white70, height: 1.5)),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: schemes.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search scholarships, health, housing...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(onPressed: () => context.push('/eligibility'), icon: const Icon(Icons.fact_check_outlined)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: AppConstants.categories
                    .map((category) => CategoryChip(
                          label: category,
                          selected: schemes.selectedCategory == category,
                          onTap: () => schemes.setCategory(category),
                        ))
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
              child: Row(
                children: [
                  Text('Recommended schemes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const Spacer(),
                  TextButton(onPressed: () => context.push('/home?tab=explore'), child: const Text('View all')),
                ],
              ),
            ),
          ),
          if (schemes.isLoading)
            const SliverFillRemaining(child: LoadingShimmer())
          else if (schemes.filteredSchemes.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(icon: Icons.search_off_rounded, title: 'No schemes found', message: 'Try a different keyword or category.'),
            )
          else
            SliverList.separated(
              itemCount: schemes.filteredSchemes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final scheme = schemes.filteredSchemes[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, index == schemes.filteredSchemes.length - 1 ? 24 : 0),
                  child: SchemeCard(
                    scheme: scheme,
                    isSaved: schemes.isSaved(scheme.id),
                    onSave: () => schemes.toggleSave(userId, scheme.id),
                    onTap: () => context.push('/scheme/${scheme.id}', extra: scheme),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
