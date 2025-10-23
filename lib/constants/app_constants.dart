import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = '羅盤指南';
  static const String appVersion = '2.0.0';
  static const String packageName = 'com.example.luopan_guide';

  static const bool isDebugMode = kDebugMode;
  static const bool useMockCompass = false;

  static const int mockCompassUpdateInterval = 100;
  static const double mockRotationSpeed = 30.0;
  static const double mockNoiseAmplitude = 0.5;
  static const double mockSmoothingFactor = 0.1;

  static const int compassStyleCount = 4;
}
