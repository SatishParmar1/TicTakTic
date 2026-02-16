import 'package:flutter/material.dart';

class HexString {
  static hexStringToColor(String? hexColor) {
    if (hexColor == '') {
      return Color(0xFFFFFF);
    }
    hexColor = hexColor?.toUpperCase().replaceAll("#", "");
    if (hexColor?.length == 6) {
      hexColor = "FF" + (hexColor ?? "00FFFFF") ;
    }
    return Color(int.parse(hexColor ?? "FFFFFFFF", radix: 16));
  }
}
