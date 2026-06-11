import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/categorie.dart';

/// Chip cliquable représentant une catégorie
class CategorieChip extends StatelessWidget {
  final Categorie categorie;
  final bool isSelected;
  final VoidCallback onTap;

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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
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
