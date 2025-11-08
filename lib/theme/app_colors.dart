import 'package:flutter/material.dart';

class AppColors {
  // Primary colors (Green energy / eco theme)
  static const Color primary = Color(0xFF2E7D32);       // deep eco green
  static const Color primaryLight = Color(0xFF60AD5E);  // soft green for hover or highlights
  static const Color primaryDark = Color(0xFF005005);   // dark forest green (pressed state)

  // Secondary colors (Sky blue / energy accent)
  static const Color secondary = Color(0xFF0288D1);       // clear sky blue
  static const Color secondaryLight = Color(0xFF5EB8FF);  // lighter accent for highlights
  static const Color secondaryDark = Color(0xFF01579B);   // deeper blue for contrast

  // Backgrounds
  static const Color background = Color(0xFFF1F8E9); // pale green-tinted background (eco vibe)
  static const Color surface = Colors.white;         // for cards, dialogs, and input fields

  // Text
  static const Color textPrimary = Color(0xFF1B5E20);   // dark green for strong readability
  static const Color textSecondary = Color(0xFF4E6E4E); // softer green-gray for hints/subtitles
  static const Color textOnPrimary = Colors.white;       // text on buttons or AppBars
  static const Color textOnBlack = Colors.black87;// text on buttons or AppBars
  static const Color shadow = Colors.black87;// text on buttons or AppBars

  // Energy or success highlights
  static const Color success = Color(0xFF81C784);       // light energy green for success states
  static const Color warning = Color(0xFFFFB300);// solar yellow for alerts
  static const Color blackIcon = Color(0xFF0E0E0E);// solar yellow for alerts
  static const Color transparentIcon = Color(0xB3EFEFEF);// solar yellow for alerts
  static const Color grayWidget = Color(0xffdde3d6);// solar yellow for alerts

  // Error
  static const Color error = Color(0xFFD32F2F);         // standard red for errors
}
