// screens/search_screen.dart
// Purpose: Displays search interface with suggestion chips, states (Initial, Loading, Results, Empty, Error), and list of publications.

import 'package:flutter/material.dart';
import '../mock/mock_data.dart';
import '../models/publication.dart';
import '../theme/app_theme.dart';
import '../widgets/publication_card.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum SearchState { initial, loading, results, empty, error }

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  SearchState _currentState = SearchState.initial;
  List<Publication> _filteredPublications = [];
  String _errorMessage = "";

  final List<String> _suggestions = [
    "Artificial Intelligence",
    "Blockchain",
    "IoT",
    "Cybersecurity",
    "Data Science",
    "Software Engineering"
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _triggerSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _currentState = SearchState.initial;
        _filteredPublications = [];
      });
      return;
    }

    setState(() {
      _currentState = SearchState.loading;
    });

    // Simulate network delay to OpenAlex API
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      final normalizedQuery = query.trim().toLowerCase();

      if (normalizedQuery == 'error' || normalizedQuery == 'fail') {
        setState(() {
          _currentState = SearchState.error;
          _errorMessage = "Failed to connect to OpenAlex API. Please check your connection.";
        });
        return;
      }

      // Filter local mock publications
      final results = MockData.publications.where((pub) {
        final matchTitle = pub.title.toLowerCase().contains(normalizedQuery);
        final matchJournal = pub.journalName.toLowerCase().contains(normalizedQuery);
        final matchAuthor = pub.authors.any((a) => a.toLowerCase().contains(normalizedQuery));
        return matchTitle || matchJournal || matchAuthor;
      }).toList();

      setState(() {
        if (results.isEmpty) {
          _currentState = SearchState.empty;
        } else {
          _filteredPublications = results;
          _currentState = SearchState.results;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Trend Analyzer'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar container
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: "Search publications, journals, authors...",
              leading: const Icon(Icons.search, color: AppTheme.primaryColor),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _triggerSearch("");
                    },
                  ),
              ],
              onSubmitted: _triggerSearch,
              onChanged: (val) {
                setState(() {}); // refresh trailing close icon
              },
            ),
          ),

          // suggestion chips container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: _suggestions.map((chipLabel) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(chipLabel),
                    selected: _searchController.text == chipLabel,
                    onSelected: (selected) {
                      if (selected) {
                        _searchController.text = chipLabel;
                        _triggerSearch(chipLabel);
                      }
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: _searchController.text == chipLabel
                          ? AppTheme.primaryColor
                          : Colors.black87,
                      fontWeight: _searchController.text == chipLabel
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Main body state switcher
          Expanded(
            child: _buildStateWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildStateWidget() {
    switch (_currentState) {
      case SearchState.initial:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48.0),
              Icon(
                Icons.science_outlined,
                size: 100,
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Explore Scientific Publications",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Type keywords above or tap a suggestion chip to analyze research trends and citations via OpenAlex.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Tip for simulator testing
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.amber[50],
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            "Pro-tip: search 'error' to simulate error state, or 'nothing' to see empty state.",
                            style: TextStyle(fontSize: 12.0, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case SearchState.loading:
        return const LoadingSkeleton(itemCount: 5);
      case SearchState.results:
        return ListView.builder(
          itemCount: _filteredPublications.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            return PublicationCard(
              publication: _filteredPublications[index],
            );
          },
        );
      case SearchState.empty:
        return const EmptyState(
          title: "No Results Found",
          subtitle: "We couldn't find any publications matching your query. Try different terms.",
        );
      case SearchState.error:
        return ErrorState(
          message: _errorMessage,
          onRetry: () => _triggerSearch(_searchController.text),
        );
    }
  }
}
