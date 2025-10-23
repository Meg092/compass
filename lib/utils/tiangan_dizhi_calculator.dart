import '../constants/fengshui_constants.dart';
import '../pages/luopan_clothing_guide/models/shichen_model.dart';

class TianGanDiZhiCalculator {
  static final DateTime _baseDate = DateTime(1900, 1, 1);
  static const int _baseGanIndex = 5;
  static const int _baseZhiIndex = 5;

  static int getShiChenIndex(DateTime dateTime) {
    int hour = dateTime.hour;

    if (hour == 23) return 0;
    if (hour == 0) return 0;

    if (hour >= 1 && hour < 3) return 1;

    return ((hour - 1) ~/ 2 + 1) % 12;
  }

  static String calculateRiGanZhi(DateTime date) {
    int daysDiff = date.difference(_baseDate).inDays;

    int ganIndex = (_baseGanIndex + daysDiff) % 10;

    int zhiIndex = (_baseZhiIndex + daysDiff) % 12;

    return FengshuiConstants.tianGan[ganIndex] +
        FengshuiConstants.diZhi[zhiIndex];
  }

  static String calculateRiGan(DateTime date) {
    int daysDiff = date.difference(_baseDate).inDays;
    int ganIndex = (_baseGanIndex + daysDiff) % 10;
    return FengshuiConstants.tianGan[ganIndex];
  }

  static String calculateZiShiGan(String riGan) {
    return FengshuiConstants.dayToZiShiMap[riGan] ?? '甲';
  }

  static String calculateShiGan(String ziShiGan, int shiChenIndex) {
    int ziShiGanIndex = FengshuiConstants.tianGan.indexOf(ziShiGan);
    int shiGanIndex = (ziShiGanIndex + shiChenIndex * 2) % 10;
    return FengshuiConstants.tianGan[shiGanIndex];
  }

  static String getShiChenWuXing(String tianGan, String diZhi) {
    return FengshuiConstants.tianGanWuXing[tianGan] ?? '土';
  }

  static String calculateJiXiong(String wuXing, DateTime date) {
    String riGan = calculateRiGan(date);
    String riWuXing = FengshuiConstants.tianGanWuXing[riGan] ?? '土';

    if (wuXing == riWuXing) {
      return '吉'; // 比和
    }

    if (_isShengRi(wuXing, riWuXing)) {
      return '吉'; // 生扶
    }

    if (_isKeRi(wuXing, riWuXing)) {
      return '凶'; // 克制
    }

    return '吉';
  }

  static bool _isShengRi(String wuXing, String riWuXing) {
    String? shengWuXing = FengshuiConstants.wuXingSheng[wuXing];
    return shengWuXing == riWuXing;
  }

  static bool _isKeRi(String wuXing, String riWuXing) {
    String? beiKeWuXing = FengshuiConstants.wuXingBeiKe[riWuXing];
    return wuXing == beiKeWuXing;
  }

  static List<ShiChen> calculateShiChenList(DateTime date) {
    String riGan = calculateRiGan(date);

    String ziShiGan = calculateZiShiGan(riGan);

    List<ShiChen> list = [];
    for (int i = 0; i < 12; i++) {
      String diZhi = FengshuiConstants.diZhi[i];
      String tianGan = calculateShiGan(ziShiGan, i);
      String wuXing = getShiChenWuXing(tianGan, diZhi);
      String jiXiong = calculateJiXiong(wuXing, date);

      list.add(
        ShiChen(
          diZhi: diZhi,
          tianGan: tianGan,
          jiXiong: jiXiong,
          wuXing: wuXing,
          index: i,
          timeRange: FengshuiConstants.shiChenTimeRanges[i],
        ),
      );
    }

    return list;
  }
}
