import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'package:luopan/theme/app_spacing.dart';
import 'luopan_home_logic.dart';

class LuopanHomeView extends GetView<LuopanHomeLogic> {
  const LuopanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanHomeLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              _buildDirectionInfo(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCompass(),
                    SizedBox(height: 40.h),
                    _buildCompassStyleSelector(),
                    SizedBox(height: 40.h),
                    _buildReadingButton(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      title: Text('主頁', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildDirectionInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
      decoration: const BoxDecoration(color: Color(0xFF984B13)),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '向${controller.xiangDirection.value} ${controller.xiangAngle.value.toStringAsFixed(2)}°',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '坐${controller.zuoDirection.value} ${controller.zuoAngle.value.toStringAsFixed(2)}°',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  controller.houseType.value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '坐${controller.zuoDescription.value}向${controller.xiangDescription.value}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return SizedBox(
      width: 320.w,
      height: 320.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Obx(() {
            final styleIndex = controller.selectedCompassStyle.value;
            String imagePath;

            switch (styleIndex) {
              case 0:
                imagePath = 'assets/compass_main_background.png';
                break;
              case 1:
                imagePath = 'assets/compass_secondary_background.png';
                break;
              case 2:
                imagePath = 'assets/compass_detail_view.png';
                break;
              case 3:
                imagePath = 'assets/compass_overlay.png';
                break;
              default:
                imagePath = 'assets/compass_main_background.png';
            }

            return Image.asset(
              imagePath,
              width: 320.w,
              height: 320.w,
              fit: BoxFit.contain,
            );
          }),
          Obx(
            () => Transform.rotate(
              angle: controller.compassAngle.value * 3.14159 / 180,
              child: Image.asset(
                'assets/icon_pointer.png',
                width: 60.w,
                height: 120.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassStyleSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final isSelected = controller.selectedCompassStyle.value == index;
          return GestureDetector(
            onTap: () => controller.onCompassStyleChanged(index),
            child: Container(
              width: 64.w,
              height: 64.w,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF8B4513) : Colors.transparent,
                  width: 3.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(child: _buildCompassStyleImage(index)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCompassStyleImage(int index) {
    String imagePath;
    switch (index) {
      case 0:
        imagePath = 'assets/compass_main_background.png';
        break;
      case 1:
        imagePath = 'assets/compass_secondary_background.png';
        break;
      case 2:
        imagePath = 'assets/compass_detail_view.png';
        break;
      case 3:
        imagePath = 'assets/compass_overlay.png';
        break;
      default:
        imagePath = 'assets/compass_main_background.png';
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(imagePath, width: 64.w, height: 64.w, fit: BoxFit.cover),
        Obx(() {
          final isSelected = controller.selectedCompassStyle.value == index;
          return isSelected
              ? Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B4513),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16.w),
              )
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildReadingButton() {
    return GestureDetector(
      onTap: controller.onReadingTap,
      child: Container(
        width: 280.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: const Color(0xFF8B1A1A),
          borderRadius: BorderRadius.circular(26.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '解讀羅盤',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
