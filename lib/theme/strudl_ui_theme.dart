import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StrudlUiTheme {
  static final ThemeData darkTheme = buildDarkTheme();

  static ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.light();

    const primaryColor = Color(0xFF2da44e);
    const secondaryColor = Color.fromARGB(12, 45, 164, 78);
    const backgroundColor = Colors.white;

    return base.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: primaryColor,
        primarySwatch: MaterialColor(primaryColor.value, {
          50: Color(0xffe8f5e9),
          100: Color(0xffc8e6c9),
          200: Color(0xffa5d6a7),
          300: Color(0xff81c784),
          400: Color(0xff66bb6a),
          500: Color(0xff4caf50),
          600: Color(0xff43a047),
          700: Color(0xff388e3c),
          800: Color(0xff2e7d32),
          900: Color(0xff1b5e20),
        }),
      ),
      splashColor: primaryColor,

      // Card
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        surfaceTintColor: secondaryColor,
        color: secondaryColor,
      ),

      appBarTheme: const AppBarTheme(
        toolbarHeight: 90,
        centerTitle: true,
        backgroundColor: backgroundColor,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        actionsIconTheme: IconThemeData(
          color: primaryColor,
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
      ),

      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),

      // Text Selection
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor,
        selectionColor: Color.fromARGB(66, 45, 164, 78),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 17,
            )),
      ),

      // Input
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        fillColor: secondaryColor,
        filled: true,
        hintStyle: const TextStyle(
          color: primaryColor,
        ),
        labelStyle: const TextStyle(
          color: primaryColor,
        ),
        iconColor: primaryColor,
      ),

      iconTheme: const IconThemeData(
        color: primaryColor,
      ),

      scaffoldBackgroundColor: backgroundColor,

      // Circular Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}
