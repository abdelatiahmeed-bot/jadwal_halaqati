import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicTheme {
  // Brand Colors
  static const Color oliveDeep = Color(0xFF2F3C28);
  static const Color oliveLight = Color(0xFF34422B);
  static const Color goldMetallic = Color(0xFFC5A85A);
  static const Color goldAccent = Color(0xFFF3E5AB);
  static const Color emeraldGreen = Color(0xFF0F52BA);
  static const Color mintPastel = Color(0xFFE4ECD5);
  
  // Theme Data Builder
  static ThemeData buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    
    final ColorScheme scheme = isDark
        ? const ColorScheme.dark(
            primary: goldMetallic,
            onPrimary: Colors.black,
            primaryContainer: oliveDeep,
            onPrimaryContainer: Colors.white,
            secondary: goldMetallic,
            onSecondary: Colors.black,
            tertiary: oliveLight,
            surface: Color(0xFF1E261A),
            onSurface: Color(0xFFECF3EE),
            surfaceContainer: Color(0xFF252F21),
            error: Color(0xFFCF6679),
          )
        : const ColorScheme.light(
            primary: oliveLight,
            onPrimary: Colors.white,
            primaryContainer: mintPastel,
            onPrimaryContainer: oliveDeep,
            secondary: goldMetallic,
            onSecondary: Colors.white,
            tertiary: oliveDeep,
            surface: Color(0xFFF7F8F5),
            onSurface: Color(0xFF34422B),
            surfaceContainer: Colors.white,
            error: Color(0xFFB00020),
          );

    final TextTheme baseTextTheme = GoogleFonts.cairoTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    // Custom fonts mapping: Amiri for Quran/Arabic text and headers
    final TextTheme customizedTextTheme = baseTextTheme.copyWith(
      displayLarge: GoogleFonts.amiri(
        textStyle: baseTextTheme.displayLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      displayMedium: GoogleFonts.amiri(
        textStyle: baseTextTheme.displayMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      displaySmall: GoogleFonts.amiri(
        textStyle: baseTextTheme.displaySmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineLarge: GoogleFonts.amiri(
        textStyle: baseTextTheme.headlineLarge?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.amiri(
        textStyle: baseTextTheme.headlineMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleLarge: GoogleFonts.cairo(
        textStyle: baseTextTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      titleMedium: GoogleFonts.cairo(
        textStyle: baseTextTheme.titleMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
      titleSmall: GoogleFonts.cairo(
        textStyle: baseTextTheme.titleSmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
      bodyLarge: GoogleFonts.cairo(
        textStyle: baseTextTheme.bodyLarge?.copyWith(
          color: scheme.onSurface,
        ),
      ),
      bodyMedium: GoogleFonts.cairo(
        textStyle: baseTextTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
        ),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: customizedTextTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? scheme.surface : const Color(0xFF34422B),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: customizedTextTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 2,
        shadowColor: isDark ? Colors.transparent : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xFFE2EBE5),
            width: 0.8,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.secondary,
          side: BorderSide(color: scheme.secondary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E2B23) : const Color(0xFFF1F6F3),
        labelStyle: GoogleFonts.cairo(color: scheme.onSurface.withValues(alpha: 0.7)),
        hintStyle: GoogleFonts.cairo(color: scheme.onSurface.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: goldMetallic,
        unselectedLabelColor: Colors.white70,
        indicatorColor: goldMetallic,
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  // Common UI Styles helper
  static BoxDecoration premiumCardDecoration({required BuildContext context, bool isElevated = true}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white12 : const Color(0xFFE2EBE5),
        width: 1,
      ),
      boxShadow: isElevated && !isDark
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
  }

  // Button styles helper for outliner
  static ButtonStyle outlinedButtonFrom({
    required Color foregroundColor,
    required BorderSide side,
    required EdgeInsetsGeometry padding,
    required OutlinedBorder shape,
    required TextStyle textStyle,
  }) {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(foregroundColor),
      side: WidgetStateProperty.all<BorderSide>(side),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding),
      shape: WidgetStateProperty.all<OutlinedBorder>(shape),
      textStyle: WidgetStateProperty.all<TextStyle>(textStyle),
    );
  }
}
