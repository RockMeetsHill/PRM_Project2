// screens/dashboard_screen.dart
// Purpose: Displays the Research Dashboard with a hero gradient card, key insights grid of stats, the most influential paper card, and navigation to the trends tab.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../mock/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/publication_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card (full width, gradient background)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    Color(0xFF303F9F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MockData.topic.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.accentColor.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Scientific Trend Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    '${MockData.totalPublications.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Publications',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Key Insights Section
            const Text(
              'Key Insights',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12.0),

            // GridView 2 columns of StatCard
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1.15,
              children: [
                StatCard(
                  label: "Avg Citations",
                  value: "${MockData.avgCitations}",
                  icon: Icons.format_quote,
                ),
                StatCard(
                  label: "Most Active Year",
                  value: "${MockData.mostActiveYear}",
                  icon: Icons.local_fire_department,
                ),
                StatCard(
                  label: "Top Journal",
                  value: MockData.topJournal,
                  icon: Icons.menu_book,
                ),
                StatCard(
                  label: "Top Author",
                  value: MockData.topAuthor,
                  icon: Icons.person,
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Most Influential Paper Section
            const Text(
              'Most Influential Paper',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            PublicationCard(
              publication: MockData.mostInfluentialPaper,
              showTrophyBadge: true,
            ),
            const SizedBox(height: 24.0),

            // ElevatedButton full width to navigate to /trends
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/trends');
                },
                child: const Text('View Full Trend Analysis'),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
