import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:luopan/utils/index.dart';

class LuopanDecibelMeterLogic extends GetxController {
  final decibelValue = 0.0.obs;

  final waveAnimation = 0.0.obs;

  final hasPermission = false.obs;

  final isDetecting = false.obs;

  final errorMessage = ''.obs;

  Timer? _animationTimer;
  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
    _initMicrophone();
  }

  @override
  void onClose() {
    _animationTimer?.cancel();
    _noiseSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initMicrophone() async {
    try {
      final status = await _requestPermission();
      if (status) {
        hasPermission.value = true;
        errorMessage.value = '';
        await _startNoiseDetection();
      } else {
        hasPermission.value = false;
        errorMessage.value = '需要咪高峰權限先可以使用分貝儀';
      }
    } catch (e) {
      errorMessage.value = '初始化失敗：${e.toString()}';
      hasPermission.value = false;
    }
  }

  Future<bool> _requestPermission() async {
    try {
      var status = await Permission.microphone.status;

      if (status.isGranted) {
        return true;
      }

      status = await Permission.microphone.request();

      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        errorMessage.value = '咪高峰權限被永久拒絕，請到設定入面手動開啟';
        return false;
      } else {
        errorMessage.value = '咪高峰權限被拒絕';
        return false;
      }
    } catch (e) {
      errorMessage.value = '權限請求失敗：${e.toString()}';
      return false;
    }
  }

  Future<void> _startNoiseDetection() async {
    try {
      _noiseMeter = NoiseMeter();
      isDetecting.value = true;
      errorMessage.value = '';

      _noiseSubscription = _noiseMeter!.noise.listen(
        (NoiseReading noiseReading) {
          try {
            double db = noiseReading.meanDecibel;

            db = db.clamp(0.0, 120.0);

            decibelValue.value = db;
          } catch (e) {}
        },
        onError: (Object error) {
          errorMessage.value = '檢測出錯：${error.toString()}';
          isDetecting.value = false;
          _stopNoiseDetection();
        },
        cancelOnError: true,
      );
    } catch (e) {
      errorMessage.value = '啟動檢測失敗：${e.toString()}';
      isDetecting.value = false;
    }
  }

  void _stopNoiseDetection() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
    isDetecting.value = false;
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      waveAnimation.value = _random.nextDouble();
    });
  }

  Future<void> retry() async {
    errorMessage.value = '';
    await _initMicrophone();
  }

  Future<void> openAppSettings() async {
    try {
      await openAppSettings();
      errorToast('請在設定中開啟咪高峰權限');
    } catch (e) {
      errorToast('無法打開設定');
    }
  }
}
