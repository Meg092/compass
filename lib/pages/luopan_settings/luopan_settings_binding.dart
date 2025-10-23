import 'package:get/get.dart';
import 'luopan_settings_logic.dart';

class LuopanSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanSettingsLogic());
  }
}
