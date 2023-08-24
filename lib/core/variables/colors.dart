import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorTable {
// Common
  static Color darkModeBg = const Color(0xff292929);
  static Color lightModeBg = const Color.fromARGB(255, 246, 246, 246);
  static Color splashBg = const Color(0xff010303);

  static Color errorColor = Colors.red[400]!;
  static Color buttonColor = const Color.fromARGB(255, 246, 246, 246);
  static Color errorColorLight = const Color.fromRGBO(254, 221, 229, 1);
  static Color successColorLight = const Color.fromRGBO(213, 251, 224, 1);
  static Color successColor = const Color.fromARGB(255, 22, 148, 58);
  static Color waitingColorLight = const Color.fromARGB(255, 255, 174, 93);
  static Color toggleableBackgroundColor = const Color.fromRGBO(230, 230, 230, 1);
  static Color waitingColor = const Color.fromARGB(255, 255, 145, 0);
  static Color returnColor = const Color.fromARGB(255, 200, 0, 255);
  static Color returnColorLight = const Color.fromARGB(255, 220, 93, 255);
  static Color get getTextColor => Get.isDarkMode ? Colors.white : const Color.fromARGB(255, 107, 107, 107);
  static Color get getReversedTextColor => Get.isDarkMode ? Colors.black : Colors.white;

  static Color get primaryColor {
    return Colors.deepPurple;
  }
}
