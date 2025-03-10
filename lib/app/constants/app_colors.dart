import 'package:flutter/material.dart';

class AppColors {
  // Grayscale
  static const Color titleActive = Color(0xFF222222);
  static const Color body = Color(0xFF333333);
  static const Color label = Color(0xFF555555);
  static const Color placeholder = Color(0xFF888888);
  static const Color line = Color(0xFFDCDCDC);
  static const Color inputBackground = Color(0xFFF0F0F0);
  static const Color background = Color(0xFFF8F8F8);
  static const Color offWhite = Color(0xFFFCFCFC);

  // Colors
  static const Color primary = Color(0xFF5E00BE);

  static const Color error = Color(0xFFFD0025);
  static const Color success = Color(0xFF009846);
  static const Color warning = Color(0xFFFF6711);
  static const gradientPrimary = LinearGradient(
    colors: [
      Color(0xFF0038F5),
      Color(0xFF9F03FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const secondary = LinearGradient(
    colors: [
      Color(0xFF0000EB),
      Color(0xFF004BFB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
