import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/publication.dart';
import '../providers/library_provider.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Publication Detail', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.6),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(color: Colors.transparent),
          ),
        ),
        actions: [
          Consumer<LibraryProvider>(
            builder: (context, library, child) {
              final isSaved = library.isSaved(publication.id);
              return IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
                tooltip: isSaved ? 'Remove from Library' : 'Save to Library',
                onPressed: () {
                  library.toggleSaved(publication);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isSaved ? 'Removed from library' : 'Saved to library!')),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
        ],
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
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 24.0,
            bottom: 80.0,
          ),
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
                _ExpandableAbstract(text: publication.abstractText!),
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

class _ExpandableAbstract extends StatefulWidget {
  final String text;

  const _ExpandableAbstract({required this.text});

  @override
  State<_ExpandableAbstract> createState() => _ExpandableAbstractState();
}

class _ExpandableAbstractState extends State<_ExpandableAbstract> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                widget.text,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              secondChild: SelectableText(
                widget.text,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Show Less' : 'Read More',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
