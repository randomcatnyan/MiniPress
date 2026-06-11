import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/categorie.dart';

// Un bouton personnalisé (Chip) représentant une catégorie d'articles.
// Note : Actuellement non utilisé dans l'écran principal au profit de ChoiceChip de Flutter.
class CategorieChip extends StatelessWidget {
  final Categorie categorie; // La catégorie liée à ce bouton
  final bool isSelected; // Est-ce que cette catégorie est actuellement sélectionnée ?
  final VoidCallback onTap; // L'action à effectuer au clic sur le bouton

  const CategorieChip({
    super.key,
    required this.categorie,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Durée de l'animation de transition
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              // Dégradé de bleu si sélectionné, sinon couleur bleu foncé fixe
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF0077A8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                  )
                  : null,
              color: isSelected ? null : const Color(0xFF1A2840),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00B4D8)
                    : const Color(0xFF00B4D8).withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ]
                  : null,
            ),
            child: Text(
              categorie.titre,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
