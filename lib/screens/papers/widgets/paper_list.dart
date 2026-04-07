import 'package:flutter/material.dart';

import 'package:amc8/screens/papers/models/paper_item.dart';
import 'package:amc8/screens/papers/papers_tokens.dart';
import 'package:amc8/screens/papers/widgets/paper_card.dart';

/// Past papers as a **3-column** grid (see [PapersTokens.gridCrossAxisCount]).
class PaperList extends StatelessWidget {
  const PaperList({
    super.key,
    required this.papers,
    required this.onPracticeMode,
    required this.onTimedMode,
  });

  final List<PaperItem> papers;
  final void Function(PaperItem paper) onPracticeMode;
  final void Function(PaperItem paper) onTimedMode;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        const count = PapersTokens.gridCrossAxisCount;
        final spacing = PapersTokens.cardSpacing;
        final maxCross = constraints.crossAxisExtent;
        final tileW = (maxCross - spacing * (count - 1)) / count;
        final dense = tileW < 132;
        final mainExtent = dense ? 352.0 : 398.0;

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            mainAxisExtent: mainExtent,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final paper = papers[index];
              return PaperCard(
                paper: paper,
                dense: dense,
                onPracticeMode: () => onPracticeMode(paper),
                onTimedMode: () => onTimedMode(paper),
              );
            },
            childCount: papers.length,
          ),
        );
      },
    );
  }
}
