import 'package:flutter/material.dart';

import 'package:amc8/screens/dashboard/figma_tokens.dart';
import 'package:amc8/screens/dashboard/widgets/home_top_nav_bar.dart';
import 'package:amc8/screens/papers/models/paper_item.dart';
import 'package:amc8/screens/papers/paper_detail_placeholder_page.dart';
import 'package:amc8/screens/papers/papers_repository.dart';
import 'package:amc8/screens/papers/papers_tokens.dart';
import 'package:amc8/screens/papers/widgets/paper_list.dart';
import 'package:amc8/screens/papers/widgets/papers_skeleton.dart';
import 'package:amc8/screens/papers/past_papers_grid_screen.dart';

/// Past Papers catalog: top nav (Past Papers selected), list, refresh & pagination.
///
/// Figma Make route `/papers` is not readable via API; layout follows your spec and
/// [PapersTokens]. Theme uses primary **#7C3AED** and secondary **#10B981** (see `app_theme.dart`).
class PapersScreen extends StatefulWidget {
  const PapersScreen({super.key, this.repository});

  /// Inject mock / real repository (tests).
  final PapersRepository? repository;

  @override
  State<PapersScreen> createState() => _PapersScreenState();
}

class _PapersScreenState extends State<PapersScreen> {
  late final PapersRepository _repo = widget.repository ?? PapersRepository();
  final ScrollController _scrollController = ScrollController();

  final List<PaperItem> _papers = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loadingInitial = true;
  bool _loadingMore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore || !_hasMore || _loadingInitial || _errorMessage != null) {
      return;
    }
    final pos = _scrollController.position;
    if (!pos.hasPixels) return;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loadingInitial = true;
      _errorMessage = null;
      _papers.clear();
      _page = 1;
      _hasMore = true;
    });
    try {
      final result = await _repo.fetchPage(1);
      if (!mounted) return;
      setState(() {
        _papers.addAll(result.items);
        _hasMore = result.hasMore;
        _page = 1;
        _loadingInitial = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingInitial = false;
        _errorMessage = e is PapersLoadException ? e.message : e.toString();
      });
    }
  }

  /// Pull-to-refresh: reload first page without toggling full-screen skeleton.
  Future<void> _onRefresh() async {
    setState(() => _errorMessage = null);
    try {
      final result = await _repo.fetchPage(1);
      if (!mounted) return;
      setState(() {
        _papers
          ..clear()
          ..addAll(result.items);
        _hasMore = result.hasMore;
        _page = 1;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is PapersLoadException ? e.message : e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final nextPage = _page + 1;
      final result = await _repo.fetchPage(nextPage);
      if (!mounted) return;
      setState(() {
        _papers.addAll(result.items);
        _page = nextPage;
        _hasMore = result.hasMore;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      final msg = e is PapersLoadException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Couldn’t load more: $msg'),
          action: SnackBarAction(label: 'Retry', onPressed: _loadMore),
        ),
      );
    }
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 1:
        break;
      case 2:
        _stubNav('Wrong Answers');
        break;
      case 3:
        _stubNav('Review');
        break;
      case 4:
        _stubNav('Profile');
        break;
      default:
        break;
    }
  }

  void _stubNav(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name — coming soon')),
    );
  }

  /// [timed] reserved for future timer mode on the grid / exam flow.
  void _openPaper(PaperItem paper, {required bool timed}) {
    if (paper.year == 2025) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const PastPapersGridPage(),
          settings: RouteSettings(arguments: timed),
        ),
      );
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => PaperDetailPlaceholderPage(paper: paper),
          settings: RouteSettings(arguments: timed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxW = papersMaxContentWidth();
    final hPad = MediaQuery.sizeOf(context).width >= 600
        ? PapersTokens.horizontalPadding + 12
        : PapersTokens.horizontalPadding;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    hPad,
                    FigmaTokens.screenPaddingV * 0.5,
                    hPad,
                    0,
                  ),
                  child: HomeTopNavBar(
                    selectedIndex: 1,
                    onSelect: _onNavTap,
                  ),
                ),
                SizedBox(height: PapersTokens.afterNavGap),
                Expanded(
                  child: RefreshIndicator(
                    color: scheme.primary,
                    onRefresh: _onRefresh,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
                          sliver: SliverToBoxAdapter(child: _PageHeader(scheme: scheme)),
                        ),
                        if (_loadingInitial && _papers.isEmpty)
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              hPad,
                              0,
                              hPad,
                              PapersTokens.bottomListPadding,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: PapersSkeleton(itemCount: 6),
                            ),
                          )
                        else if (_errorMessage != null && _papers.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: hPad),
                              child: _PapersErrorState(
                                message: _errorMessage!,
                                onRetry: _loadInitial,
                              ),
                            ),
                          )
                        else if (_papers.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: hPad),
                              child: const _PapersEmptyState(),
                            ),
                          )
                        else ...[
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
                            sliver: PaperList(
                              papers: _papers,
                              onPracticeMode: (p) => _openPaper(p, timed: false),
                              onTimedMode: (p) => _openPaper(p, timed: true),
                            ),
                          ),
                          if (_loadingMore)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: scheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: PapersTokens.bottomListPadding),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AMC8 Past Papers 📝',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: PapersTokens.pageTitleSize + 1,
                fontWeight: FontWeight.w800,
                color: isLight
                    ? PapersTokens.pageTitleNavyLight
                    : scheme.onSurface,
                letterSpacing: -0.4,
                height: 1.15,
              ),
        ),
        SizedBox(height: PapersTokens.titleTopGap),
        Text(
          'Practice with official AMC8 competition papers organized by year',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: PapersTokens.pageSubtitleSize,
                fontWeight: FontWeight.w400,
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
        ),
        SizedBox(height: PapersTokens.afterSubtitleGap),
      ],
    );
  }
}

class _PapersErrorState extends StatelessWidget {
  const _PapersErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 52, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PapersEmptyState extends StatelessWidget {
  const _PapersEmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_rounded, size: 56, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              'No papers yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'When exams are available, they will show up here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
