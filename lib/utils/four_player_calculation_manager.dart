// lib/utils/four_player_calculation_manager.dart
// 四人麻雀の計算ロジックを管理するクラス

import '../models/game_data.dart';
import '../models/player_data.dart';
import '../utils/calculator.dart';
import '../utils/point_checker.dart';

class FourPlayerCalculationManager {
  // プレイヤーデータ
  final PlayerData jikaPlayer;
  final PlayerData uePlayer;
  final PlayerData toimenPlayer;
  final PlayerData shimoPlayer;
  
  // 設定
  bool isIppatsuDora = false;
  bool isRyokeiStatus = false;
  
  // コンストラクタ
  FourPlayerCalculationManager()
      : jikaPlayer = PlayerData(
            name: '自家', isParent: true, totalSuji: GameData.fourPlayerSujiCount),
        uePlayer = PlayerData(
            name: '上家', isParent: false, totalSuji: GameData.fourPlayerSujiCount),
        toimenPlayer = PlayerData(
            name: '対面', isParent: false, totalSuji: GameData.fourPlayerSujiCount),
        shimoPlayer = PlayerData(
            name: '下家', isParent: false, totalSuji: GameData.fourPlayerSujiCount);

  // プレイヤーをリセット
  void resetPlayer(String playerName) {
    switch (playerName) {
      case '上家':
        uePlayer.resetCount(GameData.fourPlayerSujiCount);
        break;
      case '対面':
        toimenPlayer.resetCount(GameData.fourPlayerSujiCount);
        break;
      case '下家':
        shimoPlayer.resetCount(GameData.fourPlayerSujiCount);
        break;
    }
    calculateAllPlayerData();
  }

  // すべてのプレイヤーをリセット
  void resetAll() {
    uePlayer.resetCount(GameData.fourPlayerSujiCount);
    toimenPlayer.resetCount(GameData.fourPlayerSujiCount);
    shimoPlayer.resetCount(GameData.fourPlayerSujiCount);
    calculateAllPlayerData();
  }

  // カウントを増加
  void incrementCount(String playerName) {
    switch (playerName) {
      case '上家':
        uePlayer.incrementCount(GameData.fourPlayerSujiCount);
        break;
      case '対面':
        toimenPlayer.incrementCount(GameData.fourPlayerSujiCount);
        break;
      case '下家':
        shimoPlayer.incrementCount(GameData.fourPlayerSujiCount);
        break;
    }
    calculateAllPlayerData();
  }

  // 親状態を切り替え
  void toggleParent(String playerName, bool isParent) {
    if (isParent) {
      // 他のプレイヤーを子に設定
      jikaPlayer.toggleParent(playerName == '自家');
      uePlayer.toggleParent(playerName == '上家');
      toimenPlayer.toggleParent(playerName == '対面');
      shimoPlayer.toggleParent(playerName == '下家');
    } else {
      // 該当プレイヤーを子に設定
      switch (playerName) {
        case '自家':
          jikaPlayer.toggleParent(false);
          break;
        case '上家':
          uePlayer.toggleParent(false);
          break;
        case '対面':
          toimenPlayer.toggleParent(false);
          break;
        case '下家':
          shimoPlayer.toggleParent(false);
          break;
      }
      
      // 親が誰もいなくなった場合、自家を親にする
      if (!jikaPlayer.isParent && !uePlayer.isParent && 
          !toimenPlayer.isParent && !shimoPlayer.isParent) {
        jikaPlayer.toggleParent(true);
      }
    }
    calculateAllPlayerData();
  }

  // イッパツドラ設定を切り替え
  void toggleIppatsuDora(bool value) {
    isIppatsuDora = value;
    calculateAllPlayerData();
  }

  // 良形/愚形設定を切り替え
  void toggleRyokeiStatus(bool value) {
    isRyokeiStatus = value;
    calculateAllPlayerData();
  }

  // 全プレイヤーの計算を実行
  void calculateAllPlayerData() {
    _calculatePlayerData(uePlayer);
    _calculatePlayerData(toimenPlayer);
    _calculatePlayerData(shimoPlayer);
  }

