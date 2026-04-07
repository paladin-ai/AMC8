import 'package:flutter/material.dart';

import 'package:amc8/screens/papers/papers_tokens.dart';

/// Pulsing placeholders in a **3-column** grid (matches [PaperList]).
class PapersSkeleton extends StatefulWidget {
  const PapersSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  State<PapersSkeleton> createState() => _PapersSkeletonState();
}

class _PapersSkeletonState extends State<PapersSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = 0.35 + _controller.value * 0.35;
        final base = Color.lerp(
          scheme.surfaceContainerHighest,
          scheme.surfaceContainerHigh,
          _controller.value,
        )!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: PapersTokens.gridCrossAxisCount,
            mainAxisSpacing: PapersTokens.cardSpacing,
            crossAxisSpacing: PapersTokens.cardSpacing,
            mainAxisExtent: 352.0,
          ),
          itemBuilder: (context, i) {
            return Opacity(
              opacity: t,
              child: Container(
                decoration: BoxDecoration(
                  color: base,
                  borderRadius:
                      BorderRadius.circular(PapersTokens.cardRadius),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: scheme.onSurface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 26,
                          width: 44,
                          decoration: BoxDecoration(
                            color: scheme.onSurface.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 14,
                      width: 72,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
