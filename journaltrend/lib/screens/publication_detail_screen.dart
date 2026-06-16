import 'package:flutter/material.dart';
import '../models/publication.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({Key? key, required this.publication}) : super(key: key);

  Future<void> _launchDOI() async {
    if (publication.doi.isNotEmpty) {
      final url = Uri.parse(publication.doi);
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch DOI URL: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Detail'),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                publication.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.calendar_today, 'Year', publication.publicationYear.toString()),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.bar_chart, 'Citations', publication.citedByCount.toString()),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.book, 'Journal', publication.journalName),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              Text('Authors', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: publication.authors.map((author) => Chip(label: Text(author))).toList(),
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
  
              if (publication.abstractText != null && publication.abstractText!.isNotEmpty) ...[
                Text('Abstract', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  publication.abstractText!,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
  
              if (publication.doi.isNotEmpty)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _launchDOI,
                    icon: const Icon(Icons.link),
                    label: const Text('Open DOI in Browser'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
