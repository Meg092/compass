import 'package:flutter/material.dart';

class FengshuiConstants {
  static const List<String> tianGan = [
    '甲',
    '乙',
    '丙',
    '丁',
    '戊',
    '己',
    '庚',
    '辛',
    '壬',
    '癸',
  ];

  static const List<String> diZhi = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ];

  static const List<String> shiChenTimeRanges = [
    '23:00-01:00',
    '01:00-03:00',
    '03:00-05:00',
    '05:00-07:00',
    '07:00-09:00',
    '09:00-11:00',
    '11:00-13:00',
    '13:00-15:00',
    '15:00-17:00',
    '17:00-19:00',
    '19:00-21:00',
    '21:00-23:00',
  ];

  static const Map<String, String> tianGanWuXing = {
    '甲': '木',
    '乙': '木',
    '丙': '火',
    '丁': '火',
    '戊': '土',
    '己': '土',
    '庚': '金',
    '辛': '金',
    '壬': '水',
    '癸': '水',
  };

  static const Map<String, String> diZhiWuXing = {
    '子': '水',
    '丑': '土',
    '寅': '木',
    '卯': '木',
    '辰': '土',
    '巳': '火',
    '午': '火',
    '未': '土',
    '申': '金',
    '酉': '金',
    '戌': '土',
    '亥': '水',
  };

  static const Map<String, String> dayToZiShiMap = {
    '甲': '甲',
    '己': '甲',
    '乙': '丙',
    '庚': '丙',
    '丙': '戊',
    '辛': '戊',
    '丁': '庚',
    '壬': '庚',
    '戊': '壬',
    '癸': '壬',
  };

  static const Map<String, String> wuXingSheng = {
    '金': '水',
    '水': '木',
    '木': '火',
    '火': '土',
    '土': '金',
  };

  static const Map<String, String> wuXingBeiKe = {
    '木': '金',
    '土': '木',
    '水': '土',
    '火': '水',
    '金': '火',
  };

  static const Map<String, List<Color>> wuXingColors = {
    '金': [Color(0xFFFFFFFF), Color(0xFFFFD700), Color(0xFFC0C0C0)],
    '木': [Color(0xFF00C853), Color(0xFF4CAF50), Color(0xFF00BCD4)],
    '水': [Color(0xFF000000), Color(0xFF2196F3), Color(0xFF1976D2)],
    '火': [
      Color(0xFFE53935),
      Color(0xFF9C27B0),
      Color(0xFFFFB6C1),
      Color(0xFFFF4081),
    ],
    '土': [
      Color(0xFFFFC107),
      Color(0xFF8B4513),
      Color(0xFFFF9800),
      Color(0xFFD2691E),
    ],
  };

  static const Map<int, String> weekdayMap = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期日',
  };
}
