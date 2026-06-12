import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      clipBehavior: Clip.antiAlias, // Permet de bien rogner les coins si on a un effet InkWell
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Espacement externe
      child: InkWell(
        onTap: onTap, // Clic sur la carte entière
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur de couleur vertical à gauche (accent Indigo)
              Container(
                width: 4,
                height: 52, // Hauteur fixe pour s'aligner joliment avec le texte
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5), // Indigo moderne
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Corps de l'article (titre + infos)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de l'article
                    Text(
                      article.titre,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A), // slate-900
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10), // Espacement vertical
                    // Ligne affichant la date et l'auteur de l'article
                    Row(
                      children: [
                        // Date de création
                        if (article.cree != null) ...[
                          const Icon(
                            Icons.calendar_today_outlined, 
                            size: 13, 
                            color: Color(0xFF64748B), // slate-500
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(article.cree),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B), // slate-500
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        // Nom de l'auteur (cliquable pour filtrer)
                        if (article.auteurNom != null) ...[
                          GestureDetector(
                            onTap: () {
                              if (onAuthorTap != null) {
                                onAuthorTap!(article.auteurNom!); // Déclenche le filtre par auteur
                              }
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9), // slate-100
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0), // slate-200
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.alternate_email, 
                                      size: 11, 
                                      color: Color(0xFF4F46E5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      article.auteurNom!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF475569), // slate-600
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Petite flèche à droite pour indiquer qu'on peut cliquer
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 14.0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded, 
                    size: 14, 
                    color: Color(0xFF94A3B8), // slate-400
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
