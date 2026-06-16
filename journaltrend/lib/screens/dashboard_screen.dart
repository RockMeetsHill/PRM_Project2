import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../models/trend_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.currentTopic.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Research Dashboard')),
        body: const Center(child: Text('Search for a topic first.')),
      );
    }

    if (provider.isLoadingTrends || provider.isLoadingPublications) {
      return Scaffold(
        appBar: AppBar(title: const Text('Research Dashboard')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Topic: ${provider.currentTopic}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            
            // Summary Cards
            Row(
              children: [
                Expanded(child: _buildSummaryCard(context, 'Total Pubs', provider.totalPublications.toString(), Colors.blueAccent)),
                const SizedBox(width: 8),
                Expanded(child: _buildSummaryCard(context, 'Avg Citations', provider.averageCitations.toString(), Colors.orangeAccent)),
                const SizedBox(width: 8),
                Expanded(child: _buildSummaryCard(context, 'Active Year', provider.mostActiveYear, Colors.greenAccent)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Most Influential Paper
            if (provider.mostInfluentialPaper != null) ...[
              Text('Most Influential Paper', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(provider.mostInfluentialPaper!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${provider.mostInfluentialPaper!.publicationYear} | Citations: ${provider.mostInfluentialPaper!.citedByCount}'),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Top Authors
            Text('Top Contributing Authors', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildList(provider.topAuthors.take(5).toList()),
            
            const SizedBox(height: 24),

            // Top Journals
            Text('Top Research Journals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildList(provider.topJournals.take(5).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<TrendData> items) {
    if (items.isEmpty) return const Text('No data available.');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Text('${index + 1}'),
            ),
            title: Text(item.label),
            trailing: Text('${item.count} pubs', style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
