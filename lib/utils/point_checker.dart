// lib/utils/point_checker.dart
// 打点判定に関するユーティリティ関数

class PointChecker {
  // 子の通常形の場合の要求打点チェック
  static String checkValue(double x) {
    // 定義されたAとBの値のリスト
    final List<List<dynamic>> conditions = [
      ["1300", 3915],
      ["1600", 4606],
      ["2000", 4934],
      ["2600", 6214],
      ["3200", 6915],
      ["3900", 7650],
      ["5200", 8596],
      ["6400", 8938],
      ["7700", 10289],
      ["8000(4翻)", 10369],
      ["8000(5翻)", 12344],
      ["12000(6翻)", 14399],
      ["12000(7翻)", 16183],
      ["16000(8翻)", 17723]
    ];

    for (var condition in conditions) {
      String a = condition[0];
      double b = condition[1].toDouble();
      if (x <= b) {
        return a;
      }
    }
    return "-";
  }

  // 親の通常形の場合の要求打点チェック
  static String checkValue2(double x) {
    // 定義されたCとDの値のリスト
    final List<List<dynamic>> conditions = [
      ["2000", 5410],
      ["2400", 6373],
      ["2900", 6920],
      ["3900", 8764],
      ["4800", 9866],
      ["5800", 10967],
      ["7700", 12332],
      ["9600", 12901],
      ["11600", 14940],
      ["12000(4翻)", 15047],
      ["12000(5翻)", 18010],
      ["18000(6翻)", 21093],
      ["18000(7翻)", 23768],
      ["24000(8翻)", 26079]
    ];

    for (var condition in conditions) {
      String c = condition[0];
      double d = condition[1].toDouble();
      if (x <= d) {
        return c;
      }
    }
    return "-";
  }

  // 子の愚形の場合の要求打点チェック
  static String checkValue3(double x) {
    // 定義されたAとBの値のリスト
    final List<List<dynamic>> conditions = [
      ["1300", 3804],
      ["1600", 4446],
      ["2600", 6026],
      ["3200", 6747],
      ["5200", 8457],
      ["6400", 8840],
      ["8000(4翻)", 10225],
      ["8000(5翻)", 12164],
      ["12000(6翻)", 14260],
      ["12000(7翻)", 16037],
      ["16000(8翻)", 17636]
    ];

    for (var condition in conditions) {
      String a = condition[0];
      double b = condition[1].toDouble();
      if (x <= b) {
        return a;
      }
    }
    return "-";
  }

  // 親の愚形の場合の要求打点チェック
  static String checkValue4(double x) {
    // 定義されたCとDの値のリスト
    final List<List<dynamic>> conditions = [
      ["2000", 5202],
      ["2400", 6133],
      ["3900", 8485],
      ["4800", 9614],
      ["7700", 12120],
      ["9600", 12753],
      ["12000(4翻)", 14831],
      ["12000(5翻)", 17740],
      ["18000(6翻)", 20844],
      ["18000(7翻)", 23549],
      ["24000(8翻)", 25947]
    ];

    for (var condition in conditions) {
      String c = condition[0];
      double d = condition[1].toDouble();
      if (x <= d) {
        return c;
      }
    }
    return "-";
  }
  
  // 子の通常形の場合の実際打点チェック
  static double checkValue5(double x) {
    // 定義されたAとBの値のリスト
    final List<List<dynamic>> conditions = [
      ["1300", 3915],
      ["1600", 4606],
      ["2000", 4934],
      ["2600", 6214],
      ["3200", 6915],
      ["3900", 7650],
      ["5200", 8596],
      ["6400", 8938],
      ["7700", 10289],
      ["8000(4翻)", 10369],
      ["8000(5翻)", 12344],
      ["12000(6翻)", 14399],
      ["12000(7翻)", 16183],
      ["16000(8翻)", 17723]
    ];

    for (var condition in conditions) {
      double b = condition[1].toDouble();
      if (x <= b) {
        return b;
      }
    }
    return 0;
  }

  // 親の通常形の場合の実際打点チェック
  static double checkValue6(double x) {
    // 定義されたCとDの値のリスト
    final List<List<dynamic>> conditions = [
      ["2000", 5410],
      ["2400", 6373],
      ["2900", 6920],
      ["3900", 8764],
      ["4800", 9866],
      ["5800", 10967],
      ["7700", 12332],
      ["9600", 12901],
      ["11600", 14940],
      ["12000(4翻)", 15047],
      ["12000(5翻)", 18010],
      ["18000(6翻)", 21093],
      ["18000(7翻)", 23768],
      ["24000(8翻)", 26079]
    ];

    for (var condition in conditions) {
      double d = condition[1].toDouble();
      if (x <= d) {
        return d;
      }
    }
    return 0;
  }

  // 子の愚形の場合の実際打点チェック
  static double checkValue7(double x) {
    // 定義されたAとBの値のリスト
    final List<List<dynamic>> conditions = [
      ["1300", 3804],
      ["1600", 4446],
      ["2600", 6026],
      ["3200", 6747],
      ["5200", 8457],
      ["6400", 8840],
      ["8000(4翻)", 10225],
      ["8000(5翻)", 12164],
      ["12000(6翻)", 14260],
      ["12000(7翻)", 16037],
      ["16000(8翻)", 17636]
    ];

    for (var condition in conditions) {
      double b = condition[1].toDouble();
      if (x <= b) {
        return b;
      }
    }
    return 0;
  }

  // 親の愚形の場合の実際打点チェック
  static double checkValue8(double x) {
    // 定義されたCとDの値のリスト
    final List<List<dynamic>> conditions = [
      ["2000", 5202],
      ["2400", 6133],
      ["3900", 8485],
      ["4800", 9614],
      ["7700", 12120],
      ["9600", 12753],
      ["12000(4翻)", 14831],
      ["12000(5翻)", 17740],
      ["18000(6翻)", 20844],
      ["18000(7翻)", 23549],
      ["24000(8翻)", 25947]
    ];

    for (var condition in conditions) {
      double d = condition[1].toDouble();
      if (x <= d) {
        return d;
      }
    }
    return 0;
  }
  
  // 選択された状態に基づいて要求打点とその差分を計算
  static Map<String, dynamic> getRequiredPoints(
    double bBalanceIncome, 
    bool isParent, 
    bool isRyokei, 
    bool isIppatsuDora
  ) {
    String requiredPoints;
    double actualPoints;
    int pointDiff;
    
    // 条件に基づいて適切な関数を使用
    if (isParent) {
      if (isRyokei) {
        requiredPoints = checkValue2(bBalanceIncome);
        actualPoints = checkValue6(bBalanceIncome);
      } else {
        requiredPoints = checkValue4(bBalanceIncome);
        actualPoints = checkValue8(bBalanceIncome);
      }
    } else {
      if (isRyokei) {
        requiredPoints = checkValue(bBalanceIncome);
        actualPoints = checkValue5(bBalanceIncome);
      } else {
        requiredPoints = checkValue3(bBalanceIncome);
        actualPoints = checkValue7(bBalanceIncome);
      }
    }
    
    try {
      pointDiff = actualPoints.round() - bBalanceIncome.round();
    } catch (e) {
      pointDiff = 0;
    }
    
    return {
      "requiredPoints": requiredPoints,
      "pointDiff": pointDiff
    };
  }
}