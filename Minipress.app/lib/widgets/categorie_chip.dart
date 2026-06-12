import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/categorie.dart';

// Un bouton personnalisé (Chip) représentant une catégorie d'articles.
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250), // Durée de l'animation de transition
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            // Dégradé premium du violet au bleu/cyan si sélectionné, sinon gris slate
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : const Color(0xFFF1F5F9), // slate-100
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : const Color(0xFFE2E8F0), // slate-200
              width: 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            categorie.titre,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569), // slate-600
            ),
          ),
        ),
      ),
    );
  }
}
