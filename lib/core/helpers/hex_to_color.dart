import 'package:flutter/material.dart';

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // Add full opacity if alpha is missing
  return Color(int.parse(hex, radix: 16));
}
