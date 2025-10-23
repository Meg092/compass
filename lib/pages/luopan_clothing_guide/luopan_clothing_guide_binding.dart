import 'package:get/get.dart';
import 'luopan_clothing_guide_logic.dart';

class LuopanClothingGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuopanClothingGuideLogic());
  }
}
