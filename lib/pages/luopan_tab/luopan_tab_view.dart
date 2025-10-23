import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/pages/luopan_home/luopan_home_view.dart';
import 'package:luopan/pages/luopan_toolbox/luopan_toolbox_view.dart';
import 'package:luopan/pages/luopan_settings/luopan_settings_view.dart';
import 'package:luopan/theme/app_colors.dart';
import 'luopan_tab_logic.dart';

class LuopanTabView extends GetView<LuopanTabLogic> {
  const LuopanTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            LuopanHomeView(),
            LuopanToolboxView(),
            LuopanSettingsView(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.onTabChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.tabSelected,
        unselectedItemColor: AppColors.tabNormal,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/tab/tab_home_normal.png',
              width: 24.w,
              height: 24.w,
            ),
            activeIcon: Image.asset(
              'assets/tab/tab_home_selected.png',
              width: 24.w,
              height: 24.w,
            ),
            label: '主頁',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/tab/tab_compass_normal.png',
              width: 24.w,
              height: 24.w,
            ),
            activeIcon: Image.asset(
              'assets/tab/tab_compass_selected.png',
              width: 24.w,
              height: 24.w,
            ),
            label: '工具箱',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/tab/tab_settings_normal.png',
              width: 24.w,
              height: 24.w,
            ),
            activeIcon: Image.asset(
              'assets/tab/tab_settings_selected.png',
              width: 24.w,
              height: 24.w,
            ),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
