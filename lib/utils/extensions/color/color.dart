import 'package:flutter/material.dart';

extension HexCodeToColor on String {
  Color hexToColor() {
    return Color(int.parse(toString().replaceAll("#", "0xff")));
  }
}
