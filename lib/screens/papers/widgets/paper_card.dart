import 'package:flutter/material.dart';

import 'package:amc8/screens/papers/models/paper_item.dart';
import 'package:amc8/screens/papers/papers_tokens.dart';
import 'package:amc8/theme/app_theme.dart';

/// Exam card: gradient calendar tile, question pill, meta lines, Practice / Timed CTAs.
///
/// [dense] tightens padding and type for **3-column** grids on narrow widths.
class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.paper,
    required this.onPracticeMode,
    required this.onTimedMode,
    this.dense = false,
  });

  final PaperItem paper;
  final VoidCallback onPracticeMode;
  final VoidCallback onTimedMode;
  final bool dense;

  static const Color _lightCardBorder = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metaGrey = scheme.onSurfaceVariant;

    final pad = dense ? 12.0 : PapersTokens.cardPadding;
    final gapL = dense ? 12.0 : 18.0;
    final gapM = dense ? 10.0 : 14.0;
    final gapS = dense ? 4.0 : 6.0;
    final gapMeta = dense ? 6.0 : 8.0;
    final gapBeforeButtons = dense ? 12.0 : 18.0;
    final btnH = dense ? 40.0 : 48.0;
    final btnGap = dense ? 8.0 : 10.0;

    final titleSize = dense ? 15.0 : PapersTokens.cardTitleSize;
    final subSize = dense ? 12.0 : PapersTokens.cardSubtitleSize;
    final btnFont = dense ? 11.5 : PapersTokens.buttonTextSize;
    final metaSize = dense ? 11.0 : PapersTokens.metaLineSize;

    return Material(
      color: scheme.surface,
      elevation: isDark ? 0 : PapersTokens.cardElevationLight,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PapersTokens.cardRadius),
        side: BorderSide(
          color: isDark
              ? scheme.outline.withValues(alpha: 0.35)
              : _lightCardBorder,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CalendarGradientIcon(dense: dense),
                const Spacer(),
                _QuestionPill(count: paper.questionCount, dense: dense),
              ],
            ),
            SizedBox(height: gapL),
            Text(
              paper.displayTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
            ),
            SizedBox(height: gapS),
            Text(
              'Official competition paper',
              maxLines: dense ? 2 : 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: subSize,
                    fontWeight: FontWeight.w400,
                    color: metaGrey,
                    height: 1.25,
                  ),
            ),
            SizedBox(height: gapM),
            _MetaRow(
              icon: Icons.schedule_rounded,
              text: '40 minutes time limit',
              color: metaGrey,
              iconSize: dense ? 15.0 : 18.0,
              fontSize: metaSize,
            ),
            SizedBox(height: gapMeta),
            _MetaRow(
              icon: Icons.emoji_events_outlined,
              text: 'Official MAA competition',
              color: metaGrey,
              iconSize: dense ? 15.0 : 18.0,
              fontSize: metaSize,
            ),
            SizedBox(height: gapBeforeButtons),
            SizedBox(
              width: double.infinity,
              height: btnH,
              child: OutlinedButton(
                onPressed: onPracticeMode,
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.onSurface,
                  side: BorderSide(
                    color: isDark
                        ? scheme.outline.withValues(alpha: 0.55)
                        : _lightCardBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: dense ? 6 : 16),
                ),
                child: Text(
                  'Practice Mode (No Timer)',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: btnFont,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            SizedBox(height: btnGap),
            SizedBox(
              width: double.infinity,
              height: btnH,
              child: FilledButton(
                onPressed: onTimedMode,
                style: FilledButton.styleFrom(
                  backgroundColor: Amc8BrandColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: dense ? 6 : 16),
                ),
                child: Text(
                  'Timed Mode (40 min)',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: btnFont,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarGradientIcon extends StatelessWidget {
  const _CalendarGradientIcon({required this.dense});

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final box = dense ? 32.0 : PapersTokens.calendarIconBox;
    final rad = dense ? 8.0 : PapersTokens.calendarIconRadius;
    final iconSz = dense ? 16.0 : 20.0;

    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rad),
        gradient: const LinearGradient(
          colors: [
            PapersTokens.gradientPurpleStart,
            PapersTokens.gradientPurpleEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.calendar_today_outlined,
        size: iconSz,
        color: Colors.white,
      ),
    );
  }
}

class _QuestionPill extends StatelessWidget {
  const _QuestionPill({required this.count, required this.dense});

  final int count;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surfaceContainerHighest.withValues(alpha: 0.85);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        dense ? '$count Q' : '$count Questions',
        style: TextStyle(
          fontSize: dense ? 10.5 : PapersTokens.badgeFontSize,
          fontWeight: FontWeight.w600,
          color: scheme.onSurfaceVariant,
          height: 1.1,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.iconSize,
    required this.fontSize,
  });

  final IconData icon;
  final String text;
  final Color color;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: iconSize, color: color.withValues(alpha: 0.9)),
        SizedBox(width: fontSize <= 11 ? 6 : 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: color,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
