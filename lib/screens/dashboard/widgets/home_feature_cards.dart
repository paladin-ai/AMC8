import 'package:flutter/material.dart';

import '../figma_tokens.dart';

/// Four action tiles: Past Papers, Wrong Answers, Review Questions, Profile.
class HomeFeatureCardsSection extends StatelessWidget {
  const HomeFeatureCardsSection({
    super.key,
    required this.onPastPapers,
    required this.onWrongAnswers,
    required this.onReview,
    required this.onProfile,
  });

  final VoidCallback onPastPapers;
  final VoidCallback onWrongAnswers;
  final VoidCallback onReview;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatureData(
        title: 'Past Papers',
        subtitle: 'Practice with official AMC8',
        icon: Icons.menu_book_rounded,
        iconBg: FigmaTokens.featurePastPapersIconBg,
        iconFg: FigmaTokens.featurePastPapersIconFg,
        onTap: onPastPapers,
      ),
      _FeatureData(
        title: 'Wrong Answers',
        subtitle: 'Review your mistakes',
        icon: Icons.close_rounded,
        iconBg: FigmaTokens.featureWrongIconBg,
        iconFg: FigmaTokens.featureWrongIconFg,
        onTap: onWrongAnswers,
      ),
      _FeatureData(
        title: 'Review Questions',
        subtitle: 'Marked for review',
        icon: Icons.flag_rounded,
        iconBg: FigmaTokens.featureReviewIconBg,
        iconFg: FigmaTokens.featureReviewIconFg,
        onTap: onReview,
      ),
      _FeatureData(
        title: 'Profile',
        subtitle: 'Manage your account',
        icon: Icons.person_rounded,
        iconBg: FigmaTokens.featureProfileIconBg,
        iconFg: FigmaTokens.featureProfileIconFg,
        onTap: onProfile,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        int crossAxisCount;
        if (w >= 900) {
          crossAxisCount = 4;
        } else if (w >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 2;
        }

        final spacing = FigmaTokens.cardGap;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            /// Tuned so two rows fit phones; grows on tablet.
            childAspectRatio: w >= 900 ? 1.15 : (w >= 600 ? 1.05 : 0.92),
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => _FeatureCard(data: items[i]),
        );
      },
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final VoidCallback onTap;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data});

  final _FeatureData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FigmaTokens.cardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FigmaTokens.radiusFeatureCard),
        side: const BorderSide(
          color: FigmaTokens.featureCardBorder,
          width: FigmaTokens.featureBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: data.onTap,
          child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: FigmaTokens.radiusIconCircle * 2,
                height: FigmaTokens.radiusIconCircle * 2,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  color: data.iconFg,
                  size: 26,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FigmaTokens.featureTitleSize,
                  fontWeight: FontWeight.w600,
                  color: FigmaTokens.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FigmaTokens.featureSubtitleSize,
                  fontWeight: FontWeight.w400,
                  color: FigmaTokens.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
