// lib/widgets/player_detail_widget.dart
import 'package:flutter/material.dart';

class PlayerDetailWidget extends StatelessWidget {
  final Map<String, dynamic> playerData;
  final String selectedPlayer;
  final TextStyle headerStyle;
  final TextStyle subHeaderStyle;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final Function(String, {String area}) showExplanationDialog;
  final VoidCallback? onSettingsTap;
  final bool isDarkMode;

  const PlayerDetailWidget({
    Key? key,
    required this.playerData,
    required this.selectedPlayer,
    required this.headerStyle,
    required this.subHeaderStyle,
    required this.labelStyle,
    required this.valueStyle,
    required this.showExplanationDialog,
    this.onSettingsTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 自家が選択された場合は詳細を表示しない
    if (selectedPlayer == '自家') {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),  // 非常に薄いグレー
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode 
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),  // 薄いグレーの境界線
              width: 1,
            ),
          ),
          child: Text(
            '自家には局収支情報はありません',
            style: TextStyle(
              fontSize: labelStyle.fontSize,
              color: isDarkMode ? Colors.grey : Color(0xFF424242),  // 濃いめのグレー
            ),
          ),
        ),
      );
    }
    
    // プレイヤーデータが計算されていない場合
    if (!playerData['isCalculated']) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode 
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            '局収支データがまだ計算されていません',
            style: TextStyle(
              fontSize: labelStyle.fontSize,
              color: isDarkMode ? Colors.grey : Color(0xFF424242),  // 濃いめのグレー
            ),
          ),
        ),
      );
    }
    
    // ヘッダー表示用
    String playerStatusText = '$selectedPlayer (${playerData['isParent'] ? '親' : '子'})';
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode 
            ? Colors.blue.withOpacity(0.3)
            : Color(0xFF1976D2).withOpacity(0.3),  // 薄い青の境界線
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
            ? [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
                Colors.blue.withOpacity(0.03),
                Colors.blue.withOpacity(0.05),
              ]
            : [
                Colors.white,  // 白背景
                Color(0xFFF5F5F5),  // 非常に薄いグレー
                Color(0xFFE3F2FD),  // 非常に薄い青
                Color(0xFFE3F2FD).withOpacity(0.7),
                Color(0xFFBBDEFB).withOpacity(0.5),
              ],
          stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ヘッダー - 選択プレイヤーと設定ボタンを配置
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                    ? [
                        Colors.blue.withOpacity(0.2),
                        Colors.blue.withOpacity(0.15),
                        Colors.blue.withOpacity(0.1),
                        Colors.blue.withOpacity(0.05),
                      ]
                    : [
                        Color(0xFF1976D2).withOpacity(0.8),  // ミディアム青
                        Color(0xFF1976D2).withOpacity(0.7),
                        Color(0xFF1976D2).withOpacity(0.6),
                        Color(0xFF1976D2).withOpacity(0.5),
                      ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10), // 左側の余白
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: headerStyle.fontSize,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$selectedPlayer (${playerData['isParent'] ? '親' : '子'})',
                            style: TextStyle(
                              fontSize: headerStyle.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,  // ヘッダーのテキストは白のまま
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: onSettingsTap,
                  ),
                ],
              ),
            ),
          ),
          
          
          // 筋情報
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(6, 2, 6, 0),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                    ? [
                        Colors.grey.shade900.withOpacity(0.8),
                        Colors.black.withOpacity(0.8),
                      ]  // ダークモードは元のまま
                    : [
                        Color(0xFFE3F2FD),  // 非常に薄い青
                        Color(0xFFBBDEFB),  // 薄い青
                      ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode
                    ? Colors.grey.shade800.withOpacity(0.5)  // ダークモードは元のまま
                    : Color(0xFF1976D2).withOpacity(0.3),  // 薄い青の境界線
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isDarkMode
                    ? _buildSimpleDetailColumn('通った筋', playerData['count'].toString())  // ダークモードは元のまま
                    : _buildSujiInfoColumn('通った筋', playerData['count'].toString()),    // ライトモードのみ新しいスタイル
                  isDarkMode
                    ? _buildSimpleDetailColumn('残り筋', playerData['remaining'].toString())  // ダークモードは元のまま
                    : _buildSujiInfoColumn('残り筋', playerData['remaining'].toString()),    // ライトモードのみ新しいスタイル
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // 片スジデータ
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(6, 0, 6, 2),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                    ? [
                        Colors.green.withOpacity(0.08),
                        Colors.green.withOpacity(0.1),
                        Colors.green.withOpacity(0.15),
                        Colors.green.withOpacity(0.2),
                      ]
                    : [
                        Colors.green.withOpacity(0.15),
                        Colors.green.withOpacity(0.2),
                        Colors.green.withOpacity(0.25),
                        Colors.green.withOpacity(0.3),
                      ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withOpacity(isDarkMode ? 0.3 : 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ラベル部分
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => showExplanationDialog('片スジ'),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          child: Text(
                            '片スジ',
                            style: TextStyle(
                              fontSize: subHeaderStyle.fontSize,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.green.shade300 : Color(0xFF2E7D32), // 鮮やかで明確な緑
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // データ部分
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSimpleDetailColumn('放銃率', playerData['houjuRate'], area: '片スジ'),
                        _buildSimpleDetailColumn('要求打点', playerData['kataSujiData']['requiredPoints'], area: '片スジ'),
                        _buildSimpleDetailColumn('局収支差', playerData['kataSujiData']['pointDiff'].toString(), area: '片スジ'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 両無スジデータ
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(6, 0, 6, 2),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                    ? [
                        Colors.amber.withOpacity(0.08),
                        Colors.amber.withOpacity(0.1),
                        Colors.amber.withOpacity(0.15),
                        Colors.amber.withOpacity(0.2),
                      ]
                    : [
                        Colors.purple.withOpacity(0.15),  // パープル系に変更
                        Colors.purple.withOpacity(0.2),
                        Colors.purple.withOpacity(0.25),
                        Colors.purple.withOpacity(0.3),
                      ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode 
                    ? Colors.amber.withOpacity(0.3)
                    : Colors.purple.withOpacity(0.5),  // パープル系の境界線
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ラベル部分
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => showExplanationDialog('両無スジ'),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          child: Text(
                            '両無スジ',
                            style: TextStyle(
                              fontSize: subHeaderStyle.fontSize,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode 
                                ? Colors.amber.shade300 
                                : Color(0xFF9C27B0), // パープル系に変更 (Material Purple)
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // データ部分
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSimpleDetailColumn('放銃率', playerData['houjuRateRyounashi'], area: '両無スジ'),
                        _buildSimpleDetailColumn('要求打点', playerData['ryouNashiData']['requiredPoints'], area: '両無スジ'),
                        _buildSimpleDetailColumn('局収支差', playerData['ryouNashiData']['pointDiff'].toString(), area: '両無スジ'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 筋情報用の特別なカラム (ライトモードのみ使用)
  Widget _buildSujiInfoColumn(String label, String value) {
    return Expanded(
      child: InkWell( // InkWellを追加して、タップ可能に
        onTap: () => showExplanationDialog(label),
        borderRadius: BorderRadius.circular(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: labelStyle.fontSize,
                fontWeight: FontWeight.w500, // やや太く
                color: Color(0xFF424242),   // 濃いグレー（他のラベルと同じ）
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,  // 白背景
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: valueStyle.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),  // 暗いテキスト
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // シンプルな情報カラム
  Widget _buildSimpleDetailColumn(String label, String value, {String area = ''}) {
    return Expanded(
      child: InkWell(
        onTap: () => showExplanationDialog(label, area: area),
        borderRadius: BorderRadius.circular(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: labelStyle.fontSize,
                fontWeight: FontWeight.w500, // やや太く
                color: isDarkMode 
                  ? Colors.grey.shade300  // より明るいグレー
                  : Color(0xFF424242),   // 濃いグレー
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkMode 
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white.withOpacity(0.85),  // 白背景
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),  // 薄いグレー境界線
                  width: 1,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueStyle.fontSize,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode 
                      ? Colors.white 
                      : Color(0xFF212121),  // 暗いテキスト
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}