class ShiChen {
  final String diZhi;

  final String tianGan;

  final String jiXiong;

  final String wuXing;

  final int index;

  final String timeRange;

  ShiChen({
    required this.diZhi,
    required this.tianGan,
    required this.jiXiong,
    required this.wuXing,
    required this.index,
    required this.timeRange,
  });

  factory ShiChen.fromMap(Map<String, dynamic> map) {
    return ShiChen(
      diZhi: map['diZhi'] as String,
      tianGan: map['tianGan'] as String,
      jiXiong: map['jiXiong'] as String,
      wuXing: map['wuXing'] as String,
      index: map['index'] as int,
      timeRange: map['timeRange'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diZhi': diZhi,
      'tianGan': tianGan,
      'jiXiong': jiXiong,
      'wuXing': wuXing,
      'index': index,
      'timeRange': timeRange,
    };
  }

  @override
  String toString() {
    return 'ShiChen(diZhi: $diZhi, tianGan: $tianGan, jiXiong: $jiXiong, wuXing: $wuXing, index: $index, timeRange: $timeRange)';
  }
}
