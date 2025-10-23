import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  static const BoxShadow light = BoxShadow(
    color: AppColors.shadowLight,
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );

  static const BoxShadow medium = BoxShadow(
    color: AppColors.shadowMedium,
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );

  static const BoxShadow dark = BoxShadow(
    color: AppColors.shadowDark,
    offset: Offset(0, 8),
    blurRadius: 16,
    spreadRadius: 0,
  );
}
