import 'package:flutter/material.dart';
import '../models/journal.dart';
import '../theme/app_theme.dart';

class JournalTile extends StatelessWidget {
  final Journal journal;
  final int rank;
  final int maxPublications;

  const JournalTile({
    super.key,
    required this.journal,
    required this.rank,
    required this.maxPublications,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxPublications > 0 ? journal.publicationCount / maxPublications : 0.0;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              title: Text(
                journal.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${journal.publicationCount} publications',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                minHeight: 6.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
