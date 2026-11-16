import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color lavender = Color(0xFFEDE9FE);
  static const Color lavenderSoft = Color(0xFFF5F3FF);
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color scaffoldLight = Color(0xFFF6F5FB);
  static const Color cardLight = CupertinoColors.white;
  static const Color scaffoldDark = Color(0xFF111114);
  static const Color cardDark = Color(0xFF1E1E22);
  static const Color textLight = Color(0xFF1C1C1E);
  static const Color textDark = CupertinoColors.white;

  static const CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: scaffoldLight,
    barBackgroundColor: CupertinoColors.white,
  );

  static const CupertinoThemeData dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: scaffoldDark,
    barBackgroundColor: cardDark,
  );

  static bool isDark(BuildContext context) =>
      CupertinoTheme.of(context).brightness == Brightness.dark;
  static Color card(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;
  static Color textColor(BuildContext context) =>
      isDark(context) ? textDark : textLight;
}
