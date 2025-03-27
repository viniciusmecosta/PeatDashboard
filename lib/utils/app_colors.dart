import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF298F5E);
  static const Color primaryDark = Color(0xFF2D9966);
  static const Color accent = Color(0xFFFFE151);

  static const Color lightBackground = Colors.white;
  static const Color lightText = Colors.black;
  static const Color lightSecondaryText = Color(0xFF616161);
  static const Color lightBorder = Color(0xFFE0E0E0);

  static const Color darkBackground = Color(0xFF18181B);
  static const Color darkBackground2 = Color(0xFF09090B);
  static const Color darkText = Colors.white;
  static const Color darkSecondaryText = Colors.grey;
  static const Color darkBorder = Color(0xFF2A2A2E);

  static const Color gridLine = Color(0x1A000000);
  static const Color darkGridLine = Color(0x1AFFFFFF);
  static const Color shadow = Color(0x33000000);
  static const Color darkShadow = Color(0x66000000);

  static const Color mainPrimary = Color(0xFF298F5E);
  static const Color mainDarkSurface = Color(0xFF09090B);
  static const Color mainDarkBackground = Color(0xFF09090B);
  static const Color mainDarkCard = Color(0xFF18181B);

  static Color metricCardBackground(BuildContext context) =>
      backgroundColor(context);

  static Color metricCardBorder(BuildContext context) => borderColor(context);

  static Color metricCardShadow(BuildContext context) => shadowColor(context);

  static Color metricCardTitleText(BuildContext context) =>
      secondaryTextColor(context);

  static Color metricCardValueText(BuildContext context) => textColor(context);

  static Color metricCardDateText(BuildContext context) =>
      secondaryTextColor(context);

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  static Color textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkText : lightText;

  static Color secondaryTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSecondaryText
          : lightSecondaryText;

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : lightBorder;

  static Color shadowColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkShadow : shadow;

  static Color gridColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGridLine : gridLine;
}
