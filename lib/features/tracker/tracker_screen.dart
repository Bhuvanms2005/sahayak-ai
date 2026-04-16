import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/tracked_application.dart';
import '../../providers/language_provider.dart';
import '../../providers/tracker_provider.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('myApplications')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text('${tracker.totalCount} tracked',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 12)),
              backgroundColor: AppTheme.primary.withOpacity(0.1),
            ),
          )
        ],
      ),
      body: tracker.applications.isEmpty
          ? _EmptyTracker(lang: lang)
          : Column(
              children: [
                _StatsBar(tracker: tracker),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: tracker.applications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final app = tracker.applications[index];
                      return _ApplicationCard(app: app, lang: lang);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.tracker});
  final TrackerProvider tracker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: AppTheme.primary.withOpacity(0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
              emoji: '⏳',
              count: tracker.inProgressCount,
              label: 'In Progress',
              color: Colors.orange),
          _StatItem(
              emoji: '📤',
              count: tracker.submittedCount,
              label: 'Submitted',
              color: AppTheme.primary),
          _StatItem(
              emoji: '✅',
              count: tracker.approvedCount,
              label: 'Approved',
              color: AppTheme.teal),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.emoji,
    required this.count,
    required this.label,
    required this.color,
  });
  final String emoji;
  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text('$count',
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 20, color: color)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
      ],
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app, required this.lang});
  final TrackedApplication app;
  final LanguageProvider lang;

  Color _statusColor(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.approved:
        return AppTheme.teal;
      case ApplicationStatus.rejected:
        return AppTheme.error;
      case ApplicationStatus.submitted:
        return AppTheme.primary;
      case ApplicationStatus.inProgress:
        return Colors.orange;
      case ApplicationStatus.notStarted:
        return AppTheme.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.read<TrackerProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(app.schemeName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 15)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(app.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${app.status.emoji} ${app.status.label}',
                  style: TextStyle(
                      color: _statusColor(app.status),
                      fontWeight: FontWeight.w800,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(app.category,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            'Added ${_formatDate(app.addedAt)} · Updated ${_formatDate(app.updatedAt)}',
            style: const TextStyle(color: AppTheme.muted, fontSize: 11),
          ),
          if (app.notes != null && app.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(app.notes!,
                  style: const TextStyle(fontSize: 13, color: AppTheme.ink)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showStatusPicker(context, tracker, app),
                  icon: const Icon(Icons.update_rounded, size: 16),
                  label: Text(lang.t('markAs'),
                      style: const TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _showNotesDialog(context, tracker, app),
                icon: const Icon(Icons.note_alt_outlined, size: 16),
                label: const Text('Notes',
                    style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Remove?'),
                      content: const Text(
                          'Remove this application from tracker?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Remove')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    tracker.removeApplication(app.schemeId);
                  }
                },
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppTheme.error),
                tooltip: 'Remove',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusPicker(
      BuildContext context, TrackerProvider tracker, TrackedApplication app) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Status',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 14),
              ...ApplicationStatus.values.map((status) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(status.emoji,
                      style: const TextStyle(fontSize: 22)),
                  title: Text(status.label,
                      style: TextStyle(
                          fontWeight: app.status == status
                              ? FontWeight.w900
                              : FontWeight.normal)),
                  trailing: app.status == status
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppTheme.primary)
                      : null,
                  onTap: () {
                    tracker.updateStatus(app.schemeId, status);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showNotesDialog(
      BuildContext context, TrackerProvider tracker, TrackedApplication app) {
    final notesCtrl = TextEditingController(text: app.notes ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Application Notes'),
        content: TextField(
          controller: notesCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Add notes about documents collected, visit dates, etc.',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                tracker.updateNotes(app.schemeId, notesCtrl.text);
                Navigator.pop(context);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _EmptyTracker extends StatelessWidget {
  const _EmptyTracker({required this.lang});
  final LanguageProvider lang;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.track_changes_rounded,
                  size: 56, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(lang.t('noApplications'),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              lang.t('noApplicationsMsg'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Browse Schemes'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}