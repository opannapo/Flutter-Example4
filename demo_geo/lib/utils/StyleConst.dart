import 'package:flutter/material.dart';

class TextStyleConst {
  static TextStyle n12(Color color) {
    return new TextStyle(
        color: color ?? Colors.black,
        letterSpacing: 1,
        fontSize: 12,
        fontStyle: FontStyle.normal);
  }

  static TextStyle b14(Color color) {
    return new TextStyle(
        color: color ?? Colors.black,
        letterSpacing: 2,
        fontSize: 14,
        fontWeight: FontWeight.bold);
  }

  static TextStyle b32(Color color) {
    return new TextStyle(
        color: color ?? Colors.black,
        letterSpacing: 2,
        fontSize: 32,
        fontWeight: FontWeight.bold);
  }
}
