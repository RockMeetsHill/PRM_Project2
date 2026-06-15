import 'package:flutter/material.dart';
import '../models/author.dart';
import '../theme/app_theme.dart';

class AuthorTile extends StatelessWidget {
  final Author author;
  final int index;

  const AuthorTile({
    super.key,
    required this.author,
    required this.index,
  });

  String get _initials {
    if (author.name.isEmpty) return "";
    final parts = author.name.trim().split(" ");
    if (parts.length > 1) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return author.name[0].toUpperCase();
  }

  Color get _avatarColor {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.accentColor,
      Colors.deepOrange,
      Colors.indigo,
      Colors.teal,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _avatarColor,
          foregroundColor: Colors.white,
          child: Text(
            _initials,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          author.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            '${author.paperCount} papers',
            style: const TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
