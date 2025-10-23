import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/theme/app_colors.dart';
import 'package:luopan/theme/app_text_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'luopan_decibel_meter_logic.dart';

class LuopanDecibelMeterView extends GetView<LuopanDecibelMeterLogic> {
  const LuopanDecibelMeterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LuopanDecibelMeterLogic());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSoundWaveIcon(),
              SizedBox(height: 60.h),
              _buildDecibelInfo(),
              SizedBox(height: 20.h),
              _buildStatusIndicator(),
            ],
          ),
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
      title: Text('分貝儀', style: AppTextStyles.navTitle),
    );
  }

  Widget _buildSoundWaveIcon() {
    return Obx(() {
      final db = controller.decibelValue.value;
      final animation = controller.waveAnimation.value;
      return SizedBox(
        width: 200.w,
        height: 140.h,
        child: CustomPaint(
          painter: SoundWavePainter(
            amplitude: db / 100,
            animationValue: animation,
          ),
        ),
      );
    });
  }

  Widget _buildDecibelInfo() {
    return Obx(
      () => Column(
        children: [
          Text(
            '當前分貝',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${controller.decibelValue.value.toStringAsFixed(0)}db',
            style: TextStyle(
              fontSize: 72.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Obx(() {
      if (!controller.hasPermission.value) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              controller.isDetecting.value
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color:
                    controller.isDetecting.value ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              controller.isDetecting.value ? '檢測緊' : '已停止',
              style: TextStyle(
                fontSize: 14.sp,
                color:
                    controller.isDetecting.value ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_off, size: 80.w, color: Colors.grey),
            SizedBox(height: 24.h),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 32.h),
            if (controller.errorMessage.value.contains('永久拒绝'))
              _buildButton(
                text: '打開設定',
                onPressed: () async {
                  await openAppSettings();
                },
              )
            else
              _buildButton(text: '重試', onPressed: controller.retry),
            SizedBox(height: 16.h),
            _buildPermissionTip(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPermissionTip() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20.w, color: Colors.blue),
              SizedBox(width: 8.w),
              Text(
                '點解需要咪高峰權限？',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '分貝儀需要使用咪高峰嚟檢測環境噪音水平。你嘅私隱同數據安全由系統保護，我哋唔會錄製或者保存任何音頻。',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SoundWavePainter extends CustomPainter {
  final double amplitude;
  final double animationValue;

  SoundWavePainter({required this.amplitude, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = 12.0;
    final spacing = 8.0;
    final barCount = 7;
    final totalWidth = barCount * barWidth + (barCount - 1) * spacing;
    final startX = (size.width - totalWidth) / 2;

    final baseHeights = [0.3, 0.5, 0.7, 0.9, 0.7, 0.5, 0.3];

    final animationOffsets = [
      0.9 + animationValue * 0.2,
      0.85 + animationValue * 0.3,
      0.95 + animationValue * 0.1,
      1.0 + animationValue * 0.0,
      0.95 + animationValue * 0.1,
      0.85 + animationValue * 0.3,
      0.9 + animationValue * 0.2,
    ];

    for (int i = 0; i < barCount; i++) {
      final x = startX + i * (barWidth + spacing);

      final height = baseHeights[i] * animationOffsets[i];
      final barHeight = size.height * height * amplitude.clamp(0.2, 1.0);

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(6),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(SoundWavePainter oldDelegate) {
    return oldDelegate.amplitude != amplitude ||
        oldDelegate.animationValue != animationValue;
  }
}
