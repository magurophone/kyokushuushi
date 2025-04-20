// lib/widgets/player_row_widget.dart
import 'package:flutter/material.dart';

class PlayerRowWidget extends StatelessWidget {
  final String name;
  final Map<String, dynamic> playerData;
  final VoidCallback? onIncrement;
  final Function(bool) onToggleParent;
  final VoidCallback? onReset;
  final bool isSelected;
  final VoidCallback onSelect;
  final double fontRatio;
  final TextStyle buttonTextStyle;
  final bool isDarkMode;

  const PlayerRowWidget({
    Key? key,
    required this.name,
    required this.playerData,
    this.onIncrement,
    required this.onToggleParent,
    this.onReset,
    required this.isSelected,
    required this.onSelect,
    required this.fontRatio,
    required this.buttonTextStyle,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 自家の場合はカウントとリセットボタンは表示しない
    final bool isJika = name == '自家';
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        gradient: isSelected ? LinearGradient(
          colors: isDarkMode
            ? [
                Colors.blue.withOpacity(0.05),
                Colors.blue.withOpacity(0.08),
                Colors.blue.withOpacity(0.12),
                Colors.blue.withOpacity(0.15),
              ]
            : [
                Color(0xFF1976D2).withOpacity(0.05),  // ミディアム青
                Color(0xFF1976D2).withOpacity(0.1),
                Color(0xFF1976D2).withOpacity(0.15),
                Color(0xFF1976D2).withOpacity(0.2),
              ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // プレイヤー名部分 - タップ可能
          InkWell(
            onTap: isJika ? null : onSelect,
            enableFeedback: false,
            borderRadius: BorderRadius.circular(4),
            splashColor: Colors.blue.withOpacity(0.2),
            highlightColor: Colors.blue.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: isSelected ? Border.all(
                  color: isDarkMode
                    ? Colors.blue.withOpacity(0.5)
                    : Color(0xFF1976D2).withOpacity(0.5),
                  width: 1,
                ) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: buttonTextStyle.fontSize! - 2,
                    color: isSelected 
                      ? (isDarkMode ? Colors.blue : Color(0xFF0D47A1))  // 濃い青
                      : (isDarkMode ? Colors.white70 : Color(0xFF212121)),  // 黒に近いグレー
                  ),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: buttonTextStyle.fontSize,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                        ? (isDarkMode ? Colors.blue : Color(0xFF0D47A1))  // 濃い青
                        : (isDarkMode ? Colors.white : Color(0xFF212121)),  // 黒に近いグレー
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 親/子スイッチ
          LayoutBuilder(
            builder: (context, constraints) {
              // 画面サイズを取得
              final screenWidth = MediaQuery.of(context).size.width;
              
              // 大画面(600以上)では間隔を広げる
              final textWidth = screenWidth >= 600 ? 25.0 * fontRatio : 10.0 * fontRatio;
              final spacerWidth = screenWidth >= 600 ? 10.0 : 0.0;
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 親/子テキスト - 画面サイズに応じて幅を変える
                  SizedBox(
                    width: textWidth,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: buttonTextStyle.fontSize! - 2,
                        color: playerData['isParent'] 
                          ? Color(0xFFE65100)  // より鮮やかなオレンジ
                          : (isDarkMode ? Colors.white70 : Color(0xFF424242)),  // 濃いめのグレー
                        fontWeight: playerData['isParent'] ? FontWeight.bold : FontWeight.normal,
                      ),
                      child: Text(
                        playerData['isParent'] ? '親' : '子',
                      ),
                    ),
                  ),
                  // 大画面では間隔を追加
                  SizedBox(width: spacerWidth),
                  // スイッチ - サイズを可変に
                  Transform.scale(
                    scale: 0.7 * fontRatio, // スケールを画面サイズに合わせて可変に
                    child: Switch(
                      value: playerData['isParent'],
                      onChanged: onToggleParent,
                      activeColor: Colors.orange,
                      activeTrackColor: Colors.orange.withOpacity(0.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              );
            },
          ),
                    
          const SizedBox(width: 12),
          
          if (!isJika) ...[
// カウンターボタン
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 全体の画面幅を取得
                  final screenWidth = MediaQuery.of(context).size.width;

                  // 画面サイズに応じて幅の係数を変える
                  // 大画面(600以上)なら80%、小画面なら100%
                  final widthFactor = screenWidth >= 600 ? 0.8 : 1.0;

                  return Center(
                    child: FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: Container(
                        height: 40 * fontRatio, // 高さを画面サイズに合わせて可変に
                        // ボタンの外側にシャドウを追加するコンテナ
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: onIncrement,
                          icon: Icon(Icons.add, size: buttonTextStyle.fontSize! + 1),
                          label: Text('カウンター', style: buttonTextStyle),
                          style: ElevatedButton.styleFrom(
                            // フィードバック音だけを無効化（リップルは残る）
                            enableFeedback: false,

                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4 * fontRatio,
                              vertical: 0,
                            ),
                            minimumSize: Size(30 * fontRatio, 30 * fontRatio),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 4, // 標準的なエレベーション
                            backgroundColor: isDarkMode
                                ? Colors.blue.shade600
                                : const Color(0xFF1976D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ).copyWith(
                            // 押下時のオーバーレイカラー（リップルの色）などはそのままカスタマイズ可能
                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return isDarkMode
                                      ? Colors.blue.shade400.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.3);
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            // リセットボタン
            SizedBox(
              width: 35 * fontRatio, // 幅を画面サイズに合わせて可変に
              height: 35 * fontRatio, // 高さを画面サイズに合わせて可変に
              child: IconButton(
                onPressed: onReset,
                icon: Icon(Icons.refresh, size: buttonTextStyle.fontSize! + 2),
                // フィードバック音だけを無効化（リップルは残る）
                enableFeedback: false,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    isDarkMode
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  foregroundColor: MaterialStateProperty.all(  // 誤記を修正
                    isDarkMode ? Colors.white70 : const Color(0xFF757575),
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all(
                    Size(30 * fontRatio, 30 * fontRatio),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(2),
                  shadowColor: MaterialStateProperty.all(
                    Colors.black.withOpacity(0.3),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return isDarkMode
                            ? Colors.grey.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.2); // タップ時の色
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),
          ] else ...[
            // 自家の場合はスペーサー
            const Spacer(),
          ],
        ],
      ),
    );
  }
}