  // 個別プレイヤーの計算
  void _calculatePlayerData(PlayerData player) {
    // 放銃率が計算できない場合はスキップ
    if (player.remaining <= 0) return;
    
    // 瞬間放銃率を計算
    double z1 = player.houjuRate;
    double z2 = player.houjuRateRyounashi;
    
    // ***重要***
    // 元のPythonコードと同様に各プレイヤー自身の親子状態を使用して計算
    // player.isParent が true なら親として計算(child=false)
    // player.isParent が false なら子として計算(child=true)
    bool isChild = !player.isParent;
    
    // 通常形の計算
    Map<String, dynamic> normalFormData = MahjongCalculator.calculateAdditionalData(
      z1, 
      z2, 
      child: isChild,  // 各プレイヤー自身の親子状態
      ippatsuDora: isIppatsuDora
    );
    
    // 愚形の計算
    Map<String, dynamic> guFormData = MahjongCalculator.calculateAdditionalData2(
      z1, 
      z2, 
      child: isChild,  // 各プレイヤー自身の親子状態
      ippatsuDora: isIppatsuDora
    );
    
    // 片スジデータ (additionalData1またはadditionalData3)
    Map<String, dynamic> kataSujiData = isRyokeiStatus 
        ? normalFormData['additionalData1'] 
        : guFormData['additionalData3'];
    
    // 両無スジデータ (additionalData2またはadditionalData4)
    Map<String, dynamic> ryouNashiData = isRyokeiStatus 
        ? normalFormData['additionalData2'] 
        : guFormData['additionalData4'];
    
    // B均衡収入を取得
    double bBalanceIncome1 = kataSujiData["B均衡収入"];
    double bBalanceIncome2 = ryouNashiData["B均衡収入"];
    
    // 要求打点の計算は自家の親子状態で分岐
    String requiredPoints1;
    int pointDiff1;
    String requiredPoints2;
    int pointDiff2;
    
    // ***重要***
    // 元のPythonコードと同様に自家の親子状態に基づいて要求打点計算関数を選択
    if (jikaPlayer.isParent) {
      // 自家が親の場合
      if (isRyokeiStatus) {
        // 良形
        requiredPoints1 = PointChecker.checkValue2(bBalanceIncome1);
        double actualPoints1 = PointChecker.checkValue6(bBalanceIncome1);
        pointDiff1 = actualPoints1 > 0 ? (actualPoints1 - bBalanceIncome1).round() : 0;
        
        requiredPoints2 = PointChecker.checkValue2(bBalanceIncome2);
        double actualPoints2 = PointChecker.checkValue6(bBalanceIncome2);
        pointDiff2 = actualPoints2 > 0 ? (actualPoints2 - bBalanceIncome2).round() : 0;
      } else {
        // 愚形
        requiredPoints1 = PointChecker.checkValue4(bBalanceIncome1);
        double actualPoints1 = PointChecker.checkValue8(bBalanceIncome1);
        pointDiff1 = actualPoints1 > 0 ? (actualPoints1 - bBalanceIncome1).round() : 0;
        
        requiredPoints2 = PointChecker.checkValue4(bBalanceIncome2);
        double actualPoints2 = PointChecker.checkValue8(bBalanceIncome2);
        pointDiff2 = actualPoints2 > 0 ? (actualPoints2 - bBalanceIncome2).round() : 0;
      }
    } else {
      // 自家が子の場合
      if (isRyokeiStatus) {
        // 良形
        requiredPoints1 = PointChecker.checkValue(bBalanceIncome1);
        double actualPoints1 = PointChecker.checkValue5(bBalanceIncome1);
        pointDiff1 = actualPoints1 > 0 ? (actualPoints1 - bBalanceIncome1).round() : 0;
        
        requiredPoints2 = PointChecker.checkValue(bBalanceIncome2);
        double actualPoints2 = PointChecker.checkValue5(bBalanceIncome2);
        pointDiff2 = actualPoints2 > 0 ? (actualPoints2 - bBalanceIncome2).round() : 0;
      } else {
        // 愚形
        requiredPoints1 = PointChecker.checkValue3(bBalanceIncome1);
        double actualPoints1 = PointChecker.checkValue7(bBalanceIncome1);
        pointDiff1 = actualPoints1 > 0 ? (actualPoints1 - bBalanceIncome1).round() : 0;
        
        requiredPoints2 = PointChecker.checkValue3(bBalanceIncome2);
        double actualPoints2 = PointChecker.checkValue7(bBalanceIncome2);
        pointDiff2 = actualPoints2 > 0 ? (actualPoints2 - bBalanceIncome2).round() : 0;
      }
    }
    
    // 計算データの保存
    player.calculatedData = {
      'bBalanceIncome': bBalanceIncome1.round(),
      'zeroIncome': kataSujiData["局収支0収入"].round(),
      'requiredPoints': requiredPoints1,
      'pointDiff': requiredPoints1 == '-' ? '-' : pointDiff1,
      'rawData': kataSujiData,
    };
    
    player.calculatedData2 = {
      'bBalanceIncome': bBalanceIncome2.round(),
      'zeroIncome': ryouNashiData["局収支0収入"].round(),
      'requiredPoints': requiredPoints2,
      'pointDiff': requiredPoints2 == '-' ? '-' : pointDiff2,
      'rawData': ryouNashiData,
    };
  }
  
  // プレイヤーに関する表示データを取得
  Map<String, dynamic> getPlayerDisplayData(String playerName) {
    PlayerData player;
    
    switch (playerName) {
      case '自家':
        player = jikaPlayer;
        break;
      case '上家':
        player = uePlayer;
        break;
      case '対面':
        player = toimenPlayer;
        break;
      case '下家':
        player = shimoPlayer;
        break;
      default:
        return {}; // 該当するプレイヤーがない場合
    }
    
    // 自家の場合は特殊処理
    if (playerName == '自家') {
      return {
        'name': player.name,
        'isParent': player.isParent,
        'count': null,
        'remaining': null,
        'isCalculated': false,
      };
    }
    
    // 残りのプレイヤーの場合
    bool isCalculated = player.calculatedData.isNotEmpty;
    
    return {
      'name': player.name,
      'isParent': player.isParent,
      'count': player.count,
      'remaining': player.remaining,
      'houjuRate': player.getHoujuRateDisplay(),
      'houjuRateRyounashi': player.getHoujuRateRyounashiDisplay(),
      'isCalculated': isCalculated,
      'kataSujiData': isCalculated ? {
        'requiredPoints': player.calculatedData['requiredPoints'] ?? '-',
        'bBalanceIncome': player.calculatedData['bBalanceIncome'],
        'zeroIncome': player.calculatedData['zeroIncome'],
        'pointDiff': player.calculatedData['pointDiff'],
      } : null,
      'ryouNashiData': isCalculated ? {
        'requiredPoints': player.calculatedData2['requiredPoints'] ?? '-',
        'bBalanceIncome': player.calculatedData2['bBalanceIncome'],
        'zeroIncome': player.calculatedData2['zeroIncome'],
        'pointDiff': player.calculatedData2['pointDiff'],
      } : null,
    };
  }
}