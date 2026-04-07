import 'package:flutter/material.dart';

import 'package:amc8/screens/papers/models/paper_item.dart';

/// Placeholder detail until each year has its own question set in-app.
class PaperDetailPlaceholderPage extends StatelessWidget {
  const PaperDetailPlaceholderPage({super.key, required this.paper});

  final PaperItem paper;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(paper.displayTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined, size: 56, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                paper.displayTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${paper.questionCount} questions · coming soon',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
