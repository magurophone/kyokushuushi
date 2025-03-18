// lib/models/game_data.dart
// 麻雀の基本データと定数を格納するクラス

class GameData {
  // 流局まで放銃率 [子, 親]
  static const List<double> ryuukyokuMadeHoujuRate = [0.16, 0.16];
  static const List<double> ryuukyokuMadeHoujuRate2 = [0.19, 0.19];
  
  // 放銃素点 [子, 親]
  static const List<int> houjuSoten = [5300, 7500];
  
  // 放銃素点(一発/ドラ) [子, 親]
  static const List<int> houjuSotenIppatsuDora = [7600, 10900];
  
  // 被ツモ率 [子, 親]
  static const List<double> hiTsumoRate = [0.22, 0.22];
  static const List<double> hiTsumoRate2 = [0.25, 0.25];
  
  // 被ツモ時損失 [子, 親]
  static const List<int> hiTsumoLoss = [1750, 3333];
  
  // 被ツモ時損失（自分が親）
  static const List<int> hiTsumoLossAsParent = [3500, 3500];
  
  // 立直棒没収損失 [子, 親]
  static const List<int> riichiStickLoss = [450, 450];
  static const List<int> riichiStickLoss2 = [540, 540];
  
  // 流局率 [子, 親]
  static const List<double> ryuukyokuRate = [0.8, 0.8];
  static const List<double> ryuukyokuRate2 = [0.13, 0.13];
  
  // 流局時得点 [子, 親]
  static const List<int> ryuukyokuTokuten = [300, 300];
  
  // ベタオリ局収支 [子, 親]
  static const List<int> betaoriKyokushuushi = [-1100, -1700];
  
  // 四人麻雀の片筋数
  static const int fourPlayerSujiCount = 18;
  
  // 三人麻雀の片筋数
  static const int threePlayerSujiCount = 12;
}