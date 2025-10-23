import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'luopan_config_logic.dart';

class LuopanConfigView extends GetView<LuopanConfigLogic> {
  const LuopanConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.kerluke.value
              ? CircularProgressIndicator(color: Colors.red[900])
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.cjzp();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
