import 'package:flutter/material.dart';

abstract final class AppColors {
  static const accent = Color(0xFFC28362);
  static const cream = Color(0xFFFFFBF8);
  static const peach = Color(0xFFFBEDE3);
  static const ink = Color(0xFF3D3D3D);
}

ThemeData storeTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: brightness,
    primary: AppColors.accent,
    surface: dark ? const Color(0xFF2C2D30) : AppColors.cream,
    onSurface: dark ? const Color(0xFFE0D8D3) : AppColors.ink,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: 'Quicksand',
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      centerTitle: true,
      elevation: 0,
    ),
    dividerColor: dark ? const Color(0xFF515155) : const Color(0xFFF0DDD0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(100, 48),
        textStyle: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: scheme.onSurface.withValues(alpha: .6),
        fontSize: 13,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: dark ? const Color(0xFF555559) : const Color(0xFFE5C9B7),
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accent),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    ),
  );
}

extension StoreTheme on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get panel => isDark ? const Color(0xFF3C3D41) : Colors.white;
  Color get soft => isDark ? const Color(0xFF38393D) : AppColors.peach;
  Color get ink => Theme.of(this).colorScheme.onSurface;
  Color get muted => ink.withValues(alpha: .55);
}
