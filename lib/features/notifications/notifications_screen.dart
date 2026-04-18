import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _filter; // null = All

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final lang = context.watch<LanguageProvider>();

    // Apply filter
    final all = provider.notifications;
    final filtered = _filter == null
        ? all
        : all.where((n) => n.type == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('notifications')),
        actions: [
          if (provider.unreadCount > 0)
            TextButton.icon(
              onPressed: provider.markAllAsRead,
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark all read',
                  style: TextStyle(fontSize: 13)),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'clear') {
                _showClearDialog(context, provider);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded,
                        size: 18, color: AppTheme.error),
                    SizedBox(width: 10),
                    Text('Clear all'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Unread badge ─────────────────────────────────────────
          if (provider.unreadCount > 0)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppTheme.primary.withOpacity(0.07),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.unreadCount} new',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('unread notifications',
                      style: TextStyle(
                          color: AppTheme.muted,
                          fontSize: 13)),
                ],
              ),
            ),

          // ── Filter chips ──────────────────────────────────────────
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == null,
                  color: AppTheme.primary,
                  onTap: () => setState(() => _filter = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '📋 Schemes',
                  selected: _filter == NotificationType.scheme,
                  color: AppTheme.primary,
                  onTap: () => setState(() => _filter == NotificationType.scheme
                      ? _filter = null
                      : _filter = NotificationType.scheme),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '⏰ Deadlines',
                  selected: _filter == NotificationType.deadline,
                  color: AppTheme.error,
                  onTap: () => setState(() =>
                      _filter == NotificationType.deadline
                          ? _filter = null
                          : _filter = NotificationType.deadline),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '📊 Tracker',
                  selected: _filter == NotificationType.tracker,
                  color: AppTheme.teal,
                  onTap: () => setState(() =>
                      _filter == NotificationType.tracker
                          ? _filter = null
                          : _filter = NotificationType.tracker),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '🔔 General',
                  selected: _filter == NotificationType.general,
                  color: AppTheme.saffron,
                  onTap: () => setState(() =>
                      _filter == NotificationType.general
                          ? _filter = null
                          : _filter = NotificationType.general),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Notification list ─────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? _EmptyNotifications(filter: _filter)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      final notif = filtered[index];
                      return _NotificationTile(
                        notif: notif,
                        onTap: () => provider.markAsRead(notif.id),
                        onDismiss: () =>
                            provider.deleteNotification(notif.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(
      BuildContext context, NotificationsProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text(
            'This will permanently delete all notifications.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}

// ─── Notification Tile ────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });

  final AppNotification notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadBg = notif.isRead
        ? Colors.transparent
        : AppTheme.primary.withOpacity(isDark ? 0.08 : 0.04);

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.error.withOpacity(0.85),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 26),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: unreadBg,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      notif.type.color(context).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(notif.type.icon,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white60
                            : AppTheme.muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(notif.createdAt),
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : color.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.filter});
  final NotificationType? filter;

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
              child: const Icon(Icons.notifications_none_rounded,
                  size: 52, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              filter == null
                  ? 'No notifications yet'
                  : 'No ${filter!.name} notifications',
              style: const TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              filter == null
                  ? 'You\'re all caught up! New scheme alerts and updates will appear here.'
                  : 'Try selecting a different filter to see other notifications.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}