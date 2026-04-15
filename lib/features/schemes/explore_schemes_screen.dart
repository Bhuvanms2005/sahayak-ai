import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class ExploreSchemesScreen extends StatelessWidget {
  const ExploreSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schemes = context.watch<SchemeProvider>();
    final userId = context.watch<AuthProvider>().user?.uid ?? 'demo-user';
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Schemes')),
      body: schemes.filteredSchemes.isEmpty
          ? const EmptyState(icon: Icons.explore_off_rounded, title: 'Nothing here yet', message: 'Search from Home or clear filters.')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: schemes.filteredSchemes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final scheme = schemes.filteredSchemes[index];
                return SchemeCard(
                  scheme: scheme,
                  isSaved: schemes.isSaved(scheme.id),
                  onSave: () => schemes.toggleSave(userId, scheme.id),
                  onTap: () => context.push('/scheme/${scheme.id}', extra: scheme),
                );
              },
            ),
    );
  }
}
