import 'package:get/get.dart';
import 'luopan_vr_compass_logic.dart';

class LuopanVrCompassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanVrCompassLogic());
  }
}
