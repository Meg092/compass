import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luopan/constants/app_redurce.dart';
import 'package:luopan/pages/luopan_clothing_guide/luopan_clothing_guide_binding.dart';
import 'package:luopan/pages/luopan_clothing_guide/luopan_clothing_guide_view.dart';
import 'package:luopan/pages/luopan_compass_reading/luopan_compass_reading_binding.dart';
import 'package:luopan/pages/luopan_compass_reading/luopan_compass_reading_view.dart';
import 'package:luopan/pages/luopan_config/luopan_config_binding.dart';
import 'package:luopan/pages/luopan_config/luopan_config_view.dart';
import 'package:luopan/pages/luopan_decibel_meter/luopan_decibel_meter_binding.dart';
import 'package:luopan/pages/luopan_decibel_meter/luopan_decibel_meter_view.dart';
import 'package:luopan/pages/luopan_home/luopan_home_binding.dart';
import 'package:luopan/pages/luopan_home/luopan_home_view.dart';
import 'package:luopan/pages/luopan_level/luopan_level_binding.dart';
import 'package:luopan/pages/luopan_level/luopan_level_view.dart';
import 'package:luopan/pages/luopan_lulong_ruler/luopan_lulong_ruler_binding.dart';
import 'package:luopan/pages/luopan_lulong_ruler/luopan_lulong_ruler_view.dart';
import 'package:luopan/pages/luopan_settings/luopan_settings_binding.dart';
import 'package:luopan/pages/luopan_settings/luopan_settings_view.dart';
import 'package:luopan/pages/luopan_tab/luopan_tab_binding.dart';
import 'package:luopan/pages/luopan_tab/luopan_tab_view.dart';
import 'package:luopan/pages/luopan_toolbox/luopan_toolbox_binding.dart';
import 'package:luopan/pages/luopan_toolbox/luopan_toolbox_view.dart';
import 'package:luopan/pages/luopan_vr_compass/luopan_vr_compass_binding.dart';
import 'package:luopan/pages/luopan_vr_compass/luopan_vr_compass_view.dart';
import 'package:luopan/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '罗盘指南',
          getPages: Compass,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.accent,
              surface: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(size: 22, color: Colors.white),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: AppColors.tabSelected,
              unselectedItemColor: AppColors.tabNormal,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            dividerTheme: const DividerThemeData(
              thickness: 1,
              color: AppColors.divider,
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Compass = [
  GetPage(
    name: '/',
    page: () => const LuopanConfigView(),
    binding: LuopanConfigBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/luopan_tab',
    page: () => const LuopanTabView(),
    binding: LuopanTabBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_home',
    page: () => const LuopanHomeView(),
    binding: LuopanHomeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_compass_reading',
    page: () => const LuopanCompassReadingView(),
    binding: LuopanCompassReadingBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_toolbox',
    page: () => const LuopanToolboxView(),
    binding: LuopanToolboxBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/luopan_session',
    page: () => AppRedurce(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_vr_compass',
    page: () => const LuopanVrCompassView(),
    binding: LuopanVrCompassBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_lulong_ruler',
    page: () => const LuopanLulongRulerView(),
    binding: LuopanLulongRulerBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_decibel_meter',
    page: () => const LuopanDecibelMeterView(),
    binding: LuopanDecibelMeterBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_level',
    page: () => const LuopanLevelView(),
    binding: LuopanLevelBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_clothing_guide',
    page: () => const LuopanClothingGuideView(),
    binding: LuopanClothingGuideBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),

  GetPage(
    name: '/luopan_settings',
    page: () => const LuopanSettingsView(),
    binding: LuopanSettingsBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];