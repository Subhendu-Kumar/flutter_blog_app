import 'package:flutter/material.dart';
import 'package:blog_app/core/theme/pallete.dart';

class AppTheme {
  static _border([Color color = Pallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 2.5),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: Pallete.backgroundColor),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.all(Pallete.backgroundColor),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(20),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(Pallete.gradient2),
      errorBorder: _border(Pallete.errorColor),
    ),
  );
}
