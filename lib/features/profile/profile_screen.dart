import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final saved = context.watch<SchemeProvider>().savedSchemes;
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                CircleAvatar(radius: 34, backgroundColor: AppTheme.primary.withOpacity(0.12), child: Text((user?.name ?? 'C')[0].toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.primary))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'Citizen', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      Text(user?.email ?? 'demo@sahayak.ai', style: const TextStyle(color: AppTheme.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Complete Profile', icon: Icons.edit_rounded, onPressed: () => context.push('/complete-profile')),
          const SizedBox(height: 20),
          Text('Saved schemes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          if (saved.isEmpty)
            const EmptyState(icon: Icons.bookmark_border, title: 'No saved schemes', message: 'Save schemes from Home or Explore to track them here.')
          else
            ...saved.map((scheme) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bookmark, color: AppTheme.saffron),
                  title: Text(scheme.name),
                  subtitle: Text(scheme.category),
                  onTap: () => context.push('/scheme/${scheme.id}', extra: scheme),
                )),
          const SizedBox(height: 20),
          OutlinedButton.icon(onPressed: auth.signOut, icon: const Icon(Icons.logout_rounded), label: const Text('Logout')),
        ],
      ),
    );
  }
}
