import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const foundTable = Color(0xff0080cc);
  static const selectedTable = Color(0xffcc00cc);
}

const primaryColor = Color(0xfff0ad4e);
const secondaryColor = Colors.teal;
const onSecondaryColor = Colors.white;
const mainTextColor = Color(0xff0095a8);
var textLightThemeColor = Colors.grey.shade600;
var textDarkThemeColor = Colors.grey.shade300;
var selectedColor = Colors.red;

var textLightTheme = ThemeData.light()
    .textTheme
    .apply(
      bodyColor: textLightThemeColor,
    )
    .copyWith(
      subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        color: mainTextColor,
      ),
    );

var textDarkTheme = ThemeData.dark()
    .textTheme
    .apply(
      bodyColor: textDarkThemeColor,
    )
    .copyWith(
      subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        color: mainTextColor,
      ),
    );

var lightTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: secondaryColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: secondaryColor,
    ),
  ),
  primarySwatch: generateMaterialColor(primaryColor),
  selectedRowColor: selectedColor,
  textTheme: textLightTheme,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
  ),
);

var darkTheme = ThemeData.dark().copyWith(
  selectedRowColor: selectedColor,
  textTheme: textDarkTheme,
);

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
