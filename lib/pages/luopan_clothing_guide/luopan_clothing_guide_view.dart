import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'package:luopan/theme/app_spacing.dart';
import 'package:luopan/theme/app_radius.dart';
import 'luopan_clothing_guide_logic.dart';

class LuopanClothingGuideView extends GetView<LuopanClothingGuideLogic> {
  const LuopanClothingGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanClothingGuideLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _buildDateCard(),
            SizedBox(height: AppSpacing.md),
            _buildTimeSlotCard(),
            SizedBox(height: AppSpacing.md),
            _buildColorsCard(),
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
      title: Text('着衫指南', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: () => controller.selectDate(Get.context!),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.getCurrentDay(),
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      '日',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  controller.getFormattedFullDate(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.shiChenList.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: Text('載入緊...'),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - (5 * 12.w)) / 6;

            return Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: List.generate(controller.shiChenList.length, (index) {
                  final shichen = controller.shiChenList[index];
                  final isSelected =
                      controller.selectedShiChenIndex.value == index;

                  return GestureDetector(
                    onTap: () => controller.selectShiChen(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: itemWidth,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFFC0895E)
                                : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shichen.tianGan,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF333333),
                              height: 1.2,
                            ),
                          ),
                          Text(
                            shichen.diZhi,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF333333),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            shichen.jiXiong,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF666666),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildColorsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
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
          _buildColorSection('適合顏色', controller.suitableColors),
          SizedBox(height: AppSpacing.lg),
          _buildColorSection('忌諱顏色', controller.avoidColors),
        ],
      ),
    );
  }

  Widget _buildColorSection(String title, RxList<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (colors.isEmpty) {
            return Text(
              '暫無數據',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            );
          }

          return Wrap(
            spacing: 20.w,
            runSpacing: 16.h,
            children:
                colors.map((color) {
                  return GestureDetector(
                    onLongPress:
                        () => controller.onColorLongPress(color, title),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          );
        }),
      ],
    );
  }
}
