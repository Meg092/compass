import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:luopan/utils/index.dart';
import 'package:luopan/services/index.dart';
import 'package:luopan/utils/data.dart';

class LuopanHomeLogic extends GetxController {
  final compassAngle = 0.0.obs;

  final xiangAngle = 0.0.obs;

  final zuoAngle = 0.0.obs;

  final xiangDirection = ''.obs;

  final zuoDirection = ''.obs;

  final houseType = ''.obs;

  final xiangDescription = ''.obs;

  final zuoDescription = ''.obs;

  final selectedCompassStyle = 0.obs;

  StreamSubscription<CompassEvent>? _compassSubscription;

  late CompassDataService _compassService;

  double _lastFilteredAngle = 0.0;

  static const double _filterAlpha = 0.15;

  @override
  void onInit() {
    super.onInit();
    _initCompass();
  }

  @override
  void onClose() {
    _compassSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initCompass() async {
    try {
      _compassService = CompassServiceFactory.getInstance();

      final hasPermission = await _requestPermission();
      if (!hasPermission && CompassServiceFactory.isUsingRealService()) {
        errorToast('需要位置權限先可以使用羅盤功能');
        return;
      }

      await _compassService.initialize();

      final isAvailable = await _compassService.isAvailable;
      if (!isAvailable) {
        errorToast('你嘅裝置唔支援羅盤功能');
        return;
      }

      if (CompassServiceFactory.isUsingRealService()) {
        showCalibrationDialog(Get.context!);
      }

      _startCompassListener();
    } catch (e) {
      errorToast('羅盤初始化失敗：${e.toString()}');
    }
  }

  Future<bool> _requestPermission() async {
    try {
      final status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  void _startCompassListener() {
    _compassSubscription = _compassService.events?.listen((CompassEvent event) {
      try {
        final heading = event.heading;
        if (heading == null) return;

        final filteredAngle = _applyLowPassFilter(heading);

        compassAngle.value = filteredAngle;

        xiangAngle.value = filteredAngle;
        zuoAngle.value = (filteredAngle + 180) % 360;

        xiangDirection.value = _getDirectionName(xiangAngle.value);
        zuoDirection.value = _getDirectionName(zuoAngle.value);

        final xiangMountain = _getMountainFromAngle(xiangAngle.value);
        final zuoMountain = _getMountainFromAngle(zuoAngle.value);

        xiangDescription.value = xiangMountain!.mountain;
        zuoDescription.value = zuoMountain!.mountain;
        houseType.value = xiangMountain.houseType;
      } catch (e) {}
    });
  }

  void showCalibrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('傳感器校準'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('指南針傳感器需要校準。請按照以下步驟操作：'),
                SizedBox(height: 10),
                Text('1. 將裝置水平放置喺手掌上'),
                Text('2. 緩慢轉動裝置 360°（好似畫圓咁）'),
                Text('3. 重複 2-3 次直到校準完成'),
                Text('4. 或者喺系統設定入面搵到「傳感器校準」選項'),
                SizedBox(height: 10),
                Text('校準完成後，方向數據會更準確'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('確定'),
              ),
            ],
          ),
    );
  }

  double _applyLowPassFilter(double newValue) {
    double delta = newValue - _lastFilteredAngle;
    if (delta > 180) {
      delta -= 360;
    } else if (delta < -180) {
      delta += 360;
    }

    _lastFilteredAngle = _lastFilteredAngle + _filterAlpha * delta;

    if (_lastFilteredAngle < 0) {
      _lastFilteredAngle += 360;
    } else if (_lastFilteredAngle >= 360) {
      _lastFilteredAngle -= 360;
    }

    return _lastFilteredAngle;
  }

  String _getDirectionName(double angle) {
    const directions = ['北', '東北', '東', '東南', '南', '西南', '西', '西北'];
    final index = ((angle + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  MountainData? _getMountainFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final mountain in mountainDatas) {
      if (mountain.startAngle > mountain.endAngle) {
        if (angle >= mountain.startAngle || angle <= mountain.endAngle) {
          return mountain;
        }
      } else {
        if (angle >= mountain.startAngle && angle <= mountain.endAngle) {
          return mountain;
        }
      }
    }
    return null;
  }

  void onCompassStyleChanged(int index) {
    selectedCompassStyle.value = index;
  }

  void onReadingTap() {
    Get.toNamed(
      '/luopan_compass_reading',
      arguments: {
        'xiangAngle': xiangAngle.value,
        'zuoAngle': zuoAngle.value,
        'xiangDirection': xiangDirection.value,
        'zuoDirection': zuoDirection.value,
        'houseType': houseType.value,
        'xiangDescription': xiangDescription.value,
        'zuoDescription': zuoDescription.value,
        'compassAngle': compassAngle.value,
      },
    );
  }
}
