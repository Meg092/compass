import 'package:flutter/material.dart';
import '../constants/fengshui_constants.dart';

class ColorCalculator {
  static List<Color> getSuitableColors(String wuXing) {
    List<Color> colors = [];

    if (FengshuiConstants.wuXingColors.containsKey(wuXing)) {
      colors.addAll(FengshuiConstants.wuXingColors[wuXing]!);
    }

    String shengWuXing = getShengWuXing(wuXing);
    if (FengshuiConstants.wuXingColors.containsKey(shengWuXing)) {
      colors.addAll(FengshuiConstants.wuXingColors[shengWuXing]!);
    }

    return colors;
  }

  static List<Color> getAvoidColors(String wuXing) {
    List<Color> colors = [];

    String keWuXing = getBeiKeWuXing(wuXing);
    if (FengshuiConstants.wuXingColors.containsKey(keWuXing)) {
      colors.addAll(FengshuiConstants.wuXingColors[keWuXing]!);
    }

    return colors;
  }

  static String getShengWuXing(String wuXing) {
    return FengshuiConstants.wuXingSheng[wuXing] ?? '土';
  }

  static String getBeiKeWuXing(String wuXing) {
    return FengshuiConstants.wuXingBeiKe[wuXing] ?? '土';
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static String getColorName(Color color) {
    int r = color.red;
    int g = color.green;
    int b = color.blue;

    if (r == g && g == b) {
      if (r < 50) return '黑色';
      if (r > 200) return '白色';
      return '灰色';
    }

    if (r > g && r > b) {
      if (g > 100 && b < 100) return '橙色';
      if (b > g) return '粉色';
      return '紅色';
    }

    if (g > r && g > b) {
      if (r > 100) return '黃色';
      if (b > 100) return '青色';
      return '綠色';
    }

    if (b > r && b > g) {
      if (r > 100) return '紫色';
      return '藍色';
    }

    if (r > 150 && g > 100 && b < 100) return '橙色';
    if (r > 100 && g > 150 && b < 100) return '黃色';
    if (r < 100 && g > 100 && b > 150) return '青色';

    return '混合色';
  }

  static List<String> getWuXingColorNames(String wuXing) {
    const Map<String, List<String>> wuXingColorNames = {
      '金': ['白色', '金色', '銀色'],
      '木': ['綠色', '淺綠', '青色'],
      '水': ['黑色', '藍色', '深藍'],
      '火': ['紅色', '紫色', '粉色', '玫紅'],
      '土': ['黃色', '棕色', '橙色', '巧克力色'],
    };

    return wuXingColorNames[wuXing] ?? ['未知'];
  }
}
