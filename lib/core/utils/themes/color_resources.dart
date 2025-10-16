import 'package:flutter/material.dart';

class ColorResources {
  static Color backgroundColor = Color.fromRGBO(118, 7, 7, 1);
  static LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff872209),
      Color(0xffAA6845),
      Color(0xffAA6845),
      Color(0xffAA6845),
      Color(0xffffffff),
    ],
  );
}
