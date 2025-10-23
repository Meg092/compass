import 'package:get/get.dart';
import '../../utils/data.dart';

class LuopanCompassReadingLogic extends GetxController {
  final compassAngle = 0.0.obs;

  final xiangDirection = ''.obs;
  final xiangAngle = 0.0.obs;
  final zuoDirection = ''.obs;
  final zuoAngle = 0.0.obs;
  final houseType = ''.obs;
  final xiangDescription = ''.obs;
  final zuoDescription = ''.obs;

  final readingItems = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      compassAngle.value = args['compassAngle'] ?? 0.0;
      xiangAngle.value = args['xiangAngle'] ?? 0.0;
      zuoAngle.value = args['zuoAngle'] ?? 180.0;
      xiangDirection.value = args['xiangDirection'] ?? '北';
      zuoDirection.value = args['zuoDirection'] ?? '南';
      houseType.value = args['houseType'] ?? '坎宅';
      xiangDescription.value = args['xiangDescription'] ?? '坎宅';
      zuoDescription.value = args['zuoDescription'] ?? '坐坎向离';
    }

    _calculateReadingData();
  }

  void _calculateReadingData() {
    final xiangMountain = _getMountainFromAngle(xiangAngle.value);
    final xiangXiantianBaguaData = _getXiantianBaguaFromAngle(xiangAngle.value);
    final xiangDragon = _getDragonFromAngle(xiangAngle.value);
    final xiangGold = _getGoldFromAngle(xiangAngle.value);
    final xiangRenpan = _getRenpan24FromAngle(xiangAngle.value);

    final zuoMountain = _getMountainFromAngle(zuoAngle.value);
    final zuoXiantianBaguaData = _getXiantianBaguaFromAngle(zuoAngle.value);
    final zuoDragon = _getDragonFromAngle(zuoAngle.value);
    final zuoGold = _getGoldFromAngle(zuoAngle.value);
    final zuoRenpan = _getRenpan24FromAngle(zuoAngle.value);

    final xiangXiantianBagua = xiangXiantianBaguaData?.bagua ?? '未知';
    final zuoXiantianBagua = zuoXiantianBaguaData?.bagua ?? '未知';

    final xiangBagua = xiangMountain?.bagua ?? '未知';
    final zuoBagua = zuoMountain?.bagua ?? '未知';

    final xiangLuoshu = xiangXiantianBaguaData?.luoshuNumber ?? '未知';
    final zuoLuoshu = zuoXiantianBaguaData?.luoshuNumber ?? '未知';

    final xiang24Mountain = xiangMountain?.mountain ?? '未知';
    final zuo24Mountain = zuoMountain?.mountain ?? '未知';

    final xiang72Dragon = xiangDragon?.dragon ?? '未知';
    final zuo72Dragon = zuoDragon?.dragon ?? '未知';

    final xiang120Gold = xiangGold?.gold ?? '未知';
    final zuo120Gold = zuoGold?.gold ?? '未知';

    final xiangRenpan24 = xiangRenpan?.mountain ?? '未知';
    final zuoRenpan24 = zuoRenpan?.mountain ?? '未知';

    readingItems.value = [
      {
        'title': '先天八卦_卦位',
        'xiang': xiangXiantianBagua,
        'zuo': zuoXiantianBagua,
      },
      {'title': '後天八卦_卦位', 'xiang': xiangBagua, 'zuo': zuoBagua},
      {'title': '先天八卦洛書數', 'xiang': xiangLuoshu, 'zuo': zuoLuoshu},
      {'title': '地盤正針二十四山', 'xiang': xiang24Mountain, 'zuo': zuo24Mountain},
      {'title': '穿山七十二龍', 'xiang': xiang72Dragon, 'zuo': zuo72Dragon},
      {'title': '地盤正針百二十分金', 'xiang': xiang120Gold, 'zuo': zuo120Gold},
      {'title': '人盤中針二十四山', 'xiang': xiangRenpan24, 'zuo': zuoRenpan24},
    ];
  }

  MountainData? _getMountainFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final mountain in mountainDatas) {
      if (mountain.startAngle > mountain.endAngle) {
        if (angle >= mountain.startAngle || angle <= mountain.endAngle) {
          return mountain;
        }
      } else {
        if (angle >= mountain.startAngle && angle <= mountain.endAngle) {
          return mountain;
        }
      }
    }
    return null;
  }

  XiantianBaguaData? _getXiantianBaguaFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final bagua in xiantianBaguaDatas) {
      if (bagua.startAngle > bagua.endAngle) {
        if (angle >= bagua.startAngle || angle <= bagua.endAngle) {
          return bagua;
        }
      } else {
        if (angle >= bagua.startAngle && angle <= bagua.endAngle) {
          return bagua;
        }
      }
    }
    return null;
  }

  DragonData? _getDragonFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final dragon in dragonDatas) {
      if (angle >= dragon.startAngle && angle <= dragon.endAngle) {
        return dragon;
      }
    }
    return null;
  }

  GoldData? _getGoldFromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final gold in goldDatas) {
      if (angle >= gold.startAngle && angle <= gold.endAngle) {
        return gold;
      }
    }
    return null;
  }

  Renpan24Data? _getRenpan24FromAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;

    for (final renpan in renpan24Datas) {
      if (renpan.startAngle > renpan.endAngle) {
        if (angle >= renpan.startAngle || angle <= renpan.endAngle) {
          return renpan;
        }
      } else {
        if (angle >= renpan.startAngle && angle <= renpan.endAngle) {
          return renpan;
        }
      }
    }
    return null;
  }
}
