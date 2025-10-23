import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:luopan/services/index.dart';
import 'package:luopan/utils/index.dart';
import 'package:permission_handler/permission_handler.dart';

class LuopanLulongRulerLogic extends GetxController {
  final angle = 0.0.obs;

  final direction = ''.obs;

  final isSensorAvailable = true.obs;

  StreamSubscription<CompassEvent>? _compassSubscription;

  late CompassDataService _compassService;

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

      final hasCompass = await _requestPermission();
      if (!hasCompass && CompassServiceFactory.isUsingRealService()) {
        errorToast('需要位置權限先可以使用羅盤功能');
        return;
      }

      _startListening();
    } catch (e) {
      isSensorAvailable.value = false;
      errorToast('傳感器初始化失敗: $e');
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

  void _startListening() {
    try {
      _compassSubscription = _compassService.events?.listen(
        (CompassEvent event) {
          if (event.heading != null) {
            double heading = event.heading!;
            if (heading < 0) heading += 360;
            angle.value = double.parse(heading.toStringAsFixed(2));

            direction.value = _calculateDirection(heading);
          }
        },
        onError: (error) {
          isSensorAvailable.value = false;
          errorToast('傳感器讀取失敗: $error');
        },
      );
    } catch (e) {
      isSensorAvailable.value = false;
      errorToast('傳感器監聽失敗: $e');
    }
  }

  String _calculateDirection(double heading) {
    const directions = [
      '向北',
      '向北偏东北',
      '向东北',
      '向东偏东北',
      '向东',
      '向东偏东南',
      '向东南',
      '向南偏东南',
      '向南',
      '向南偏西南',
      '向西南',
      '向西偏西南',
      '向西',
      '向西偏西北',
      '向西北',
      '向北偏西北',
    ];

    int index = ((heading + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  Future<void> retry() async {
    isSensorAvailable.value = true;
    await _initCompass();
  }
}
