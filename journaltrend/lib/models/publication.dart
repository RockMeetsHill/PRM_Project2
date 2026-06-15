// models/publication.dart
class Publication {
  final String id;
  final String title;
  final int year;
  final int citationCount;
  final String journalName;
  final List<String> authors;
  final String? doi;
  final String? abstract;

  const Publication({
    required this.id,
    required this.title,
    required this.year,
    required this.citationCount,
    required this.journalName,
    required this.authors,
    this.doi,
    this.abstract,
  });
}
