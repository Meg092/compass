import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'package:luopan/theme/app_spacing.dart';
import 'package:luopan/theme/app_radius.dart';
import 'luopan_settings_logic.dart';

class LuopanSettingsView extends GetView<LuopanSettingsLogic> {
  const LuopanSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanSettingsLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Container(
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
            mainAxisSize: MainAxisSize.min,
            children: [_buildVersionItem()],
          ),
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
      title: Text('設定', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildVersionItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 16.h),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '應用版本',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'V${controller.appVersion.value}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
