import 'package:flutter/material.dart';

import '../figma_tokens.dart';

/// Horizontal top navigation: Home, Past Papers, Wrong Answers, Review, Profile.
class HomeTopNavBar extends StatelessWidget {
  const HomeTopNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const List<String> labels = [
    'Home',
    'Past Papers',
    'Wrong Answers',
    'Review',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;
        final children = List<Widget>.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(
              right: i == labels.length - 1 ? 0 : FigmaTokens.navGap,
            ),
            child: _NavItem(
              label: labels[i],
              selected: selected,
              onTap: () => onSelect(i),
            ),
          );
        });

        if (isCompact) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: children),
          );
        }
        return Wrap(
          spacing: FigmaTokens.navGap,
          runSpacing: FigmaTokens.navGap,
          children: children,
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FigmaTokens.radiusNavPill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? FigmaTokens.navSelectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(FigmaTokens.radiusNavPill),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: FigmaTokens.navLabelSize,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? FigmaTokens.navSelectedFg
                  : FigmaTokens.navUnselectedFg,
            ),
          ),
        ),
      ),
    );
  }
}
