class Publication {
  final String id;
  final String title;
  final int publicationYear;
  final int citedByCount;
  final String journalName;
  final String doi;
  final List<String> authors;
  final String? abstractText;

  Publication({
    required this.id,
    required this.title,
    required this.publicationYear,
    required this.citedByCount,
    required this.journalName,
    required this.doi,
    required this.authors,
    this.abstractText,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    // Parse authors
    List<String> parsedAuthors = [];
    if (json['authorships'] != null) {
      for (var authorObj in json['authorships']) {
        final authorInfo = authorObj['author'];
        if (authorInfo != null && authorInfo['display_name'] != null) {
          parsedAuthors.add(authorInfo['display_name']);
        }
      }
    }

    // Parse journal
    String parsedJournal = 'Unknown Journal';
    if (json['primary_location'] != null &&
        json['primary_location']['source'] != null &&
        json['primary_location']['source']['display_name'] != null) {
      parsedJournal = json['primary_location']['source']['display_name'];
    }

    // Parse abstract from inverted index
    String? parsedAbstract;
    if (json['abstract_inverted_index'] != null) {
      Map<String, dynamic> invertedIndex = json['abstract_inverted_index'];
      // Reconstruct abstract
      // The inverted index maps words to lists of positions
      int maxPosition = -1;
      Map<int, String> positionToWord = {};
      
      invertedIndex.forEach((word, positionsList) {
        List<dynamic> positions = positionsList;
        for (var pos in positions) {
          int intPos = pos as int;
          positionToWord[intPos] = word;
          if (intPos > maxPosition) {
            maxPosition = intPos;
          }
        }
      });
      
      if (maxPosition >= 0) {
        List<String> words = List.filled(maxPosition + 1, '');
        positionToWord.forEach((pos, word) {
          words[pos] = word;
        });
        parsedAbstract = words.where((w) => w.isNotEmpty).join(' ');
      }
    }

    return Publication(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      publicationYear: json['publication_year'] ?? 0,
      citedByCount: json['cited_by_count'] ?? 0,
      journalName: parsedJournal,
      doi: json['doi'] ?? '',
      authors: parsedAuthors,
      abstractText: parsedAbstract,
    );
  }
}
