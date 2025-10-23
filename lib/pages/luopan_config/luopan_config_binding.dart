import 'package:get/get.dart';

import 'luopan_config_logic.dart';

class LuopanConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LuopanConfigLogic(),
      permanent: true,
    );
  }
}
