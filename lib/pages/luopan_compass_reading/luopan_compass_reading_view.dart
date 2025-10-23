import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'luopan_compass_reading_logic.dart';

class LuopanCompassReadingView extends GetView<LuopanCompassReadingLogic> {
  const LuopanCompassReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanCompassReadingLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildCompassPreview(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 260.h,
              child: _buildReadingCard(),
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.w),
        onPressed: () => Get.back(),
      ),
      title: Text('解讀羅盤', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildCompassPreview() {
    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 16.h,
            child: Container(
              width: 500.w,
              height: 500.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150.r),
                child: Image.asset(
                  'assets/compass_main_background.png',
                  width: 300.w,
                  height: 300.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 176.h, // 16.h + (500.h - 90.h) / 2，使指针在罗盘中心
            child: Image.asset(
              'assets/icon_pointer.png',
              width: 70.w,
              height: 180.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadingTitle(),
            SizedBox(height: 22.h),
            _buildDirectionRow(),
            SizedBox(height: 18.h),
            _buildDirectionRow2(),
            SizedBox(height: 8.h),
            ..._buildReadingItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingTitle() {
    return Center(
      child: Text(
        '解讀羅盤',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
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
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            controller.houseType.value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textAccent,
              letterSpacing: 0.3,
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
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            '坐${controller.zuoDescription.value}向${controller.xiangDescription.value}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textAccent,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReadingItems() {
    return controller.readingItems.map((item) {
      return _buildReadingItem(item);
    }).toList();
  }

  Widget _buildReadingItem(Map<String, String> item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item['title']!.replaceAll('_', '·'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '向：',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Flexible(
                  child: Text(
                    item['xiang']!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textAccent,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '坐：',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Flexible(
                  child: Text(
                    item['zuo']!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
