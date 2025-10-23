import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'luopan_lulong_ruler_logic.dart';

class LuopanLulongRulerView extends GetView<LuopanLulongRulerLogic> {
  const LuopanLulongRulerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanLulongRulerLogic());

    return Scaffold(
      backgroundColor: const Color(0xFF3E5B7F),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (!controller.isSensorAvailable.value) {
          return _buildErrorView();
        }

        return Column(
          children: [
            const Spacer(),
            _buildCompass(),
            const Spacer(),
            _buildDirectionInfo(),
            SizedBox(height: 60.h),
          ],
        );
      }),
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
      title: Text('馴龍尺', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.w,
            color: Colors.white.withOpacity(0.6),
          ),
          SizedBox(height: 24.h),
          Text(
            '傳感器唔可用',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '請檢查裝置係咪支援羅盤功能\n或者授權位置權限',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () => controller.retry(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD2A679),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '重試',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Center(
      child: SizedBox(
        width: 300.w,
        height: 300.w,
        child: CustomPaint(painter: RulerCompassPainter()),
      ),
    );
  }

  Widget _buildDirectionInfo() {
    return Obx(
      () => Column(
        children: [
          Text(
            controller.direction.value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '${controller.angle.value.toStringAsFixed(2)}°',
            style: TextStyle(
              fontSize: 56.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class RulerCompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final scale = size.width / 300;
    final outerRadius = 150 * scale;
    final middleRadius = 100 * scale;
    final innerRadius = 50 * scale;

    final outerCirclePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(center, outerRadius, outerCirclePaint);

    final middleCirclePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(center, middleRadius, middleCirclePaint);

    final innerCirclePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(center, innerRadius, innerCirclePaint);

    canvas.save();

    canvas.translate(center.dx, center.dy);
    canvas.translate(-center.dx, -center.dy);

    final pointerPaint =
        Paint()
          ..color = const Color(0xFFD2A679)
          ..style = PaintingStyle.fill;

    final pointerWidth = 8 * scale;

    final verticalPointerLengthUp = 240 * scale;
    final verticalPointerLengthDown = 50 * scale;

    final verticalRectUp = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        center.dx - pointerWidth / 2,
        center.dy - verticalPointerLengthUp,
        center.dx + pointerWidth / 2,
        center.dy,
      ),
      Radius.circular(pointerWidth / 2),
    );
    canvas.drawRRect(verticalRectUp, pointerPaint);

    final verticalRectDown = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        center.dx - pointerWidth / 2,
        center.dy,
        center.dx + pointerWidth / 2,
        center.dy + verticalPointerLengthDown,
      ),
      Radius.circular(pointerWidth / 2),
    );
    canvas.drawRRect(verticalRectDown, pointerPaint);

    final horizontalPointerLength = 40 * scale;

    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        center.dx - horizontalPointerLength,
        center.dy - pointerWidth / 2,
        center.dx,
        center.dy + pointerWidth / 2,
      ),
      Radius.circular(pointerWidth / 2),
    );
    canvas.drawRRect(leftRect, pointerPaint);

    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        center.dx,
        center.dy - pointerWidth / 2,
        center.dx + horizontalPointerLength,
        center.dy + pointerWidth / 2,
      ),
      Radius.circular(pointerWidth / 2),
    );
    canvas.drawRRect(rightRect, pointerPaint);

    canvas.restore();

    final centerCirclePaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15 * scale, centerCirclePaint);
  }

  @override
  bool shouldRepaint(RulerCompassPainter oldDelegate) {
    return false;
  }
}
