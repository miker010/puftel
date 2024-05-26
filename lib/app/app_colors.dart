import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {

 static Color getColor (int colorIndex) {
    switch (colorIndex) {
      case 0 :
        return Color(0xFF4A9BCC);
      case 1 :
        return Colors.brown;
      case 2 :
        return Colors.pink;
      case 3 :
        return Colors.green;
      case 4 :
        return Colors.orange;
      case 5 :
        return Colors.deepOrangeAccent;
      case 6 :
        return Colors.purple;
      case 7 :
        return Colors.blueGrey;
      case 8 :
        return Colors.indigo;
      default:
        return Colors.black;
    }
  }

  static const Color appPrimaryColor        = Color(0xFF4A9BCC);
  static const Color appSecondaryColorLight = Color(0xFFE1F0FA);
  static const Color appSecondaryColorDark  = Color(0xFF145F82);
  static const Color appPrimaryBackgroundColor = Color(0xFF91CCE6);
  static const Color appPrimaryBackgroundLiveColor = Color(0xFFB3EEF8);
  static const Color appPrimaryColorWarning        = Color(0xFFBB7C37);

  static const Color appPrimaryColorYellow        = Color(0xFFFFD500);
  static const Color appSecondaryYellowLight      = Color(0XFFFFE76D);
  static const Color appSecondaryYellowDark       = Color(0XFFF9C421);

  static const Color appPrimaryColorMint          = Color(0xFF48D6D2);
  static const Color appPrimaryColorMintLight     = Color(0xFF81E9E6);
  static const Color appPrimaryColorMintDark      = Color(0xFF2EB1AE);

  static const Color appPrimaryColorGrey          = Color(0xFFE3E9ED);
  static const Color appPrimaryColorGreyLight     = Color(0xFFEDF2F6);
  static const Color appPrimaryColorGreyDark      = Color(0xFFD6DDE1);
  static const Color appPrimaryColorGreyDarker    = Color(0xFF8288A0);

  static const Color appPrimaryColorBlueDarker    = Color(0xFF111336);
  static const Color appPrimaryColorBlueDark      = Color(0xFF2B2D55);

  static const Color appPrimaryColorBlue          = Color(0xFF145F82);
  static const Color appPrimaryColorBlueLight     = Color(0xFF0498FB);

  static const Color appPrimaryColorBlack         = Color(0xFF000000);
  static const Color appPrimaryColorWhite         = Color(0xFFFFFFFF);

  static const Color appPrimaryColorRed           = Color(0xFFF2535F);
  static const Color appPrimaryColorOrange        = Color(0xFFFE9E59);
  static const Color appPrimaryColorGreen         = Color(0xff78D23C);
  static const Color appPrimaryColorGreenDark     = Color(0xff45A009);
  static const Color appPrimaryColorGreenLight    = Color(0xff78d23c);
  static const Color appPrimaryColorGreenLighter  = Color(0xffe6f7d4);

}