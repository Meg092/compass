import 'package:get/get.dart';

class LuopanToolboxLogic extends GetxController {
  void onVrCompassTap() {
    Get.toNamed('/luopan_vr_compass');
  }

  void onLulongRulerTap() {
    Get.toNamed('/luopan_lulong_ruler');
  }

  void onDecibelMeterTap() {
    Get.toNamed('/luopan_decibel_meter');
  }

  void onLevelTap() {
    Get.toNamed('/luopan_level');
  }

  void onClothingGuideTap() {
    Get.toNamed('/luopan_clothing_guide');
  }
}
