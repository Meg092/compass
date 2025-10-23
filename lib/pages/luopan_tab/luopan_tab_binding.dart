import 'package:get/get.dart';
import 'luopan_tab_logic.dart';

class LuopanTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanTabLogic());
  }
}
