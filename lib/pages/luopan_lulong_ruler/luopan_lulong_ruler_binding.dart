import 'package:get/get.dart';
import 'luopan_lulong_ruler_logic.dart';

class LuopanLulongRulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanLulongRulerLogic());
  }
}
