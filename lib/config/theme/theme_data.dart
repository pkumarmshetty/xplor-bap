import 'package:flutter/material.dart';

class AppColors {
  //Seller
  Color background;

  // neutral black
  Color nb50;
  Color nb100;
  Color nb200;
  Color nb300;
  Color nb400;
  Color nb500;
  Color nb600;
  Color nb700;
  Color nb800;
  Color nb900;

  // brand primary(Blue)
  Color blue50;
  Color blue100;
  Color blue200;
  Color blue300;
  Color blue400;
  Color blue500;
  Color blue600;
  Color blue700;
  Color blue800;
  Color blue900;
  Color blueLight;

  // grey colors
  Color grey50;
  Color grey100;
  Color grey200;
  Color grey300;
  Color grey400;
  Color grey500;
  Color grey600;
  Color grey700;
  Color grey800;
  Color grey900;

  //Status Color

  // Success
  Color success600;
  Color success400;
  Color success50;

  // Warning
  Color warning600;
  Color warning400;
  Color warning50;

  // Error
  Color error600;
  Color error400;
  Color error50;
  Color error;

  // primary
  Color white;
  Color black;

  Color heading;
  Color border;

  // Base Color
  Color bcGray;
  Color bcGray200;
  Color bcGray400;
  Color bcGray500;

  //Blue

  //Others
  Color lightBlue;
  Color borderGrey;

  AppColors({
    required this.borderGrey,
    required this.background,
    required this.nb50,
    required this.nb100,
    required this.nb200,
    required this.nb300,
    required this.nb400,
    required this.nb500,
    required this.nb600,
    required this.nb700,
    required this.nb800,
    required this.nb900,
    required this.blue50,
    required this.blue100,
    required this.blue200,
    required this.blue300,
    required this.blue400,
    required this.blue500,
    required this.blue600,
    required this.blue700,
    required this.blue800,
    required this.blue900,
    required this.blueLight,
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
    required this.success600,
    required this.success400,
    required this.success50,
    required this.warning600,
    required this.warning400,
    required this.warning50,
    required this.error600,
    required this.error400,
    required this.error50,
    required this.error,
    required this.white,
    required this.black,
    required this.heading,
    required this.border,
    required this.bcGray,
    required this.bcGray200,
    required this.bcGray400,
    required this.bcGray500,
    required this.lightBlue,
  });
}

class AppTheme {
  AppColors colors;
  ThemeData themeData;

  AppTheme({required this.colors, required this.themeData});
}
