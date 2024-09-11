import 'package:flutter/material.dart';
import 'package:xplor/utils/extensions/color/color.dart';

import '../../utils/app_colors.dart';
import 'theme_data.dart';

final _primaryColor = "#346ddb".hexToColor();

AppTheme themeLight = AppTheme(
  colors: AppColors(),
  themeData: ThemeData(
    useMaterial3: false,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light().copyWith(
      primary: _primaryColor,
      secondary: _primaryColor,
    ),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: Colors.white,
        ),
  ),
);
