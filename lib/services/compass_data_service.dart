import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';

abstract class CompassDataService {
  Stream<CompassEvent>? get events;

  Future<bool> get isAvailable;

  Future<void> initialize();

  Future<void> dispose();

  String get serviceType;
}
