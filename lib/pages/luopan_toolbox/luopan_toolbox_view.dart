import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'luopan_toolbox_logic.dart';

class LuopanToolboxView extends GetView<LuopanToolboxLogic> {
  const LuopanToolboxView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanToolboxLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          physics: const BouncingScrollPhysics(),
          children: [
            // _buildToolCard(
            //   'VR羅盤',
            //   'assets/icon_luopan.png',
            //   controller.onVrCompassTap,
            // ),
            _buildToolCard(
              '馴龍尺',
              'assets/icon_ruler.png',
              controller.onLulongRulerTap,
            ),
            _buildToolCard(
              '分貝儀',
              'assets/icon_meter.png',
              controller.onDecibelMeterTap,
            ),
            _buildToolCard(
              '水平儀',
              'assets/icon_spirit.png',
              controller.onLevelTap,
            ),
            _buildToolCard(
              '着衫指南',
              'assets/icon_ring.png',
              controller.onClothingGuideTap,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text('工具箱', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildToolCard(String title, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              iconPath,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
