import 'package:get/get.dart';
import 'luopan_decibel_meter_logic.dart';

class LuopanDecibelMeterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanDecibelMeterLogic());
  }
}
