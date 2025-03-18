// lib/utils/calculator.dart
// 局収支計算のためのロジック

import '../models/game_data.dart';

class MahjongCalculator {
  // 0除算を防ぐためのセーフな除算
  static double safeDivide(num numerator, num denominator) {
    if (denominator == 0) {
      return 100000; // エラーハンドリング: 0除算の場合に100000を返す
    }
    try {
      return numerator / denominator;
    } catch (e) {
      return 100000; // エラーハンドリング: 例外が発生した場合に100000を返す
    }
  }

  // 追加データを計算 - 通常の計算
  static Map<String, dynamic> calculateAdditionalData(
    double z1, 
    double z2, 
    {bool child = true, bool ippatsuDora = true}
  ) {
    int index = child ? 0 : 1;

    // 計算
    double instantHoujuRate1 = z1;
    double instantHoujuRate2 = z2;
    
    double ryuukyokuHoujuRate1 = 1 - (1 - instantHoujuRate1) * (1 - GameData.ryuukyokuMadeHoujuRate[index]);
    double ryuukyokuHoujuRate2 = 1 - (1 - instantHoujuRate2) * (1 - GameData.ryuukyokuMadeHoujuRate[index]);
    
    double agariRate1 = 0.44 - 0.44 * z1;
    double agariRate2 = 0.44 - 0.44 * z2;
    
    int selectedHoujuSoten1 = ippatsuDora 
        ? GameData.houjuSotenIppatsuDora[index] 
        : GameData.houjuSoten[index];
    int selectedHoujuSoten2 = ippatsuDora 
        ? GameData.houjuSotenIppatsuDora[index] 
        : GameData.houjuSoten[index];
    
    double tsumoRateW1 = 0.22 - 0.22 * instantHoujuRate1;
    double tsumoRateW2 = 0.22 - 0.22 * instantHoujuRate2;
    
    int tsumoLossAvg1 = GameData.hiTsumoLoss[index];
    int tsumoLossAvg2 = GameData.hiTsumoLoss[index];
    
    double riichiStickLoss1 = 450 - 450 * z1;
    double riichiStickLoss2 = 450 - 450 * z2;
    
    double ryuukyokuRate1 = 0.08 - 0.08 * z1;
    double ryuukyokuRate2 = 0.08 - 0.08 * z2;

    // 計算部分
    num numerator1 = (GameData.betaoriKyokushuushi[index] + 
                ryuukyokuHoujuRate1 * selectedHoujuSoten1 +
                tsumoRateW1 * tsumoLossAvg1 - 
                ryuukyokuRate1 * GameData.ryuukyokuTokuten[index] + 
                riichiStickLoss1);

    num numerator2 = (GameData.betaoriKyokushuushi[index] + 
                ryuukyokuHoujuRate2 * selectedHoujuSoten2 +
                tsumoRateW2 * tsumoLossAvg2 - 
                ryuukyokuRate2 * GameData.ryuukyokuTokuten[index] + 
                riichiStickLoss2);

    double bBalanceIncome1 = safeDivide(numerator1, agariRate1);
    double bBalanceIncome2 = safeDivide(numerator2, agariRate2);

    double zeroIncome1 = safeDivide((ryuukyokuHoujuRate1 * selectedHoujuSoten1 + 
                            tsumoRateW1 * tsumoLossAvg1 - 
                            ryuukyokuRate1 * GameData.ryuukyokuTokuten[index] + 
                            riichiStickLoss1), agariRate1);

    double zeroIncome2 = safeDivide((ryuukyokuHoujuRate2 * selectedHoujuSoten2 + 
                            tsumoRateW2 * tsumoLossAvg2 - 
                            ryuukyokuRate2 * GameData.ryuukyokuTokuten[index] + 
                            riichiStickLoss2), agariRate2);

    // 追加データを返す
    Map<String, dynamic> additionalData1 = {
      "瞬間放銃率": instantHoujuRate1,
      "和了率": agariRate1,
      "B均衡収入": bBalanceIncome1,
      "局収支0収入": zeroIncome1,
      "流局まで放銃率W": ryuukyokuHoujuRate1,
      "採用放銃素点": selectedHoujuSoten1,
      "被ツモ率W": tsumoRateW1,
      "被ツモ時損失平均": tsumoLossAvg1,
      "立直棒没収損失": riichiStickLoss1,
      "流局率": ryuukyokuRate1,
      "流局時得点": GameData.ryuukyokuTokuten[index],
      "ベタオリ局収支": GameData.betaoriKyokushuushi[index]
    };

    Map<String, dynamic> additionalData2 = {
      "瞬間放銃率": instantHoujuRate2,
      "和了率": agariRate2,
      "B均衡収入": bBalanceIncome2,
      "局収支0収入": zeroIncome2,
      "流局まで放銃率W": ryuukyokuHoujuRate2,
      "採用放銃素点": selectedHoujuSoten2,
      "被ツモ率W": tsumoRateW2,
      "被ツモ時損失平均": tsumoLossAvg2,
      "立直棒没収損失": riichiStickLoss2,
      "流局率": ryuukyokuRate2,
      "流局時得点": GameData.ryuukyokuTokuten[index],
      "ベタオリ局収支": GameData.betaoriKyokushuushi[index]
    };

    return {
      "additionalData1": additionalData1,
      "additionalData2": additionalData2,
    };
  }

