import 'package:flutter/material.dart';

import '../figma_tokens.dart';

/// Two summary cards: Tests Taken (purple border) and Average Score (green border).
class HomeStatCardsSection extends StatelessWidget {
  const HomeStatCardsSection({
    super.key,
    this.onTakeTestTap,
  });

  /// 點擊「Test your test!」進入自測設置頁。
  final VoidCallback? onTakeTestTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 560;
        final statCards = [
          _StatCard(
            label: 'Tests Taken',
            value: '0',
            hint: onTakeTestTap != null ? 'Test your test!' : 'Take your first test!',
            borderColor: FigmaTokens.statPurpleBorder,
            hintColor: FigmaTokens.statPurpleHint,
            onHintTap: onTakeTestTap,
          ),
          _StatCard(
            label: 'Average Score',
            value: '0%',
            hint: 'Keep improving!',
            borderColor: FigmaTokens.statGreenBorder,
            hintColor: FigmaTokens.statGreenHint,
          ),
        ];

        if (narrow) {
          return Column(
            children: [
              statCards[0],
              SizedBox(height: FigmaTokens.cardGap),
              statCards[1],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: statCards[0]),
            SizedBox(width: FigmaTokens.cardGap),
            Expanded(child: statCards[1]),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.hint,
    required this.borderColor,
    required this.hintColor,
    this.onHintTap,
  });

  final String label;
  final String value;
  final String hint;
  final Color borderColor;
  final Color hintColor;
  final VoidCallback? onHintTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: FigmaTokens.cardSurface,
        borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
        border: Border.all(
          color: borderColor,
          width: FigmaTokens.statBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FigmaTokens.statLabelSize,
              fontWeight: FontWeight.w500,
              color: FigmaTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: FigmaTokens.statValueSize,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: FigmaTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          onHintTap != null
              ? GestureDetector(
                  onTap: onHintTap,
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: FigmaTokens.statHintSize,
                      fontWeight: FontWeight.w600,
                      color: hintColor,
                      height: 1.3,
                      decoration: TextDecoration.underline,
                      decorationColor: hintColor,
                    ),
                  ),
                )
              : Text(
                  hint,
                  style: TextStyle(
                    fontSize: FigmaTokens.statHintSize,
                    fontWeight: FontWeight.w500,
                    color: hintColor,
                    height: 1.3,
                  ),
                ),
        ],
      ),
    );
  }
}
