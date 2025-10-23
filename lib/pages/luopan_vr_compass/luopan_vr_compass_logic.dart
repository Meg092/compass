import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:luopan/utils/index.dart';
import 'package:luopan/services/index.dart';
import 'package:luopan/utils/data.dart';

class LuopanVrCompassLogic extends GetxController {
  final compassAngle = 0.0.obs;

  final xiangAngle = 0.0.obs;

  final zuoAngle = 0.0.obs;

  final xiangDirection = ''.obs;

  final zuoDirection = ''.obs;

  final houseType = ''.obs;

  final xiangDescription = ''.obs;

  final zuoDescription = ''.obs;

  final readingItems = <Map<String, String>>[].obs;

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

        _calculateReadingData();
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

  void _calculateReadingData() {
    final xiangMountain = _getMountainFromAngle(xiangAngle.value);
    final xiangXiantianBaguaData = _getXiantianBaguaFromAngle(xiangAngle.value);
    final xiangDragon = _getDragonFromAngle(xiangAngle.value);
    final xiangGold = _getGoldFromAngle(xiangAngle.value);
    final xiangRenpan = _getRenpan24FromAngle(xiangAngle.value);

    final zuoMountain = _getMountainFromAngle(zuoAngle.value);
    final zuoXiantianBaguaData = _getXiantianBaguaFromAngle(zuoAngle.value);
    final zuoDragon = _getDragonFromAngle(zuoAngle.value);
    final zuoGold = _getGoldFromAngle(zuoAngle.value);
    final zuoRenpan = _getRenpan24FromAngle(zuoAngle.value);

    final xiangXiantianBagua = xiangXiantianBaguaData?.bagua ?? '未知';
    final zuoXiantianBagua = zuoXiantianBaguaData?.bagua ?? '未知';

    final xiangBagua = xiangMountain?.bagua ?? '未知';
    final zuoBagua = zuoMountain?.bagua ?? '未知';

    final xiangLuoshu = xiangXiantianBaguaData?.luoshuNumber ?? '未知';
    final zuoLuoshu = zuoXiantianBaguaData?.luoshuNumber ?? '未知';

    final xiang24Mountain = xiangMountain?.mountain ?? '未知';
    final zuo24Mountain = zuoMountain?.mountain ?? '未知';

    final xiang72Dragon = xiangDragon?.dragon ?? '未知';
    final zuo72Dragon = zuoDragon?.dragon ?? '未知';

    final xiang120Gold = xiangGold?.gold ?? '未知';
    final zuo120Gold = zuoGold?.gold ?? '未知';

    final xiangRenpan24 = xiangRenpan?.mountain ?? '未知';
    final zuoRenpan24 = zuoRenpan?.mountain ?? '未知';

    readingItems.value = [
      {
        'title': '先天八卦_卦位',
        'xiang': xiangXiantianBagua,
        'zuo': zuoXiantianBagua,
      },
      {'title': '後天八卦_卦位', 'xiang': xiangBagua, 'zuo': zuoBagua},
      {'title': '先天八卦洛書數', 'xiang': xiangLuoshu, 'zuo': zuoLuoshu},
      {'title': '地盤正針二十四山', 'xiang': xiang24Mountain, 'zuo': zuo24Mountain},
      {'title': '穿山七十二龍', 'xiang': xiang72Dragon, 'zuo': zuo72Dragon},
      {'title': '地盤正針百二十分金', 'xiang': xiang120Gold, 'zuo': zuo120Gold},
      {'title': '人盤中針二十四山', 'xiang': xiangRenpan24, 'zuo': zuoRenpan24},
    ];
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

  XiantianBaguaData? _getXiantianBaguaFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final bagua in xiantianBaguaDatas) {
      if (bagua.startAngle > bagua.endAngle) {
        if (angle >= bagua.startAngle || angle <= bagua.endAngle) {
          return bagua;
        }
      } else {
        if (angle >= bagua.startAngle && angle <= bagua.endAngle) {
          return bagua;
        }
      }
    }
    return null;
  }

  DragonData? _getDragonFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final dragon in dragonDatas) {
      if (angle >= dragon.startAngle && angle <= dragon.endAngle) {
        return dragon;
      }
    }
    return null;
  }

  GoldData? _getGoldFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final gold in goldDatas) {
      if (angle >= gold.startAngle && angle <= gold.endAngle) {
        return gold;
      }
    }
    return null;
  }

  Renpan24Data? _getRenpan24FromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final renpan in renpan24Datas) {
      if (renpan.startAngle > renpan.endAngle) {
        if (angle >= renpan.startAngle || angle <= renpan.endAngle) {
          return renpan;
        }
      } else {
        if (angle >= renpan.startAngle && angle <= renpan.endAngle) {
          return renpan;
        }
      }
    }
    return null;
  }
}
