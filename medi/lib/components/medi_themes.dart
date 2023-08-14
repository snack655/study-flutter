import 'package:flutter/material.dart';
import 'package:medi/components/medi_colors.dart';

class MediThemes {
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: MediColors.primaryMaterialColor,
    fontFamily: 'GmarketSansTTF',
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: _appBarTheme,
    textTheme: _textTheme,
  );

  static ThemeData get dartTheme => ThemeData(
    primarySwatch: MediColors.primaryMaterialColor,
    fontFamily: 'GmarketSansTTF',
    splashColor: Colors.white,
    brightness: Brightness.dark,
    textTheme: _textTheme,
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: MediColors.primaryColor),
    elevation: 0,
  );

  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: MediColors.primaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: MediColors.primaryColor,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: MediColors.primaryColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: MediColors.primaryColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: MediColors.primaryColor,
    ),
    labelLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: MediColors.primaryColor,
    ),
  );
}