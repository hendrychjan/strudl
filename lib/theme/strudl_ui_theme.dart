import 'package:flutter/material.dart';

class StrudlUiTheme {
  static final ThemeData darkTheme = buildDarkTheme();

  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    const primaryColor = Color(0xFF00b4ab);
    const secondaryColor = Color(0xFF00b4ab);

    return base.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(accentColor: primaryColor),
      splashColor: primaryColor,

      // Circular Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}
