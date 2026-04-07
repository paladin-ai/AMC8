import 'package:flutter/material.dart';

import 'package:amc8/core/app_language.dart';
import 'package:amc8/screens/dashboard/figma_tokens.dart';
import 'package:amc8/data/db_helper.dart';
import 'package:amc8/screens/practice/amc_options_parser.dart';
import 'package:amc8/screens/practice/custom_test_models.dart';
import 'package:amc8/screens/practice/problem_page_body_text.dart';
import 'package:amc8/screens/practice/problem_page_routes.dart';
import 'package:amc8/screens/practice/year2025_test_figures.dart';

class _LoadedProblem {
  const _LoadedProblem({
    required this.ref,
    required this.question,
    required this.question2,
    required this.optionsRaw,
    required this.parsed,
    this.loadFailed = false,
  });

  final ProblemRef ref;
  final String question;
  final String question2;
  final String optionsRaw;
  final List<ParsedMcOption> parsed;
  final bool loadFailed;
}

/// Practice test: links + same content as problem pages + A–E (aligned with home [FigmaTokens]).
class CustomTestSessionScreen extends StatefulWidget {
  const CustomTestSessionScreen({
    super.key,
    required this.problems,
  });

  final List<ProblemRef> problems;

  @override
  State<CustomTestSessionScreen> createState() => _CustomTestSessionScreenState();
}

class _CustomTestSessionScreenState extends State<CustomTestSessionScreen> {
  final _db = DBHelper.instance;

  bool _loading = true;
  List<_LoadedProblem> _items = [];
  final Map<int, String> _picked = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lang = AppLanguage.code;
    final out = <_LoadedProblem>[];
    for (final ref in widget.problems) {
      final row = await _db.getProblem(
        lang: lang,
        year: ref.year,
        prob: ref.problemNumber,
      );
      if (row == null) {
        out.add(
          _LoadedProblem(
            ref: ref,
            question: '',
            question2: '',
            optionsRaw: '',
            parsed: const [],
            loadFailed: true,
          ),
        );
        continue;
      }
      final q = row['question']?.toString() ?? '';
      final q2 = row['question2']?.toString() ?? '';
      final opts = row['options']?.toString() ?? '';
      out.add(
        _LoadedProblem(
          ref: ref,
          question: q,
          question2: q2,
          optionsRaw: opts,
          parsed: parseAmcStyleOptions(opts),
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      _items = out;
      _loading = false;
    });
  }

  Y2025FigureSlots _figuresFor(_LoadedProblem p) {
    if (p.ref.year != 2025) {
      return (afterQuestion1: <String>[], afterQuestion2: <String>[]);
    }
    final n = p.ref.problemIndex1Based;
    if (n == null) {
      return (afterQuestion1: <String>[], afterQuestion2: <String>[]);
    }
    return y2025FigureUrlsForProblem(n);
  }

  Widget _homeStyleCard({required Widget child}) {
    return Material(
      color: FigmaTokens.cardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
        side: const BorderSide(
          color: FigmaTokens.featureCardBorder,
          width: FigmaTokens.featureBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _linkChipsSection(BuildContext context) {
    return _homeStyleCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problems in this session (open full page)',
              style: TextStyle(
                fontSize: FigmaTokens.featureTitleSize,
                fontWeight: FontWeight.w600,
                color: FigmaTokens.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.problems.map((r) {
                return ActionChip(
                  label: Text(r.displayLabel),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: FigmaTokens.statPurpleHint,
                  ),
                  side: const BorderSide(color: FigmaTokens.featureCardBorder),
                  backgroundColor: FigmaTokens.navSelectedBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FigmaTokens.radiusNavPill),
                  ),
                  onPressed: () => pushProblemDetailPage(context, r),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _letterRow(BuildContext context, int index, _LoadedProblem p) {
    const letters = ['A', 'B', 'C', 'D', 'E'];
    final picked = _picked[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Choose an answer',
          style: TextStyle(
            fontSize: FigmaTokens.statLabelSize,
            fontWeight: FontWeight.w600,
            color: FigmaTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: letters.map((L) {
                final hasOption =
                    p.parsed.isEmpty || p.parsed.any((o) => o.label == L);
                final sel = picked == L;
                return Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: OutlinedButton(
                      onPressed: hasOption
                          ? () => setState(() => _picked[index] = L)
                          : null,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 2,
                        ),
                        foregroundColor: FigmaTokens.textPrimary,
                        backgroundColor: sel ? FigmaTokens.navSelectedBg : null,
                        side: BorderSide(
                          color: sel
                              ? FigmaTokens.statPurpleBorder
                              : FigmaTokens.featureCardBorder,
                          width: sel ? 2 : 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FigmaTokens.radiusStatCard,
                          ),
                        ),
                      ),
                      child: Text(
                        L,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: constraints.maxWidth < 340 ? 14 : 17,
                          color: sel
                              ? FigmaTokens.statPurpleHint
                              : FigmaTokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor:
          isLight ? FigmaTokens.pageBackground : scheme.surface,
      appBar: AppBar(
        title: Text(
          'Your test (${widget.problems.length} ${widget.problems.length == 1 ? 'problem' : 'problems'})',
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'No problems loaded',
                    style: TextStyle(color: FigmaTokens.textSecondary),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    FigmaTokens.screenPaddingH,
                    16,
                    FigmaTokens.screenPaddingH,
                    28,
                  ),
                  children: [
                    _linkChipsSection(context),
                    const SizedBox(height: FigmaTokens.cardGap),
                    ..._items.asMap().entries.map((e) {
                      final index = e.key;
                      final p = e.value;
                      final fig = _figuresFor(p);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: FigmaTokens.cardGap),
                        child: _homeStyleCard(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '${index + 1}. ${p.ref.displayLabel}',
                                  style: TextStyle(
                                    fontSize: FigmaTokens.featureTitleSize,
                                    fontWeight: FontWeight.w700,
                                    color: FigmaTokens.statPurpleHint,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        pushProblemDetailPage(context, p.ref),
                                    icon: Icon(
                                      Icons.open_in_new_rounded,
                                      size: 20,
                                      color: FigmaTokens.statPurpleHint,
                                    ),
                                    label: Text(
                                      'Open full problem page',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: FigmaTokens.statPurpleHint,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                if (p.loadFailed)
                                  Text(
                                    "Couldn't load this problem from the bank.",
                                    style: TextStyle(color: scheme.error),
                                  )
                                else ...[
                                  if (p.question.isNotEmpty)
                                    problemStemText(p.ref, p.question),
                                  ...fig.afterQuestion1.map(
                                    (url) => _TestFigureImage(url: url),
                                  ),
                                  if (p.question2.trim().isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    problemSecondStemText(p.question2),
                                  ],
                                  ...fig.afterQuestion2.map(
                                    (url) => _TestFigureImage(url: url),
                                  ),
                                  if (p.optionsRaw.trim().isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Answer choices',
                                      style: TextStyle(
                                        fontSize: FigmaTokens.statLabelSize,
                                        fontWeight: FontWeight.w600,
                                        color: FigmaTokens.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    problemOptionsBlock(p.ref, p.optionsRaw),
                                  ],
                                  const SizedBox(height: 20),
                                  _letterRow(context, index, p),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}

class _TestFigureImage extends StatelessWidget {
  const _TestFigureImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(
                color: FigmaTokens.statPurpleHint,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Text(
          "Image couldn't load",
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
