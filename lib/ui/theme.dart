import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: 'Merriweather',
          fontSize: 40.0,
          color: const Color(0xFF555555),
        ),
        title: base.title.copyWith(
          fontFamily: 'Merriweather',
          fontSize: 15.0,
          color: const Color(0xFF555555),
        ),
        caption: base.caption.copyWith(
          color: const Color(0xFF555555),
        ),
        body1: base.body1.copyWith(color: const Color(0xFF555555)));
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFF2196F3),
    accentColor: const Color(0xFFFFFFFF),
    iconTheme: IconThemeData(
      color: const Color(0xFFCCCCCC),
      size: 20.0,
    ),
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
  );
}
