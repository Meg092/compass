import 'package:get/get.dart';
import 'luopan_compass_reading_logic.dart';

class LuopanCompassReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanCompassReadingLogic());
  }
}
