import 'package:amc8/screens/papers/models/paper_item.dart';

/// Thrown when [PapersRepository.fetchPage] cannot load data (maps to error UI + retry).
class PapersLoadException implements Exception {
  PapersLoadException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// One page of list data for pagination.
class PapersPageResult {
  const PapersPageResult({
    required this.items,
    required this.hasMore,
  });

  final List<PaperItem> items;
  final bool hasMore;
}

/// Mock backend: **2025–2020** only (single page). Replace with API later.
class PapersRepository {
  PapersRepository();

  /// If true, the **next** [fetchPage] call throws, then clears itself.
  static bool simulateNetworkErrorOnce = false;

  static const int _firstYear = 2025;
  static const int _lastYear = 2020;

  static final List<PaperItem> _catalog = _buildCatalog();

  static List<PaperItem> _buildCatalog() {
    final items = <PaperItem>[];
    for (var y = _firstYear; y >= _lastYear; y--) {
      items.add(
        PaperItem(
          id: '$y',
          year: y,
          displayTitle: 'AMC8 $y',
          questionCount: 25,
        ),
      );
    }
    return items;
  }

  /// Fetches [page] (1-based). Page **1** returns all years; further pages are empty.
  Future<PapersPageResult> fetchPage(int page, {int pageSize = 8}) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));

    if (simulateNetworkErrorOnce) {
      simulateNetworkErrorOnce = false;
      throw PapersLoadException(
        'Couldn’t load papers. Check your connection and try again.',
      );
    }

    if (page < 1) {
      return const PapersPageResult(items: [], hasMore: false);
    }

    if (page == 1) {
      return PapersPageResult(items: List<PaperItem>.from(_catalog), hasMore: false);
    }

    return const PapersPageResult(items: [], hasMore: false);
  }
}
