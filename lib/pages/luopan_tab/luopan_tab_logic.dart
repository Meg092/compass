import 'package:get/get.dart';

class LuopanTabLogic extends GetxController {
  final currentIndex = 0.obs;

  void onTabChanged(int index) {
    currentIndex.value = index;
  }
}
