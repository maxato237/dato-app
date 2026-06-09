// ============================================================
// DATO — Thème (port des design tokens de tokens.css)
// Dossier conseillé : lib/core/theme/
//   app_colors.dart · app_spacing.dart · app_theme.dart
// Ici regroupé en un seul fichier pour le starter — à scinder ensuite.
// Dépendance : google_fonts (Sora + Inter)
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Marque
  static const ink = Color(0xFF1B4965); // primaire
  static const ink700 = Color(0xFF163D56);
  static const ink600 = Color(0xFF205A7D);
  static const ink100 = Color(0xFFE7EEF3);
  static const ink050 = Color(0xFFF1F6F9);

  static const green = Color(0xFF2BA84A); // succès / argent
  static const green700 = Color(0xFF218A3C);
  static const green100 = Color(0xFFE4F5E9);

  static const amber = Color(0xFFF4A300); // CTA secondaire
  static const amber700 = Color(0xFFC98700);
  static const amber100 = Color(0xFFFDF1D8);

  static const whatsapp = Color(0xFF25D366);

  // Sémantiques
  static const danger = Color(0xFFE5484D);
  static const danger100 = Color(0xFFFDE8E8);

  // Neutres
  static const bg = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE3E8EE);
  static const borderStrong = Color(0xFFD2DAE3);
  static const text = Color(0xFF101828);
  static const textMuted = Color(0xFF475467);
  static const textLight = Color(0xFF98A2B3);
}

/// Couleurs (texte / fond) par statut de devis.
class StatusColors {
  static const draftFg = Color(0xFF5B6573);
  static const draftBg = Color(0xFFEEF0F3);
  static const sentFg = Color(0xFF1B4965);
  static const sentBg = Color(0xFFE7EEF3);
  static const acceptedFg = Color(0xFF218A3C);
  static const acceptedBg = Color(0xFFE4F5E9);
  static const refusedFg = Color(0xFFC0383C);
  static const refusedBg = Color(0xFFFDE8E8);
}

/// Échelle d'espacement 4px.
class AppSpacing {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;
}

/// Rayons.
class AppRadii {
  static const sm = 8.0;
  static const md = 10.0;
  static const lg = 12.0;
  static const xl = 16.0;
  static const pill = 999.0;
}

/// Cible tactile minimale.
const double kMinTapTarget = 48.0;

class AppTheme {
  static ThemeData light() {
    // Titres : Sora — Corps : Inter
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    final inter = GoogleFonts.interTextTheme(base.textTheme);

    TextStyle sora(double size, FontWeight w) =>
        GoogleFonts.sora(fontSize: size, fontWeight: w, color: AppColors.text, height: 1.2);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.ink,
        secondary: AppColors.amber,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),
      textTheme: inter.copyWith(
        displaySmall: sora(28, FontWeight.w700),
        headlineMedium: sora(24, FontWeight.w700),
        headlineSmall: sora(20, FontWeight.w600),
        titleLarge: sora(17, FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.text, height: 1.5),
        bodyMedium: GoogleFonts.inter(fontSize: 15, color: AppColors.text, height: 1.47),
        bodySmall: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted, height: 1.4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(kMinTapTarget),
          textStyle: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(kMinTapTarget),
          side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
          textStyle: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
