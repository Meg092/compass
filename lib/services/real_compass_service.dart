import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'compass_data_service.dart';

class RealCompassService implements CompassDataService {
  static RealCompassService? _instance;

  RealCompassService._internal();

  factory RealCompassService() {
    return _instance ??= RealCompassService._internal();
  }

  @override
  Stream<CompassEvent>? get events => FlutterCompass.events;

  @override
  Future<bool> get isAvailable async {
    try {
      final stream = FlutterCompass.events;
      if (stream == null) return false;

      final isEmpty = await stream.isEmpty;
      return !isEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> dispose() async {}

  @override
  String get serviceType => 'RealCompass';
}
