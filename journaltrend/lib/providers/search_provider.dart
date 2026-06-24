import 'package:flutter/foundation.dart';
import '../models/publication.dart';
import '../models/trend_data.dart';
import '../services/openalex_service.dart';

class SearchProvider with ChangeNotifier {
  final OpenAlexService _service = OpenAlexService();

  String _currentTopic = '';
  String get currentTopic => _currentTopic;

  String _selectedChart = 'publications';
  String get selectedChart => _selectedChart;

  void setSelectedChart(String chart) {
    _selectedChart = chart;
    notifyListeners();
  }

  // State variables for Publications
  List<Publication> _publications = [];
  List<Publication> get publications => _publications;
  bool _isLoadingPublications = false;
  bool get isLoadingPublications => _isLoadingPublications;
  String? _publicationsError;
  String? get publicationsError => _publicationsError;

  // State variables for Trends
  List<TrendData> _yearlyTrends = [];
  List<TrendData> get yearlyTrends => _yearlyTrends;
  
  List<TrendData> _topAuthors = [];
  List<TrendData> get topAuthors => _topAuthors;
  
  List<TrendData> _topJournals = [];
  List<TrendData> get topJournals => _topJournals;

  bool _isLoadingTrends = false;
  bool get isLoadingTrends => _isLoadingTrends;
  String? _trendsError;
  String? get trendsError => _trendsError;

  // Combined Dashboard Metrics
  int get totalPublications => _yearlyTrends.fold(0, (sum, item) => sum + item.count);
  int get averageCitations {
    if (_publications.isEmpty) return 0;
    int total = _publications.fold(0, (sum, item) => sum + item.citedByCount);
    return total ~/ _publications.length;
  }
  String get mostActiveYear {
    if (_yearlyTrends.isEmpty) return 'N/A';
    // Find the year with maximum count
    var active = _yearlyTrends.reduce((curr, next) => curr.count > next.count ? curr : next);
    return active.label;
  }

  Publication? get mostInfluentialPaper {
    if (_publications.isEmpty) return null;
    // Since we sort by cited_by_count:desc from API, the first is usually the most influential
    return _publications.first;
  }

  // Actions
  Future<void> search(String topic) async {
    if (topic.trim().isEmpty) return;
    
    _currentTopic = topic;
    _isLoadingPublications = true;
    _isLoadingTrends = true;
    _publicationsError = null;
    _trendsError = null;
    notifyListeners();

    // Fetch publications
    try {
      _publications = await _service.searchPublications(topic);
    } catch (e) {
      _publicationsError = e.toString();
    } finally {
      _isLoadingPublications = false;
      notifyListeners();
    }

    // Fetch trends in parallel
    try {
      final results = await Future.wait([
        _service.getYearlyTrends(topic),
        _service.getTopAuthors(topic),
        _service.getTopJournals(topic),
      ]);
      _yearlyTrends = results[0];
      _topAuthors = results[1];
      _topJournals = results[2];
      
      // Sort trends if needed (group_by usually sorts by count desc, except year which might need sorting)
      _yearlyTrends.sort((a, b) => a.label.compareTo(b.label)); // Sort year ascending

    } catch (e) {
      _trendsError = e.toString();
    } finally {
      _isLoadingTrends = false;
      notifyListeners();
    }
  }

  // Computed data for Author Productivity vs Impact Scatter Plot
  List<AuthorImpactPoint> get authorImpactPoints {
    final Map<String, _AuthorStats> stats = {};
    for (var pub in _publications) {
      for (var author in pub.authors) {
        stats.update(
          author,
          (existing) => _AuthorStats(
            count: existing.count + 1,
            citations: existing.citations + pub.citedByCount,
          ),
          ifAbsent: () => _AuthorStats(count: 1, citations: pub.citedByCount),
        );
      }
    }
    
    final list = stats.entries.map((e) => AuthorImpactPoint(
      authorName: e.key,
      paperCount: e.value.count,
      totalCitations: e.value.citations,
    )).toList();
    
    // Sort by total citations descending
    list.sort((a, b) => b.totalCitations.compareTo(a.totalCitations));
    return list.take(25).toList();
  }
}

class AuthorImpactPoint {
  final String authorName;
  final int paperCount;
  final int totalCitations;

  AuthorImpactPoint({
    required this.authorName,
    required this.paperCount,
    required this.totalCitations,
  });
}

class _AuthorStats {
  final int count;
  final int citations;
  _AuthorStats({required this.count, required this.citations});
}
