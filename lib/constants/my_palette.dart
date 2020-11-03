import 'package:flutter/rendering.dart';

class MyPalette {
  // colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFBBBBBB);
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xFF014421);
  static const Color gold = Color(0xFFAC9227);
  static const Color red = Color(0xFFAC2727);
  static const Color shadowGrey = Color(0x29000000);
  static const Color darkGrey = Color(0xFF222222);
  static const Color transparentBlack = Color(0x00000000);
  static const Color transparentGold = Color(0x00AC9227);
  static const Color transparentGrey = Color(0x00BBBBBB);

  // shadows
  static const BoxShadow primaryShadow = BoxShadow(
    color: MyPalette.shadowGrey,
    offset: Offset(0.0, 3.0),
    blurRadius: 6.0,
  );
  static const BoxShadow secondaryShadow = BoxShadow(
    color: MyPalette.shadowGrey,
    offset: Offset(0, 5.0),
    blurRadius: 10.0,
  );

  // gradients
  static const Gradient transparentToBlack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.transparentBlack,
      MyPalette.black,
    ],
  );
  static const Gradient blackToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.black,
      MyPalette.transparentBlack,
    ],
  );
  static const Gradient greenToBlack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.green,
      MyPalette.black,
    ],
  );
  static const Gradient transparentToGold = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.transparentGold,
      MyPalette.gold,
    ],
  );
  static const Gradient goldToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.gold,
      MyPalette.transparentGold,
    ],
  );
  static const Gradient transparentToGrey = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.transparentGrey,
      MyPalette.grey,
    ],
  );
  static const Gradient greyToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      MyPalette.grey,
      MyPalette.transparentGrey,
    ],
  );
  static const Gradient blackRadial = RadialGradient(
    colors: [
      MyPalette.black,
      MyPalette.transparentBlack,
    ],
  );
}
