import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LuopanLevelLogic extends GetxController {
  final horizontalAngle = 0.0.obs;

  final verticalAngle = 0.0.obs;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  final isSensorSupported = true.obs;

  static const double _alpha = 0.8;
  double _lastRoll = 0.0;
  double _lastPitch = 0.0;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _stopListening();
    super.onClose();
  }

  void _startListening() {
    try {
      _accelerometerSubscription = accelerometerEvents.listen(
        _onAccelerometerEvent,
        onError: (error) {
          _handleSensorError(error);
        },
        cancelOnError: false,
      );
    } catch (e) {
      _handleSensorError(e);
    }
  }

  void _stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    try {
      double roll = atan2(event.x, event.z) * 180 / pi;
      double pitch = atan2(event.y, event.z) * 180 / pi;

      roll = _applyLowPassFilter(roll, _lastRoll);
      pitch = _applyLowPassFilter(pitch, _lastPitch);

      _lastRoll = roll;
      _lastPitch = pitch;

      roll = roll.clamp(-180.0, 180.0);
      pitch = pitch.clamp(-90.0, 90.0);

      horizontalAngle.value = double.parse(roll.toStringAsFixed(1));
      verticalAngle.value = double.parse(pitch.toStringAsFixed(1));
    } catch (e) {
      print('处理传感器数据时出错: $e');
    }
  }

  double _applyLowPassFilter(double current, double previous) {
    return _alpha * previous + (1 - _alpha) * current;
  }

  void _handleSensorError(dynamic error) {
    isSensorSupported.value = false;

    Fluttertoast.showToast(
      msg: '傳感器唔可用，請檢查裝置係咪支援加速度計',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );

    print('传感器错误: $error');

    _stopListening();
  }

  void resetAngles() {
    try {
      _lastRoll = 0.0;
      _lastPitch = 0.0;
      horizontalAngle.value = 0.0;
      verticalAngle.value = 0.0;

      Fluttertoast.showToast(msg: '已重置', toastLength: Toast.LENGTH_SHORT);
    } catch (e) {
      Fluttertoast.showToast(msg: '重置失敗', toastLength: Toast.LENGTH_SHORT);
    }
  }

  void restartSensor() {
    try {
      _stopListening();
      Future.delayed(const Duration(milliseconds: 500), () {
        _startListening();
        isSensorSupported.value = true;

        Fluttertoast.showToast(msg: '傳感器已重啟', toastLength: Toast.LENGTH_SHORT);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '重啟失敗: $e', toastLength: Toast.LENGTH_SHORT);
    }
  }
}
