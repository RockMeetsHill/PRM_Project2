import 'package:flutter/material.dart';
import '../models/publication.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({super.key, required this.publication});

  Future<void> _launchDOI(BuildContext context) async {
    if (publication.doi.isNotEmpty) {
      try {
        final url = Uri.parse(publication.doi);
        final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the DOI link.')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid DOI URL: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Detail'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: publication.doi.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _launchDOI(context),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Read Paper'),
            )
          : null,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SelectableText(
                  publication.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Metadata Card
              Card(
                elevation: 0,
                color: Colors.black.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(context, Icons.calendar_today, 'Year', publication.publicationYear.toString()),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)),
                      _buildInfoRow(context, Icons.bar_chart, 'Citations', publication.citedByCount.toString()),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)),
                      _buildInfoRow(context, Icons.book, 'Journal', publication.journalName),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Authors Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('Authors', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: publication.authors.map((author) {
                  final initial = author.trim().isNotEmpty ? author.trim()[0].toUpperCase() : '?';
                  return ActionChip(
                    label: Text(author),
                    avatar: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(initial, style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Search for $author coming soon!')),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
  
              // Abstract Section
              if (publication.abstractText != null && publication.abstractText!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('Abstract', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(
                      publication.abstractText!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              SelectableText(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
