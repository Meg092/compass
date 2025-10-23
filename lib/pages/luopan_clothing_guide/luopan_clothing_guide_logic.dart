import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/fengshui_constants.dart';
import '../../utils/tiangan_dizhi_calculator.dart';
import '../../utils/color_calculator.dart';
import 'models/shichen_model.dart';

class LuopanClothingGuideLogic extends GetxController {
  final currentDate = DateTime.now().obs;

  final selectedShiChenIndex = 0.obs;

  final shiChenList = <ShiChen>[].obs;

  final suitableColors = <Color>[].obs;

  final avoidColors = <Color>[].obs;

  final isLoading = false.obs;

  final Map<String, List<ShiChen>> _shiChenCache = {};

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    try {
      isLoading.value = true;

      shiChenList.value = _calculateShiChenList(currentDate.value);

      int currentShiChenIndex = TianGanDiZhiCalculator.getShiChenIndex(
        DateTime.now(),
      );

      selectShiChen(currentShiChenIndex);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      _showErrorToast('數據初始化失敗：${e.toString()}');
    }
  }

  List<ShiChen> _calculateShiChenList(DateTime date) {
    String dateKey = _getDateKey(date);

    if (_shiChenCache.containsKey(dateKey)) {
      return _shiChenCache[dateKey]!;
    }

    List<ShiChen> list = TianGanDiZhiCalculator.calculateShiChenList(date);

    if (_shiChenCache.length > 30) {
      _shiChenCache.clear();
    }
    _shiChenCache[dateKey] = list;

    return list;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void selectShiChen(int index) {
    try {
      if (index < 0 || index >= shiChenList.length) {
        _showErrorToast('時辰索引超出範圍');
        return;
      }

      selectedShiChenIndex.value = index;

      HapticFeedback.lightImpact();

      final shichen = shiChenList[index];
      _updateColors(shichen.wuXing);
    } catch (e) {
      _showErrorToast('揀時辰失敗：${e.toString()}');
    }
  }

  void _updateColors(String wuXing) {
    try {
      suitableColors.value = ColorCalculator.getSuitableColors(wuXing);
      avoidColors.value = ColorCalculator.getAvoidColors(wuXing);
    } catch (e) {
      _showErrorToast('顏色計算失敗：${e.toString()}');
      suitableColors.value = [];
      avoidColors.value = [];
    }
  }

  Future<void> selectDate(BuildContext context) async {
    try {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        locale: const Locale('zh', 'CN'),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: const Color(0xFFC17A4A),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != currentDate.value) {
        currentDate.value = picked;

        shiChenList.value = _calculateShiChenList(picked);

        int newIndex = 0;
        if (_isSameDay(picked, DateTime.now())) {
          newIndex = TianGanDiZhiCalculator.getShiChenIndex(DateTime.now());
        }

        selectShiChen(newIndex);

        _showSuccessToast('已切換到 ${getFormattedFullDate()}');
      }
    } catch (e) {
      _showErrorToast('揀日期失敗：${e.toString()}');
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getCurrentDay() {
    return currentDate.value.day.toString();
  }

  String getFormattedFullDate() {
    final date = currentDate.value;
    final weekday = FengshuiConstants.weekdayMap[date.weekday] ?? '';
    return '${date.year}年${date.month}月${date.day}日 $weekday';
  }

  String getSelectedShiChenInfo() {
    if (shiChenList.isEmpty ||
        selectedShiChenIndex.value >= shiChenList.length) {
      return '';
    }

    final shichen = shiChenList[selectedShiChenIndex.value];
    return '${shichen.tianGan}${shichen.diZhi}时 · ${shichen.wuXing}行 · ${shichen.jiXiong}';
  }

  void onColorLongPress(Color color, String colorType) {
    try {
      String colorName = ColorCalculator.getColorName(color);
      String hexValue = ColorCalculator.colorToHex(color);

      Get.dialog(
        AlertDialog(
          title: Text('顏色詳情'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('顏色名稱：$colorName'),
                        SizedBox(height: 4),
                        Text('色值：$hexValue'),
                        SizedBox(height: 4),
                        Text('類型：$colorType'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Get.back(), child: Text('關閉'))],
        ),
      );

      HapticFeedback.mediumImpact();
    } catch (e) {
      _showErrorToast('獲取顏色信息失敗');
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void onClose() {
    _shiChenCache.clear();
    super.onClose();
  }
}
