// ============================================================================
// A. LE POINT D'ENTRÉE : main.dart
// C'est le fichier qui démarre l'application.
//
// 1. Initialisations requises :
//    - WidgetsFlutterBinding.ensureInitialized() s'assure que le moteur de
//      Flutter est prêt avant de lancer du code asynchrone.
//    - initializeDateFormatting('fr_FR', null) prépare la bibliothèque de
//      formatage pour afficher les dates en français (ex. : "15 juin 2026").
//
// 2. Lancement de l'application :
//    - runApp(const MiniPressApp()) instancie et lance le widget racine de
//      l'application, ce qui démarre la construction de l'arbre des widgets.
// ============================================================================

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

// Point d'entrée principal de l'application
void main() async {
  // S'assure que Flutter est bien initialisé avant de lancer l'application
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise le formatage des dates en français (ex: "11 juin 2026")
  await initializeDateFormatting('fr_FR', null);

  // Configure la transparence et la luminosité de la barre de statut du téléphone
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Lance le widget principal de notre application
  runApp(const MiniPressApp());
}

// Widget principal qui configure l'application (le thème, le titre et la première page)
class MiniPressApp extends StatelessWidget {
  const MiniPressApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Couleurs globales de l'application
    final Color primaryColor = const Color(0xFF4F46E5);
    final Color secondaryColor = const Color(0xFF06B6D4);
    final Color scaffoldBgColor =
        const Color(0xFFF8FAFC);
    final Color textDarkColor =
        const Color(0xFF0F172A);

    return MaterialApp(
      title: 'MiniPress', // Le titre de l'application
      debugShowCheckedModeBanner:
          false, // Enlève la petite étiquette rouge "Debug" en haut à droite
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: textDarkColor,
        ),
        scaffoldBackgroundColor: scaffoldBgColor,
        // Configure la police de caractères de l'application
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.light().textTheme,
        ).apply(
          bodyColor: textDarkColor,
          displayColor: textDarkColor,
        ),
        // Configuration de la barre supérieure (AppBarTheme)
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          centerTitle: false,
          iconTheme: IconThemeData(color: textDarkColor),
          titleTextStyle: GoogleFonts.outfit(
            color: textDarkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
        // Configuration des cartes (CardTheme)
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color(
                  0xFFE2E8F0), // Couleur de la bordure
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        // Configuration des boutons textuels
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
        ),
        // Configuration des puces (Chips)
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          disabledColor: Colors.grey[200],
          selectedColor: primaryColor.withValues(alpha: 0.12),
          secondarySelectedColor: primaryColor.withValues(alpha: 0.12),
          labelStyle: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textDarkColor,
          ),
          secondaryLabelStyle: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFFE2E8F0)),
          ),
        ),
        // Configuration des champs de saisie (Inputs)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          hintStyle: GoogleFonts.outfit(
            color: const Color(0xFF94A3B8),
            fontSize: 14,
          ),
          prefixIconColor: const Color(0xFF64748B),
          suffixIconColor: const Color(0xFF64748B),
        ),
      ),
      home: const HomeScreen(), // La première page qui s'affiche (l'accueil)
    );
  }
}
