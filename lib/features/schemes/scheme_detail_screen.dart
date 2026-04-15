import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/scheme_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../widgets/common_widgets.dart';

class SchemeDetailScreen extends StatelessWidget {
  const SchemeDetailScreen({super.key, required this.schemeId, this.scheme});

  final String schemeId;
  final SchemeModel? scheme;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchemeProvider>();
    final current = scheme ?? provider.byId(schemeId);
    final userId = context.watch<AuthProvider>().user?.uid ?? 'demo-user';
    if (current == null) {
      return const Scaffold(
        body: EmptyState(icon: Icons.error_outline, title: 'Scheme not found', message: 'The selected scheme is unavailable.'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Details'),
        actions: [
          IconButton(
            onPressed: () => provider.toggleSave(userId, current.id),
            icon: Icon(provider.isSaved(current.id) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withOpacity(0.95), AppTheme.teal.withOpacity(0.9)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(current.category, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(current.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text(current.description, style: const TextStyle(color: Colors.white, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _InfoTile(icon: Icons.account_balance_rounded, title: 'Ministry', text: current.ministry),
          _InfoTile(icon: Icons.card_giftcard_rounded, title: 'Benefits', text: current.benefits),
          _InfoTile(icon: Icons.rule_rounded, title: 'Eligibility', text: current.eligibility),
          _InfoTile(icon: Icons.schedule_rounded, title: 'Deadline', text: current.deadline),
          _InfoTile(icon: Icons.laptop_mac_rounded, title: 'Application mode', text: current.applicationMode),
          const SizedBox(height: 12),
          Text('Documents required', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...current.documents.map((doc) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined, color: AppTheme.primary),
                title: Text(doc),
              )),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Check My Eligibility',
            icon: Icons.fact_check_rounded,
            onPressed: () => context.push('/eligibility', extra: current),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/chatbot'),
            icon: const Icon(Icons.smart_toy_outlined),
            label: const Text('Ask AI about this scheme'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
