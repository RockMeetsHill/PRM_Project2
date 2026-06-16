import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import 'publication_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Unfocus keyboard
      FocusScope.of(context).unfocus();
      context.read<SearchProvider>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Trend Analyzer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter a research topic (e.g., Artificial Intelligence)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          
          if (provider.isLoadingPublications)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (provider.publicationsError != null)
            Expanded(child: Center(child: Text(provider.publicationsError!, style: const TextStyle(color: Colors.red))))
          else if (provider.publications.isEmpty && provider.currentTopic.isNotEmpty)
            const Expanded(child: Center(child: Text('No publications found.')))
          else if (provider.publications.isEmpty)
            const Expanded(child: Center(child: Text('Search for a topic to analyze trends.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.publications.length,
                itemBuilder: (context, index) {
                  final pub = provider.publications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        pub.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Year: ${pub.publicationYear} | Citations: ${pub.citedByCount}'),
                          Text('Journal: ${pub.journalName}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
              ),
            ),
        ],
      ),
    );
  }
}
