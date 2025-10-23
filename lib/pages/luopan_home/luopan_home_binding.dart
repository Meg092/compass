import 'package:get/get.dart';
import 'luopan_home_logic.dart';

class LuopanHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanHomeLogic());
  }
}
