import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';

// Point d'entrée principal de l'application
void main() async {
  // S'assure que Flutter est bien initialisé avant de lancer l'application
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialise le formatage des dates en français (ex: "11 juin 2026")
  await initializeDateFormatting('fr_FR', null);
  
  // Rend la barre de statut du téléphone transparente pour faire plus joli
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
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
    return MaterialApp(
      title: 'MiniPress', // Le titre de l'application
      debugShowCheckedModeBanner: false, // Enlève la petite étiquette rouge "Debug" en haut à droite
      theme: ThemeData(
        primarySwatch: Colors.blue, // Couleur principale de l'application (bleu)
        scaffoldBackgroundColor: Colors.grey[100], // Couleur de fond gris clair pour toutes les pages
      ),
      home: const HomeScreen(), // La première page qui s'affiche (l'accueil)
    );
  }
}
