import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import 'publication_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Library'),
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, library, child) {
          final publications = library.savedPublications;

          if (publications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved journals yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore and save some!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: publications.length,
            itemBuilder: (context, index) {
              final pub = publications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    pub.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${pub.journalName} • ${pub.publicationYear}',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      library.toggleSaved(pub);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicationDetailScreen(publication: pub),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
