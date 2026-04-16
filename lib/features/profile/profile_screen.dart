import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final saved = context.watch<SchemeProvider>().savedSchemes;
    final theme = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final tracker = context.watch<TrackerProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── User card ──────────────────────────────────────────────
          _UserCard(user: user, lang: lang),
          const SizedBox(height: 16),
          PrimaryButton(
            label: lang.t('completeProfile'),
            icon: Icons.edit_rounded,
            onPressed: () => context.push('/complete-profile'),
          ),
          const SizedBox(height: 24),

          // ── Stats row ─────────────────────────────────────────────
          _SectionHeader(title: 'My Activity'),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(
                icon: Icons.bookmark_rounded,
                value: '${saved.length}',
                label: 'Saved',
                color: AppTheme.saffron,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.track_changes_rounded,
                value: '${tracker.totalCount}',
                label: 'Tracked',
                color: AppTheme.primary,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.check_circle_rounded,
                value: '${tracker.approvedCount}',
                label: 'Approved',
                color: AppTheme.teal,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Settings ──────────────────────────────────────────────
          _SectionHeader(title: lang.t('settings')),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: lang.t('language'),
            subtitle:
                '${lang.currentLanguage.flag} ${lang.currentLanguage.nativeName}',
            onTap: () => context.push('/language-select'),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: lang.t('darkMode'),
            trailing: Switch(
              value: theme.isDark,
              onChanged: (_) => theme.toggleTheme(),
              activeColor: AppTheme.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: lang.t('notifications'),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: lang.t('help'),
            onTap: () => context.push('/chatbot'),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),

          // ── Saved schemes ─────────────────────────────────────────
          _SectionHeader(title: lang.t('savedSchemes')),
          const SizedBox(height: 8),
          if (saved.isEmpty)
            EmptyState(
              icon: Icons.bookmark_border,
              title: lang.t('noSaved'),
              message: lang.t('noSavedMsg'),
            )
          else
            ...saved.map((scheme) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bookmark, color: AppTheme.saffron),
                  title: Text(scheme.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(scheme.category),
                  onTap: () =>
                      context.push('/scheme/${scheme.id}', extra: scheme),
                )),
          const SizedBox(height: 28),

          // ── Logout ────────────────────────────────────────────────
          OutlinedButton.icon(
            onPressed: auth.signOut,
            icon: const Icon(Icons.logout_rounded),
            label: Text(lang.t('logout')),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: AppTheme.error),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Sahayak AI v1.1.0 · IntelliFusion',
              style: const TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.lang});
  final dynamic user;
  final LanguageProvider lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              (user?.name ?? 'C')[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Citizen',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'demo@sahayak.ai',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                if (user?.state != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        user!.state!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 22)),
            Text(label,
                style:
                    const TextStyle(color: AppTheme.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle:
          subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}