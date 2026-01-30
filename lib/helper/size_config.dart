import 'package:flutter/material.dart';


class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? miniText;
  static double? midtinyText;
  static double? tinyText;
  static double? smalltinyText;
  static double? smallSubText;
  static double? subText;
  static double? smallTitleText;
  static double? medtitleText;
  static double? titleText;
  static double? medbigText;
  static double? bigText;
  static double? heightAndWidth;
  static double? bigHeightAndWidth;
  static double?  maxHeightAndWidth;
  static double? commonMargin;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    //web sizing
    miniText = 8;
    midtinyText = 9;
    tinyText = 11;
    smalltinyText= 12;
    subText = 15;
    smallSubText = 13;
    smallTitleText = 17;
    medtitleText = 18;
    titleText = 19;
    medbigText = 21;
    bigText = 27;
    heightAndWidth = 10;
    bigHeightAndWidth = 15;
    maxHeightAndWidth = 20;
    commonMargin = 10;
  }
}
