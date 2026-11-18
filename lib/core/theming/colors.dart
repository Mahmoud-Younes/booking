import 'package:flutter/material.dart';

/// Central color constants (static consts on one class).
class ColorsManager {
  ColorsManager._();

  // Booking-like palette (deep blue primary, warm yellow accent).
  static const Color mainBlue = Color(0xFF003580);
  static const Color lightBlue = Color(0xFF0071C2);
  static const Color accentYellow = Color(0xFFFEBA02);
  static const Color darkBlue = Color(0xFF00224F);

  // Grays.
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color darkerGray = Color(0xFF424242);

  // Semantic.
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color errorRed = Color(0xFFC62828);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
}
