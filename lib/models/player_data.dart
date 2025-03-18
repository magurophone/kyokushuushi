// lib/models/player_data.dart
// プレイヤーデータを格納するクラス

class PlayerData {
  final String name; // プレイヤー名
  bool isParent; // 親かどうか
  int count; // 通った筋のカウント
  int remaining; // 残りの筋
  double houjuRate; // 瞬間放銃率
  double houjuRateRyounashi; // 両無しの瞬間放銃率

  // 計算結果を格納
  Map<String, dynamic> calculatedData = {};
  Map<String, dynamic> calculatedData2 = {}; // 良形/悪形など別の計算結果

  // コンストラクタ
  PlayerData({
    required this.name,
    this.isParent = false,
    this.count = 0,
    required int totalSuji,
  }) : 
    remaining = totalSuji,
    houjuRate = 1.0 / totalSuji,  // 初期値を正しく設定
    houjuRateRyounashi = 2.0 / totalSuji;  // 初期値を正しく設定

  // カウントを増加
  void incrementCount(int totalSuji) {
    if (count < totalSuji) {
      count++;
      remaining = totalSuji - count;
      _updateRates();
    }
  }

  // カウントをリセット
  void resetCount(int totalSuji) {
    count = 0;
    remaining = totalSuji;
    houjuRate = 1.0 / totalSuji;  // 明示的に放銃率を更新
    houjuRateRyounashi = 2.0 / totalSuji;  // 両無し放銃率も更新
    
    // 計算結果もクリア
    calculatedData = {};
    calculatedData2 = {};
  }

  // 放銃率を更新
  void _updateRates() {
    if (remaining <= 0) {
      houjuRate = 1.0;
      houjuRateRyounashi = 1.0;
    } else {
      houjuRate = 1.0 / remaining;
      houjuRateRyounashi = 2.0 / remaining;
      
      // 100%を超えた場合は1.0に制限
      if (houjuRate > 1.0) houjuRate = 1.0;
      if (houjuRateRyounashi > 1.0) houjuRateRyounashi = 1.0;
    }
  }

  // 親状態を切り替え
  void toggleParent(bool value) {
    isParent = value;
  }

  // 表示用の放銃率文字列を取得
  String getHoujuRateDisplay() {
    if (remaining <= 0) return "-";
    double percentage = houjuRate * 100;
    return "${percentage.toStringAsFixed(2)}%";
  }

  // 表示用の両無し放銃率文字列を取得
  String getHoujuRateRyounashiDisplay() {
    if (remaining <= 0) return "-";
    double percentage = houjuRateRyounashi * 100;
    return "${percentage.toStringAsFixed(2)}%";
  }
}