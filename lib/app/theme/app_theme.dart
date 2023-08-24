import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/variables/colors.dart';

class AppThemes {
  static ThemeData light = ThemeData(
    primaryColor: ColorTable.primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: ColorTable.primaryColor,
      secondary: const Color.fromARGB(30, 53, 56, 151),
    ),
    iconTheme: IconThemeData(color: ColorTable.primaryColor),
    fontFamily: 'Segoe',
    scaffoldBackgroundColor: const Color(0xFFF6F6F6),
    appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
  );
}
