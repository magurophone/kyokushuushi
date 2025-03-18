// lib/utils/three_player_calculation_manager.dart
// 三人麻雀の計算ロジックを管理するクラス

import '../models/game_data.dart';
import '../models/player_data.dart';

class ThreePlayerCalculationManager {
  // プレイヤーデータ
  final PlayerData player1;
  final PlayerData player2;
  
  // コンストラクタ
  ThreePlayerCalculationManager()
      : player1 = PlayerData(
            name: 'プレイヤー1', totalSuji: GameData.threePlayerSujiCount),
        player2 = PlayerData(
            name: 'プレイヤー2', totalSuji: GameData.threePlayerSujiCount);

  // プレイヤーをリセット
  void resetPlayer(String playerName) {
    switch (playerName) {
      case 'player1':
        player1.resetCount(GameData.threePlayerSujiCount);
        break;
      case 'player2':
        player2.resetCount(GameData.threePlayerSujiCount);
        break;
    }
  }

  // すべてのプレイヤーをリセット
  void resetAll() {
    player1.resetCount(GameData.threePlayerSujiCount);
    player2.resetCount(GameData.threePlayerSujiCount);
  }

  // カウントを増加
  void incrementCount(String playerName) {
    switch (playerName) {
      case 'player1':
        player1.incrementCount(GameData.threePlayerSujiCount);
        break;
      case 'player2':
        player2.incrementCount(GameData.threePlayerSujiCount);
        break;
    }
  }

  // プレイヤーデータを取得
  Map<String, dynamic> getPlayerData(String playerName) {
    PlayerData player;
    
    switch (playerName) {
      case 'player1':
        player = player1;
        break;
      case 'player2':
        player = player2;
        break;
      default:
        return {}; // 該当するプレイヤーがない場合
    }
    
    return {
      'count': player.count,
      'remaining': player.remaining,
      'houjuRate': player.getHoujuRateDisplay(),
      'houjuRateRyounashi': player.getHoujuRateRyounashiDisplay(),
    };
  }
}