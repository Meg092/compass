import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'package:luopan/theme/app_spacing.dart';
import 'luopan_vr_compass_logic.dart';

class LuopanVrCompassView extends GetView<LuopanVrCompassLogic> {
  const LuopanVrCompassView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanVrCompassLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCompassPreview(),
            SizedBox(height: 8.h),
            _buildReadingCard(),
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.w),
        onPressed: () => Get.back(),
      ),
      title: Text('VR羅盤', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildCompassPreview() {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      height: 380.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: double.infinity, color: AppColors.background),
          Image.asset(
            'assets/compass_main_background.png',
            width: double.infinity,
            height: 380.h,
            fit: BoxFit.cover,
          ),
          Obx(
            () => Transform.rotate(
              angle: controller.compassAngle.value * 3.14159 / 180,
              child: Image.asset(
                'assets/icon_pointer.png',
                width: 70.w,
                height: 140.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReadingTitle(),
          SizedBox(height: AppSpacing.md),
          _buildDirectionRow(),
          SizedBox(height: 12.h),
          _buildDirectionRow2(),
          SizedBox(height: 12.h),
          _buildReadingItems(),
        ],
      ),
    );
  }

  Widget _buildReadingTitle() {
    return Center(
      child: Text(
        '解讀羅盤',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildDirectionRow() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '向${controller.xiangDirection.value} ${controller.xiangAngle.value.toStringAsFixed(2)}°',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            controller.houseType.value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionRow2() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '坐${controller.zuoDirection.value} ${controller.zuoAngle.value.toStringAsFixed(2)}°',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '坐${controller.zuoDescription.value}向${controller.xiangDescription.value}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingItems() {
    return Obx(
      () => Column(
        children:
            controller.readingItems.asMap().entries.map((entry) {
              final item = entry.value;

              return Column(
                children: [_buildReadingItem(item), SizedBox(height: 12.h)],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildReadingItem(Map<String, String> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            item['title']!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '向：',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              Text(
                item['xiang']!,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textAccent),
              ),
              SizedBox(width: 16.w),
              Text(
                '坐：',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              Text(
                item['zuo']!,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
