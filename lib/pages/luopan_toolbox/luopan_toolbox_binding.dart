import 'package:get/get.dart';
import 'luopan_toolbox_logic.dart';

class LuopanToolboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanToolboxLogic());
  }
}
