import 'dart:async';
import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import '../constants/app_constants.dart';
import 'compass_data_service.dart';

class MockCompassService implements CompassDataService {
  static MockCompassService? _instance;

  MockCompassService._internal();

  factory MockCompassService() {
    return _instance ??= MockCompassService._internal();
  }

  Timer? _timer;
  StreamController<CompassEvent>? _streamController;

  double _currentAngle = 0.0;
  double _targetAngle = 0.0;
  double _velocity = 0.0;
  final Random _random = Random();
  late DateTime _lastUpdate;

  @override
  Stream<CompassEvent>? get events => _streamController?.stream;

  @override
  Future<bool> get isAvailable async => true; // 模拟传感器始终可用

  @override
  Future<void> initialize() async {
    if (_streamController != null) return; // 已经初始化

    _streamController = StreamController<CompassEvent>.broadcast();
    _lastUpdate = DateTime.now();

    _currentAngle = _random.nextDouble() * 360;
    _targetAngle = _currentAngle;

    _startSimulation();
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    await _streamController?.close();
    _streamController = null;
  }

  @override
  String get serviceType => 'MockCompass';

  void _startSimulation() {
    _timer = Timer.periodic(
      Duration(milliseconds: AppConstants.mockCompassUpdateInterval),
      (timer) => _updateSimulation(),
    );
  }

  void _updateSimulation() {
    final now = DateTime.now();
    final deltaTime = now.difference(_lastUpdate).inMilliseconds / 1000.0;
    _lastUpdate = now;

    if (_random.nextDouble() < 0.02) {
      _targetAngle = _random.nextDouble() * 360;
    }

    double angleDiff = _targetAngle - _currentAngle;
    if (angleDiff > 180) {
      angleDiff -= 360;
    } else if (angleDiff < -180) {
      angleDiff += 360;
    }

    final maxChange = AppConstants.mockRotationSpeed * deltaTime;
    if (angleDiff.abs() > maxChange) {
      angleDiff = angleDiff.sign * maxChange;
    }

    _velocity =
        _velocity * (1 - AppConstants.mockSmoothingFactor) +
        angleDiff * AppConstants.mockSmoothingFactor;

    _currentAngle += _velocity;

    if (_currentAngle < 0) {
      _currentAngle += 360;
    } else if (_currentAngle >= 360) {
      _currentAngle -= 360;
    }

    final noisyAngle =
        _currentAngle +
        (_random.nextDouble() - 0.5) * AppConstants.mockNoiseAmplitude;

    final accuracy = _random.nextDouble() * 5 + 1; // 1-6度的精度
    final event = CompassEvent.fromList([noisyAngle, 0.0, accuracy]);

    _streamController?.add(event);
  }

  void setTargetAngle(double angle) {
    _targetAngle = angle % 360;
  }

  void simulateCalibration() {
    _targetAngle = (_currentAngle + 360) % 360;
  }
}
