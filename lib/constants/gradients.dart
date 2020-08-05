import "package:flutter/rendering.dart";
import 'package:tundr/constants/colors.dart';

class Gradients {
  static const Gradient transparentToBlack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.transparentBlack,
      AppColors.black,
    ],
  );
  static const Gradient blackToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.black,
      AppColors.transparentBlack,
    ],
  );
  static const Gradient greenToBlack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.green,
      AppColors.black,
    ],
  );
  static const Gradient transparentToGold = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.transparentGold,
      AppColors.gold,
    ],
  );
  static const Gradient goldToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.gold,
      AppColors.transparentGold,
    ],
  );
  static const Gradient transparentToGrey = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.transparentGrey,
      AppColors.grey,
    ],
  );
  static const Gradient greyToTransparent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.grey,
      AppColors.transparentGrey,
    ],
  );
  static const Gradient blackRadial = RadialGradient(
    colors: [
      AppColors.black,
      AppColors.transparentBlack,
    ],
  );
}
