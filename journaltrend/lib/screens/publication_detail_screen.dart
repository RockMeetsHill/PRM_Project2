// screens/publication_detail_screen.dart
// Purpose: Displays comprehensive details about a publication including its title, authors list, year, journal name, citations, DOI, abstract, and a CTA link.

import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../theme/app_theme.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({
    super.key,
    required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Detail'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Publication Title
                    Text(
                      publication.title,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Authors row (horizontal list of Chips)
                    const Text(
                      'Authors',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      height: 48.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: publication.authors.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                backgroundColor: AppTheme.primaryColor,
                                child: Text(
                                  publication.authors[index][0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              label: Text(
                                publication.authors[index],
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Info section (Card)
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, color: AppTheme.accentColor, size: 20),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Year: ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text('${publication.year}', style: const TextStyle(fontSize: 14)),
                                const Spacer(),
                                const Icon(Icons.newspaper, color: AppTheme.accentColor, size: 20),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    publication.journalName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.star_outline, color: AppTheme.accentColor, size: 20),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Citations: ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text('${publication.citationCount}', style: const TextStyle(fontSize: 14)),
                                const Spacer(),
                                const Icon(Icons.link, color: AppTheme.accentColor, size: 20),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (publication.doi != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Opening DOI: ${publication.doi}'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      publication.doi ?? 'No DOI',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: publication.doi != null ? Colors.blue[800] : Colors.grey,
                                        decoration: publication.doi != null ? TextDecoration.underline : null,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Divider + Abstract Heading
                    const Divider(),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Abstract',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      publication.abstract ?? "Abstract not available",
                      style: const TextStyle(
                        fontSize: 15.0,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom full-width action button
            Padding(
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Redirecting to OpenAlex for: ${publication.title}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('View on OpenAlex'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
