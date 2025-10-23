import 'compass_data_service.dart';
import 'real_compass_service.dart';
import 'mock_compass_service.dart';

class CompassServiceFactory {
  static CompassDataService? _instance;

  static CompassDataService getInstance() {
    if (_instance != null) return _instance!;

    _instance = RealCompassService();

    return _instance!;
  }

  static Future<CompassDataService> switchToReal() async {
    await _instance?.dispose();
    _instance = RealCompassService();
    await _instance!.initialize();
    return _instance!;
  }

  static Future<CompassDataService> switchToMock() async {
    await _instance?.dispose();
    _instance = MockCompassService();
    await _instance!.initialize();
    return _instance!;
  }

  static String getCurrentServiceType() {
    return _instance?.serviceType ?? 'Unknown';
  }

  static bool isUsingMockService() {
    return _instance is MockCompassService;
  }

  static bool isUsingRealService() {
    return _instance is RealCompassService;
  }

  static Future<void> dispose() async {
    await _instance?.dispose();
    _instance = null;
  }

  static void reset() {
    _instance = null;
  }
}
