import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';

/// Carte simple affichée dans la liste des articles
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final ValueChanged<String>? onAuthorTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onAuthorTap,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'fr_FR').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          article.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.resume != null && article.resume!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                article.resume!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 6),
            Row(
              children: [
                if (article.cree != null) ...[
                  const Icon(Icons.calendar_today, size: 12),
                  const SizedBox(width: 4),
                  Text(_formatDate(article.cree)),
                  const SizedBox(width: 12),
                ],
                if (article.auteurNom != null) ...[
                  const Icon(Icons.person, size: 12),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      if (onAuthorTap != null) {
                        onAuthorTap!(article.auteurNom!);
                      }
                    },
                    child: Text(
                      article.auteurNom!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
