// screens/trend_analysis_screen.dart
// Purpose: Features 3 tabs showing trend charts over the years, Top Journals listing with progress indicators, and Top Contributing Authors.

import 'package:flutter/material.dart';
import '../mock/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/trend_chart.dart';
import '../widgets/journal_tile.dart';
import '../widgets/author_tile.dart';

class TrendAnalysisScreen extends StatelessWidget {
  const TrendAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine max publication count for JournalTile percentages
    final maxPubs = MockData.journals.isNotEmpty
        ? MockData.journals.map((j) => j.publicationCount).reduce((a, b) => a > b ? a : b)
        : 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trend Analysis'),
          bottom: const TabBar(
            indicatorColor: AppTheme.accentColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: 'Trend'),
              Tab(icon: Icon(Icons.newspaper), text: 'Journals'),
              Tab(icon: Icon(Icons.people), text: 'Authors'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Trend
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  const Text(
                    'Publications per Year',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Historical publication metrics in Artificial Intelligence from 2015 to 2024.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TrendChart(data: MockData.trendData),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),

            // Tab 2: Journals
            ListView.builder(
              itemCount: MockData.journals.length,
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              itemBuilder: (context, index) {
                final journal = MockData.journals[index];
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12.0),
                      const Text(
                        'Top Research Journals',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      JournalTile(
                        journal: journal,
                        rank: index + 1,
                        maxPublications: maxPubs,
                      ),
                    ],
                  );
                }
                return JournalTile(
                  journal: journal,
                  rank: index + 1,
                  maxPublications: maxPubs,
                );
              },
            ),

            // Tab 3: Authors
            ListView.builder(
              itemCount: MockData.authors.length,
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              itemBuilder: (context, index) {
                final author = MockData.authors[index];
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12.0),
                      const Text(
                        'Top Contributing Authors',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      AuthorTile(
                        author: author,
                        index: index,
                      ),
                    ],
                  );
                }
                return AuthorTile(
                  author: author,
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
