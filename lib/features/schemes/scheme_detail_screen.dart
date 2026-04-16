import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../models/scheme_model.dart';
import '../../models/tracked_application.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../providers/tracker_provider.dart';

class SchemeDetailScreen extends StatelessWidget {
  const SchemeDetailScreen({
    super.key,
    required this.schemeId,
    this.scheme,
  });

  final String schemeId;
  final SchemeModel? scheme;

  @override
  Widget build(BuildContext context) {
    final schemes = context.watch<SchemeProvider>();
    final auth = context.watch<AuthProvider>();
    final tracker = context.watch<TrackerProvider>();
    final lang = context.watch<LanguageProvider>();

    final s = scheme ?? schemes.byId(schemeId);
    if (s == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Scheme not found.')),
      );
    }

    final userId = auth.user?.uid ?? 'demo-user';
    final isSaved = schemes.isSaved(s.id);
    final isTracked = tracker.isTracked(s.id);
    final trackedApp = tracker.getById(s.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero header ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                s.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      _CategoryBadge(category: s.category),
                      const SizedBox(height: 12),
                      Text('${s.popularity}% match',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => schemes.toggleSave(userId, s.id),
                icon: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? AppTheme.saffron : Colors.white,
                ),
              ),
            ],
          ),

          // ── Body ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tracker status card
                  if (isTracked && trackedApp != null) ...[
                    _TrackerStatusCard(app: trackedApp, lang: lang),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  _SectionCard(
                    title: 'About this Scheme',
                    icon: Icons.info_outline_rounded,
                    child: Text(s.description,
                        style: const TextStyle(height: 1.6, fontSize: 14)),
                  ),
                  const SizedBox(height: 14),

                  // Benefits
                  _SectionCard(
                    title: lang.t('benefits'),
                    icon: Icons.card_giftcard_rounded,
                    iconColor: AppTheme.teal,
                    child: Text(s.benefits,
                        style: const TextStyle(height: 1.6, fontSize: 14)),
                  ),
                  const SizedBox(height: 14),

                  // Eligibility
                  _SectionCard(
                    title: 'Eligibility Criteria',
                    icon: Icons.verified_user_outlined,
                    iconColor: AppTheme.primary,
                    child: Text(s.eligibility,
                        style: const TextStyle(height: 1.6, fontSize: 14)),
                  ),
                  const SizedBox(height: 14),

                  // Documents
                  _SectionCard(
                    title: lang.t('requiredDocs'),
                    icon: Icons.folder_open_rounded,
                    iconColor: AppTheme.saffron,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: s.documents
                          .map((doc) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        size: 16, color: AppTheme.teal),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(doc,
                                        style: const TextStyle(fontSize: 14))),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Meta info
                  _SectionCard(
                    title: 'More Information',
                    icon: Icons.more_horiz_rounded,
                    child: Column(
                      children: [
                        _InfoRow(label: lang.t('ministry'), value: s.ministry),
                        _InfoRow(label: lang.t('deadline'), value: s.deadline),
                        _InfoRow(
                            label: lang.t('targetGroup'),
                            value: s.targetGroups.join(', ')),
                        _InfoRow(
                            label: 'Application Mode',
                            value: s.applicationMode),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/eligibility', extra: s),
                          icon: const Icon(Icons.fact_check_rounded),
                          label: Text(lang.t('checkEligibility'),
                              style: const TextStyle(fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            try {
                              await launchUrl(
                                  Uri.parse('https://www.india.gov.in'),
                                  mode:
                                      LaunchMode.externalApplication);
                            } catch (_) {}
                          },
                          icon: const Icon(Icons.open_in_new_rounded,
                              size: 16),
                          label: Text(lang.t('apply'),
                              style: const TextStyle(fontSize: 13)),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Track button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (isTracked) {
                          context.push('/tracker');
                        } else {
                          await tracker.addApplication(
                            schemeId: s.id,
                            schemeName: s.name,
                            category: s.category,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text(
                                  '✅ Added to your application tracker!'),
                              action: SnackBarAction(
                                  label: 'View',
                                  onPressed: () =>
                                      context.push('/tracker')),
                            ));
                          }
                        }
                      },
                      icon: Icon(
                        isTracked
                            ? Icons.track_changes_rounded
                            : Icons.add_task_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isTracked
                            ? 'View in Tracker  (${trackedApp?.status.emoji} ${trackedApp?.status.label})'
                            : lang.t('addToTracker'),
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isTracked
                            ? AppTheme.teal
                            : AppTheme.primary,
                        side: BorderSide(
                            color: isTracked
                                ? AppTheme.teal
                                : AppTheme.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerStatusCard extends StatelessWidget {
  const _TrackerStatusCard({required this.app, required this.lang});
  final dynamic app;
  final LanguageProvider lang;

  Color _color() {
    switch (app.status) {
      case ApplicationStatus.approved:
        return AppTheme.teal;
      case ApplicationStatus.rejected:
        return AppTheme.error;
      case ApplicationStatus.submitted:
        return AppTheme.primary;
      case ApplicationStatus.inProgress:
        return Colors.orange;
      default:
        return AppTheme.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color().withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(app.status.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Application Status',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 13)),
                Text(app.status.label,
                    style: TextStyle(
                        color: _color(), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/tracker'),
            child: const Text('View tracker'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.iconColor,
  });
  final String title;
  final IconData icon;
  final Widget child;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 14)),
            ],
          ),
          const Divider(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        category,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13),
      ),
    );
  }
}