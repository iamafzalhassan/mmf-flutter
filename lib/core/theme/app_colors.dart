import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color black = Color(0xFF1A1A1A);
  static const Color gray1 = Color(0xFFF5F5F5);
  static const Color gray3 = Color(0xFFE0E0E0);
  static const Color gray5 = Color(0xFF757575);
  static const Color green1 = Color(0xFF6BC747);
  static const Color green2 = Color(0xFF7ED957);
  static const Color green3 = Color(0xFF2E7D32);
  static const Color outlineGray = Color(0xFF8E8E8E);
  static const Color red = Color(0xFFC62828);
  static const Color white1 = Colors.white;
  static const Color white3 = Color(0xFFF5F3E8);
  static const Color white4 = Color(0xFFD4EDD4);
  static const Color white5 = Color(0xFFE8F5E8);

  static const LinearGradient backgroundGradient = LinearGradient(begin: Alignment.topCenter, colors: [white4, white3], end: Alignment.bottomCenter);
}
