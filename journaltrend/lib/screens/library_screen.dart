import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/library_provider.dart';
import 'publication_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Library'),
        elevation: 0,
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, library, child) {
          final allPublications = library.savedPublications;
          
          if (allPublications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/empty_box.json',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.library_books, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                  ),
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

          final filteredPublications = allPublications.where((pub) {
            final query = _searchQuery.toLowerCase();
            return pub.title.toLowerCase().contains(query) ||
                   pub.journalName.toLowerCase().contains(query) ||
                   pub.authors.any((a) => a.toLowerCase().contains(query));
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search library...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ) 
                      : null,
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredPublications.isEmpty
                  ? const Center(child: Text('No matching journals found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredPublications.length,
                      itemBuilder: (context, index) {
                        final pub = filteredPublications[index];
                        return Dismissible(
                          key: Key(pub.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            library.toggleSaved(pub);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Journal removed'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    library.toggleSaved(pub);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Card(
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
                                  style: TextStyle(color: theme.colorScheme.primary),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.bookmark),
                                color: theme.colorScheme.primary,
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
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
