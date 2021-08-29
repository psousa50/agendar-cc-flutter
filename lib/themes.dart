import 'package:flutter/material.dart';

class AppColors {
  static const foundTable = Color(0xff0080cc);
  static const selectedTable = Color(0xffcc00cc);
}

const primaryColor = Color(0xfff0ad4e);
const accentColor = Color(0xff26c6da);
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

var lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  accentColor: accentColor,
  selectedRowColor: selectedColor,
  textTheme: textLightTheme,
);

var darkTheme = ThemeData.dark().copyWith(
  selectedRowColor: selectedColor,
  textTheme: textDarkTheme,
);
