import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';

// Un widget simple (Carte) pour afficher un résumé d'un article dans la liste.
class ArticleCard extends StatelessWidget {
  final Article article; // L'article à afficher
  final VoidCallback onTap; // L'action à faire quand on clique sur toute la carte (ouvrir le détail)
  final ValueChanged<String>? onAuthorTap; // L'action à faire quand on clique sur le nom de l'auteur (filtrer par auteur)

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onAuthorTap,
  });

  // Fonction pour transformer une date texte (ex: "2026-06-11 10:00:00") en format lisible (ex: "11 juin 2026")
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'fr_FR').format(dt);
    } catch (_) {
      return dateStr; // Si la date est bizarre, on l'affiche telle quelle
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Espacement externe
      child: ListTile(
        title: Text(
          article.titre,
          style: const TextStyle(fontWeight: FontWeight.bold), // Titre de l'article en gras
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affiche le résumé de l'article s'il existe et n'est pas vide
            if (article.resume != null && article.resume!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                article.resume!,
                maxLines: 2, // Limite à 2 lignes maximum
                overflow: TextOverflow.ellipsis, // Coupe le texte avec "..." s'il dépasse
              ),
            ],
            const SizedBox(height: 6), // Petit espacement vertical
            // Ligne affichant la date et l'auteur de l'article
            Row(
              children: [
                // Date de création
                if (article.cree != null) ...[
                  const Icon(Icons.calendar_today, size: 12), // Petite icône de calendrier
                  const SizedBox(width: 4),
                  Text(_formatDate(article.cree)),
                  const SizedBox(width: 12),
                ],
                // Nom de l'auteur (cliquable pour filtrer)
                if (article.auteurNom != null) ...[
                  const Icon(Icons.person, size: 12), // Petite icône d'utilisateur
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      if (onAuthorTap != null) {
                        onAuthorTap!(article.auteurNom!); // Déclenche le filtre par auteur
                      }
                    },
                    child: Text(
                      article.auteurNom!,
                      style: const TextStyle(
                        color: Colors.blue, // Texte en bleu
                        decoration: TextDecoration.underline, // Texte souligné pour faire style "lien internet"
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right), // Flèche à droite pour indiquer qu'on peut cliquer
        onTap: onTap, // Clic sur la carte entière
      ),
    );
  }
}
