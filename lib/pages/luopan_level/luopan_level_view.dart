import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'luopan_level_logic.dart';

class LuopanLevelView extends GetView<LuopanLevelLogic> {
  const LuopanLevelView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanLevelLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelIndicator(),
            SizedBox(height: 80.h),
            _buildAngleInfo(),
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
      title: Text('水平儀', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildLevelIndicator() {
    return Obx(() {
      final horizontalAngle = controller.horizontalAngle.value;
      final verticalAngle = controller.verticalAngle.value;

      return SizedBox(
        width: 280.w,
        height: 280.w,
        child: CustomPaint(
          painter: LevelIndicatorPainter(
            horizontalAngle: horizontalAngle,
            verticalAngle: verticalAngle,
          ),
        ),
      );
    });
  }

  Widget _buildAngleInfo() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAngleItem(
              label: '水平',
              value: controller.horizontalAngle.value.toStringAsFixed(1),
            ),
            _buildAngleItem(
              label: '垂直',
              value: controller.verticalAngle.value.toStringAsFixed(0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAngleItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '$value°',
          style: TextStyle(
            fontSize: 52.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.0,
            letterSpacing: -2.w,
          ),
        ),
      ],
    );
  }
}

class LevelIndicatorPainter extends CustomPainter {
  final double horizontalAngle;
  final double verticalAngle;

  LevelIndicatorPainter({
    required this.horizontalAngle,
    required this.verticalAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerCirclePaint =
        Paint()
          ..color = const Color(0xFF9B6F1B)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerCirclePaint);

    final innerCirclePaint =
        Paint()
          ..color = const Color(0xFFD2A679)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.72, innerCirclePaint);

    final maxOffset = radius * 0.55;
    final offsetX = (horizontalAngle / 90).clamp(-1.0, 1.0) * maxOffset;
    final offsetY = (verticalAngle / 90).clamp(-1.0, 1.0) * maxOffset;
    final ballPosition = Offset(center.dx + offsetX, center.dy + offsetY);

    final ballPaint =
        Paint()
          ..color = const Color(0xFFFF0000)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(ballPosition, radius * 0.16, ballPaint);
  }

  @override
  bool shouldRepaint(LevelIndicatorPainter oldDelegate) {
    return oldDelegate.horizontalAngle != horizontalAngle ||
        oldDelegate.verticalAngle != verticalAngle;
  }
}
