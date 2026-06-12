import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../services/api_service.dart';

// Écran de détail qui affiche le contenu complet d'un article
class ArticleDetailScreen extends StatefulWidget {
  final String? lien; // Le lien API pour charger l'article complet (ex: /api/articles/5)
  final String titre; // Le titre temporaire à afficher pendant le chargement

  const ArticleDetailScreen({
    super.key,
    required this.lien,
    required this.titre,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ApiService _apiService = ApiService(); // Le service pour récupérer l'article depuis l'API
  late Future<Article> _articleFuture; // Variable contenant l'état futur de l'article chargé

  @override
  void initState() {
    super.initState();
    _load(); // Lance le chargement dès que la page s'ouvre
  }

  // Déclenche la requête HTTP pour récupérer les détails de l'article
  void _load() {
    if (widget.lien != null) {
      _articleFuture = _apiService.fetchArticleByLien(widget.lien!);
    } else {
      _articleFuture = Future.error('Lien manquant.');
    }
  }

  // Formatage de la date (ex: "11 Juin 2026")
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy', 'fr_FR').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre), // Titre temporaire dans la barre du haut
      ),
      // Le FutureBuilder permet d'afficher différents widgets selon que l'API est en train de charger,
      // a échoué ou a renvoyé les données de l'article.
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          // Cas 1 : En cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Affiche un cercle de chargement qui tourne
            );
          }
          // Cas 2 : Erreur de chargement (ex: pas d'internet)
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 64, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _load()), // Bouton pour recommencer le chargement
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // Cas 3 : Chargement réussi avec succès
          else if (snapshot.hasData) {
            final article = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image d'illustration de l'article (utilisant cached_network_image)
                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty) ...[
                    CachedNetworkImage(
                      imageUrl: article.imageUrl!,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 240,
                        color: const Color(0xFFF1F5F9), // slate-100
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 240,
                        color: const Color(0xFFF1F5F9), // slate-100
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Color(0xFF94A3B8), // slate-400
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Badge de catégorie
                        if (article.categorieNom != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF06B6D4).withOpacity(0.08), // Cyan très doux
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF06B6D4).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              article.categorieNom!.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0891B2), // Cyan foncé
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // 3. Titre de l'article (Typography Playfair Display pour le côté éditorial/presse)
                        Text(
                          article.titre,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A), // slate-900
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4. Fiche d'informations de l'auteur et de la date (Avatar + Détails alignés)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC), // slate-50
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                                radius: 20,
                                child: Text(
                                  article.auteurNom != null && article.auteurNom!.isNotEmpty
                                      ? article.auteurNom![0].toUpperCase()
                                      : 'M',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF4F46E5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rédacteur',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B), // slate-500
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    GestureDetector(
                                      onTap: () {
                                        if (article.auteurNom != null) {
                                          Navigator.of(context).pop(article.auteurNom!);
                                        }
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(
                                          article.auteurNom ?? 'Auteur anonyme',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF4F46E5), // Lien bleu indigo cliquable
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (article.cree != null) ...[
                                Container(
                                  height: 32,
                                  width: 1,
                                  color: const Color(0xFFE2E8F0),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Publié le',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(article.cree),
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF334155), // slate-700
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 16),

                        // 5. Résumé de l'article (Chapeau / En-tête de contenu avec une bordure de citation)
                        if (article.resume != null && article.resume!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFF4F46E5), // Bordure gauche Indigo
                                  width: 4.0,
                                ),
                              ),
                            ),
                            child: Text(
                              article.resume!,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF334155), // slate-700
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 6. Contenu complet de l'article
                        if (article.contenu != null && article.contenu!.isNotEmpty)
                          Text(
                            article.contenu!,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF334155), // slate-700
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // Cas par défaut (si pas de données)
          return const Center(child: Text('Aucune donnée.'));
        },
      ),
    );
  }
}
