import 'package:get/get.dart';
import 'luopan_level_logic.dart';

class LuopanLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanLevelLogic());
  }
}
