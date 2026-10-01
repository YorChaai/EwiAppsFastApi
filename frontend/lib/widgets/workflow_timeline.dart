import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/theme/app_theme.dart';

class WorkflowTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final String? currentStage;
  final String? expectedCompletionAt;
  final bool loading;

  const WorkflowTimeline({
    super.key,
    required this.history,
    this.currentStage,
    this.expectedCompletionAt,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final mutedColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final borderColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final activeStage = _cleanText(currentStage);
    final deadline = _formatDateTime(expectedCompletionAt);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.timeline_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timeline Approval',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeStage == null
                          ? 'Riwayat proses dokumen'
                          : 'Stage aktif: ${_stageLabel(activeStage)}',
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          if (deadline != null) ...[
            const SizedBox(height: 12),
            _InfoPill(
              icon: Icons.schedule_rounded,
              text: 'Target selesai: $deadline',
              color: AppTheme.warning,
            ),
          ],
          const SizedBox(height: 16),
          if (history.isEmpty)
            _EmptyTimeline(mutedColor: mutedColor)
          else
            ...List.generate(history.length, (index) {
              final item = history[index];
              return _TimelineItem(
                log: item,
                isFirst: index == 0,
                isLast: index == history.length - 1,
              );
            }),
        ],
      ),
    );
  }

  static String? _cleanText(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String _stageLabel(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.length == 1
            ? part.toUpperCase()
            : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String? _formatDateTime(dynamic value) {
    final raw = _cleanText(value);
    if (raw == null) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy, HH:mm').format(parsed.toLocal());
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, dynamic> log;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.log,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final mutedColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final action = _actionLabel(log['action']);
    final color = _actionColor(log['action'], log['to_status']);
    final comment = _cleanText(log['comment']);
    final userName = _cleanText(log['user_name']) ?? 'System';
    final createdAt = _formatDateTime(log['created_at']) ?? '-';
    final fromStatus = _statusLabel(log['from_status']);
    final toStatus = _statusLabel(log['to_status']);
    final duration = _formatDuration(log['duration_seconds']);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : color.withValues(alpha: 0.28),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child:
                      Icon(_actionIcon(log['action']), size: 12, color: color),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : color.withValues(alpha: 0.28),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          action,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        createdAt,
                        style: TextStyle(color: mutedColor, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _InfoPill(
                        icon: Icons.person_outline_rounded,
                        text: userName,
                        color: AppTheme.primary,
                      ),
                      if (toStatus != null)
                        _InfoPill(
                          icon: Icons.flag_outlined,
                          text: fromStatus == null
                              ? toStatus
                              : '$fromStatus -> $toStatus',
                          color: color,
                        ),
                      if (duration != null)
                        _InfoPill(
                          icon: Icons.timer_outlined,
                          text: duration,
                          color: AppTheme.warning,
                        ),
                    ],
                  ),
                  if (comment != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      comment,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String? _cleanText(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _statusLabel(dynamic value) {
    final raw = _cleanText(value);
    if (raw == null) return null;
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part.length == 1
            ? part.toUpperCase()
            : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static String _actionLabel(dynamic value) {
    switch (_cleanText(value)?.toLowerCase()) {
      case 'submit':
        return 'Dokumen Disubmit';
      case 'approve_t1':
        return 'Approved Table 1';
      case 'approve_t2':
        return 'Approved Table 2';
      case 'approve_t3':
        return 'Approved Table 3';
      case 'final_approve':
        return 'Final Approved';
      case 'reject':
        return 'Rejected';
      case 'revise':
        return 'Revision Started';
      default:
        return _statusLabel(value) ?? 'Workflow Update';
    }
  }

  static IconData _actionIcon(dynamic value) {
    switch (_cleanText(value)?.toLowerCase()) {
      case 'submit':
        return Icons.send_rounded;
      case 'reject':
        return Icons.close_rounded;
      case 'final_approve':
        return Icons.verified_rounded;
      default:
        return Icons.check_rounded;
    }
  }

  static Color _actionColor(dynamic action, dynamic status) {
    final actionText = _cleanText(action)?.toLowerCase();
    final statusText = _cleanText(status)?.toLowerCase();
    if (actionText == 'reject' || statusText == 'rejected') {
      return AppTheme.danger;
    }
    if (actionText == 'submit' || statusText == 'submitted') {
      return AppTheme.warning;
    }
    if (actionText == 'final_approve' ||
        statusText == 'approved' ||
        statusText == 'completed') {
      return AppTheme.success;
    }
    return AppTheme.primary;
  }

  static String? _formatDateTime(dynamic value) {
    final raw = _cleanText(value);
    if (raw == null) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy, HH:mm').format(parsed.toLocal());
  }

  static String? _formatDuration(dynamic value) {
    final seconds = int.tryParse((value ?? '').toString());
    if (seconds == null || seconds <= 0) return null;
    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) return '${days}h ${hours}j';
    if (hours > 0) return '${hours}j ${minutes}m';
    if (minutes > 0) return '${minutes}m';
    return '${duration.inSeconds}d';
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  final Color mutedColor;

  const _EmptyTimeline({required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: mutedColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Belum ada histori workflow untuk dokumen ini.',
        style: TextStyle(color: mutedColor, fontSize: 12),
      ),
    );
  }
}
