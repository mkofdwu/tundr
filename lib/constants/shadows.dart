import 'package:flutter/rendering.dart';
import 'package:tundr/constants/colors.dart';

class Shadows {
  static const BoxShadow primaryShadow = BoxShadow(
    color: AppColors.shadowGrey,
    offset: Offset(0.0, 3.0),
    blurRadius: 6.0,
  );
  static const BoxShadow secondaryShadow = BoxShadow(
    color: AppColors.shadowGrey,
    offset: Offset(0, 5.0),
    blurRadius: 10.0,
  );
}