  // 追加データを計算 - 愚形計算
  static Map<String, dynamic> calculateAdditionalData2(
    double z1, 
    double z2, 
    {bool child = true, bool ippatsuDora = true}
  ) {
    int index = child ? 0 : 1;

    // 計算
    double instantHoujuRate3 = z1;
    double instantHoujuRate4 = z2;
    
    double ryuukyokuHoujuRate3 = 1 - (1 - instantHoujuRate3) * (1 - GameData.ryuukyokuMadeHoujuRate2[index]);
    double ryuukyokuHoujuRate4 = 1 - (1 - instantHoujuRate4) * (1 - GameData.ryuukyokuMadeHoujuRate2[index]);
    
    double agariRate3 = 0.31 - 0.31 * z1;
    double agariRate4 = 0.31 - 0.31 * z2;
    
    int selectedHoujuSoten3 = ippatsuDora 
        ? GameData.houjuSotenIppatsuDora[index] 
        : GameData.houjuSoten[index];
    int selectedHoujuSoten4 = ippatsuDora 
        ? GameData.houjuSotenIppatsuDora[index] 
        : GameData.houjuSoten[index];
    
    double tsumoRateW3 = 0.25 - 0.25 * instantHoujuRate3;
    double tsumoRateW4 = 0.25 - 0.25 * instantHoujuRate4;
    
    int tsumoLossAvg3 = GameData.hiTsumoLoss[index];
    int tsumoLossAvg4 = GameData.hiTsumoLoss[index];
    
    double riichiStickLoss3 = 540 - 540 * z1;
    double riichiStickLoss4 = 540 - 540 * z2;
    
    double ryuukyokuRate3 = 0.13 - 0.13 * z1;
    double ryuukyokuRate4 = 0.13 - 0.13 * z2;

    // 計算部分
    num numerator3 = (GameData.betaoriKyokushuushi[index] + 
                ryuukyokuHoujuRate3 * selectedHoujuSoten3 +
                tsumoRateW3 * tsumoLossAvg3 - 
                ryuukyokuRate3 * GameData.ryuukyokuTokuten[index] + 
                riichiStickLoss3);

    num numerator4 = (GameData.betaoriKyokushuushi[index] + 
                ryuukyokuHoujuRate4 * selectedHoujuSoten4 +
                tsumoRateW4 * tsumoLossAvg4 - 
                ryuukyokuRate4 * GameData.ryuukyokuTokuten[index] + 
                riichiStickLoss4);

    double bBalanceIncome3 = safeDivide(numerator3, agariRate3);
    double bBalanceIncome4 = safeDivide(numerator4, agariRate4);

    double zeroIncome3 = safeDivide((ryuukyokuHoujuRate3 * selectedHoujuSoten3 + 
                            tsumoRateW3 * tsumoLossAvg3 - 
                            ryuukyokuRate3 * GameData.ryuukyokuTokuten[index] + 
                            riichiStickLoss3), agariRate3);

    double zeroIncome4 = safeDivide((ryuukyokuHoujuRate4 * selectedHoujuSoten4 + 
                            tsumoRateW4 * tsumoLossAvg4 - 
                            ryuukyokuRate4 * GameData.ryuukyokuTokuten[index] + 
                            riichiStickLoss4), agariRate4);

    // 追加データを辞書に格納
    Map<String, dynamic> additionalData3 = {
      "瞬間放銃率": instantHoujuRate3,
      "和了率": agariRate3,
      "B均衡収入": bBalanceIncome3,
      "局収支0収入": zeroIncome3,
      "流局まで放銃率W": ryuukyokuHoujuRate3,
      "採用放銃素点": selectedHoujuSoten3,
      "被ツモ率W": tsumoRateW3,
      "被ツモ時損失平均": tsumoLossAvg3,
      "立直棒没収損失": riichiStickLoss3,
      "流局率": ryuukyokuRate3,
      "流局時得点": GameData.ryuukyokuTokuten[index],
      "ベタオリ局収支": GameData.betaoriKyokushuushi[index]
    };

    Map<String, dynamic> additionalData4 = {
      "瞬間放銃率": instantHoujuRate4,
      "和了率": agariRate4,
      "B均衡収入": bBalanceIncome4,
      "局収支0収入": zeroIncome4,
      "流局まで放銃率W": ryuukyokuHoujuRate4,
      "採用放銃素点": selectedHoujuSoten4,
      "被ツモ率W": tsumoRateW4,
      "被ツモ時損失平均": tsumoLossAvg4,
      "立直棒没収損失": riichiStickLoss4,
      "流局率": ryuukyokuRate4,
      "流局時得点": GameData.ryuukyokuTokuten[index],
      "ベタオリ局収支": GameData.betaoriKyokushuushi[index]
    };

    return {
      "additionalData3": additionalData3,
      "additionalData4": additionalData4,
    };
  }
}