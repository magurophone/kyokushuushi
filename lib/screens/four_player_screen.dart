// lib/screens/four_player_screen.dart
import 'package:flutter/material.dart';
import '../utils/four_player_calculation_manager.dart';
import '../widgets/player_detail_widget.dart';
import '../widgets/player_row_widget.dart';
import '../widgets/divider_widget.dart';
import '../widgets/toggle_option_widget.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/ad_service.dart';
import 'help_screen.dart';

class FourPlayerScreen extends StatefulWidget {
  const FourPlayerScreen({super.key});

  @override
  FourPlayerScreenState createState() => FourPlayerScreenState();
}

class FourPlayerScreenState extends State<FourPlayerScreen> with SingleTickerProviderStateMixin {
  // 計算マネージャー
  final FourPlayerCalculationManager _calculationManager = FourPlayerCalculationManager();
  
  // 選択中のプレイヤー
  String selectedPlayer = "下家"; // デフォルトで下家を選択
  
  // アニメーションコントローラー
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  

  @override
  void initState() {
    super.initState();
    
    // 初期計算を実行
    _calculationManager.calculateAllPlayerData();
    
    // アニメーションコントローラーの初期化
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // アニメーション開始
    _animationController.forward();
    
    // Web環境では広告表示しない
    if (!kIsWeb) {
      // 画面表示時に広告表示を開始（初回表示＆5分ごと）
      AdService().startPeriodicAds();
    }
  }

@override
void dispose() {
  // Web環境では不要
  if (!kIsWeb) {
    // 広告タイマーを停止
    AdService().stopPeriodicAds();
  }
  
  _animationController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    
    // 現在のテーマモードを取得
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // 基準サイズを定義
    const double referenceWidth = 360.0; // 基準となる画面幅
    const double referenceHeight = 640.0; // 基準となる画面高さ
    
    // 横幅と高さの比率を計算
    final double widthRatio = screenWidth / referenceWidth;
    final double heightRatio = screenHeight / referenceHeight;
    
    // 横幅と高さの比率の小さい方を使用して、フォントサイズを調整
    final double fontRatio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    // サイズに基づく可変フォントサイズを計算する関数
    double getResponsiveFontSize(double baseSize) {
      // 最小フォントサイズを確保
      final double minSize = baseSize * 0.7;
      
      // 比率に基づいて計算された値と最小値の大きい方を採用
      return (baseSize * fontRatio) > minSize ? (baseSize * fontRatio) : minSize;
    }
    
    // フォントサイズを定義
    final TextStyle titleStyle = TextStyle(
      fontSize: getResponsiveFontSize(18),
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Color(0xFF212121), // 暗いテキスト
      letterSpacing: 1.2, // 文字間隔を少し広げる
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
    
    final TextStyle headerStyle = TextStyle(
      fontSize: getResponsiveFontSize(16),
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.blue : Color(0xFF0D47A1), // 濃い青
      letterSpacing: 0.8,
    );
    
    final TextStyle subHeaderStyle = TextStyle(
      fontSize: getResponsiveFontSize(14),
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: isDarkMode ? Colors.white : Color(0xFF212121), // 暗いテキスト
    );
    
    final TextStyle labelStyle = TextStyle(
      fontSize: getResponsiveFontSize(12),
      color: isDarkMode ? Colors.grey : Color(0xFF757575), // ミディアムグレー
      letterSpacing: 0.3,
    );
    
    final TextStyle valueStyle = TextStyle(
      fontSize: getResponsiveFontSize(16),
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Color(0xFF212121), // 暗いテキスト
      letterSpacing: 0.5,
    );
    
    final TextStyle buttonTextStyle = TextStyle(
      fontSize: getResponsiveFontSize(13),
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: Colors.white, // ボタンテキストは白のまま
    );
    
    final TextStyle toggleLabelStyle = TextStyle(
      fontSize: getResponsiveFontSize(12),
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Color(0xFF0D47A1), // 濃い青
      letterSpacing: 0.3,
    );

    // テーマに応じた背景グラデーションを設定
    final List<Color> gradientColors = isDarkMode
        ? [
            Colors.black,
            const Color(0xFF1A1A2E),
          ]
        : [
            Colors.white,
            const Color(0xFFF5F5F5),
          ];

    return Scaffold(
        backgroundColor: Colors.transparent, // 透明背景
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: const [0.1, 0.9],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // 上半分 - 選択プレイヤーの詳細表示
                  Expanded(
                    flex: 1,
                    child:PlayerDetailWidget( // PlayerDetailWidget の使用部分                 
                      playerData: _calculationManager.getPlayerDisplayData(selectedPlayer),
                      selectedPlayer: selectedPlayer,
                      headerStyle: headerStyle,
                      subHeaderStyle: subHeaderStyle,
                      labelStyle: labelStyle,
                      valueStyle: valueStyle,
                      isDarkMode: isDarkMode,
                      showExplanationDialog: (String term, {String area = ''}) {
                        _showExplanationDialog(term, area: area);
                      },
                      onSettingsTap: () {
                        // 設定効果音を再生
                        SettingsService().playSound('setting');
                        
                        // 設定画面に遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      onHelpButtonTap: () {
                        // ヘルプ効果音を再生
                        SettingsService().playSound('helpon');
                        
                        // ヘルプ画面に遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpScreen()),
                        );
                      },
                    ),
                  ),
                  
                  // 上下の区切り線
                  const DividerWidget(),
                  
                  // 下半分 - リセットボタン、プレイヤー一覧テーブル、設定
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // 全リセットボタン
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              child: ElevatedButton.icon(
                                onPressed: _resetAll,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  elevation: 8,
                                  shadowColor: Colors.redAccent.withOpacity(0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                      if (states.contains(WidgetState.pressed)) {
                                        return Colors.red.withOpacity(0.3);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                icon: Icon(Icons.refresh, size: getResponsiveFontSize(16)),
                                label: Text('全てリセット', style: buttonTextStyle),
                              ),
                            ),
                          ),
                        ),
                        
                        // プレイヤー一覧テーブル
                        Expanded(
                          flex: 10,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: isDarkMode 
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white,  // 白背景
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.3),  // 薄いグレーの枠線
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: PlayerRowWidget(
                                    name: '自家',
                                    playerData: _calculationManager.getPlayerDisplayData('自家'),
                                    onToggleParent: (value) => _toggleParent('自家', value),
                                    isSelected: selectedPlayer == '自家',
                                    onSelect: () => _selectPlayer('自家'),
                                    fontRatio: fontRatio,
                                    buttonTextStyle: buttonTextStyle,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                const DividerWidget(isSmall: true),
                                Expanded(
                                  child: PlayerRowWidget(
                                    name: '下家',
                                    playerData: _calculationManager.getPlayerDisplayData('下家'),
                                    onIncrement: () => _incrementCount('下家'),
                                    onToggleParent: (value) => _toggleParent('下家', value),
                                    onReset: () => _resetCount('下家'),
                                    isSelected: selectedPlayer == '下家',
                                    onSelect: () => _selectPlayer('下家'),
                                    fontRatio: fontRatio,
                                    buttonTextStyle: buttonTextStyle,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                const DividerWidget(isSmall: true),
                                Expanded(
                                  child: PlayerRowWidget(
                                    name: '対面',
                                    playerData: _calculationManager.getPlayerDisplayData('対面'),
                                    onIncrement: () => _incrementCount('対面'),
                                    onToggleParent: (value) => _toggleParent('対面', value),
                                    onReset: () => _resetCount('対面'),
                                    isSelected: selectedPlayer == '対面',
                                    onSelect: () => _selectPlayer('対面'),
                                    fontRatio: fontRatio,
                                    buttonTextStyle: buttonTextStyle,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                const DividerWidget(isSmall: true),
                                Expanded(
                                  child: PlayerRowWidget(
                                    name: '上家',
                                    playerData: _calculationManager.getPlayerDisplayData('上家'),
                                    onIncrement: () => _incrementCount('上家'),
                                    onToggleParent: (value) => _toggleParent('上家', value),
                                    onReset: () => _resetCount('上家'),
                                    isSelected: selectedPlayer == '上家',
                                    onSelect: () => _selectPlayer('上家'),
                                    fontRatio: fontRatio,
                                    buttonTextStyle: buttonTextStyle,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // 勝負牌・自身の待ちトグル (最下部に配置)
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDarkMode
                                  ? [
                                      Colors.grey.withOpacity(0.1),
                                      Colors.grey.withOpacity(0.2),
                                    ]
                                  : [
                                      Color(0xFFE3F2FD),  // 非常に薄い青
                                      Color(0xFFBBDEFB),  // 薄い青
                                    ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode
                                  ? Colors.grey.withOpacity(0.3)
                                  : Color(0xFF90CAF9).withOpacity(0.5),  // 薄い青の枠線
                                width: 0.5
                              ),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double maxWidth = constraints.maxWidth;
                                final double toggleWidth = maxWidth * 0.48; // 48%の幅を維持
                                
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // 勝負牌設定
                                    ToggleOptionWidget(
                                      label: '勝負牌:',
                                      value: _calculationManager.isIppatsuDora,
                                      onChanged: (v) {
                                        setState(() {
                                          _calculationManager.toggleIppatsuDora(v);
                                          // スイッチ効果音を再生
                                          SettingsService().playSound('switch');
                                        });
                                      },
                                      trueText: '一翻UP',
                                      falseText: '通常牌',
                                      toggleLabelStyle: toggleLabelStyle,
                                      fontRatio: fontRatio,
                                      width: toggleWidth,
                                      isDarkMode: isDarkMode,
                                      onExplanationTap: () => _showExplanationDialog('勝負牌'),
                                    ),
                                    
                                    // 自身の待ち設定
                                    ToggleOptionWidget(
                                      label: '自身の待ち:',
                                      value: _calculationManager.isRyokeiStatus,
                                      onChanged: (v) {
                                        setState(() {
                                          _calculationManager.toggleRyokeiStatus(v);
                                          // スイッチ効果音を再生
                                          SettingsService().playSound('switch');
                                        });
                                      },
                                      trueText: '良形',
                                      falseText: '愚形',
                                      toggleLabelStyle: toggleLabelStyle,
                                      fontRatio: fontRatio,
                                      width: toggleWidth,
                                      isDarkMode: isDarkMode,
                                      onExplanationTap: () => _showExplanationDialog('自身の待ち'),
                                    ),
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // プレイヤーを選択
  void _selectPlayer(String name) {
    // 既に選択されているプレイヤーなら何もしない
    if (selectedPlayer == name) return;

    // プレイヤー選択の効果音を再生
    SettingsService().playSound('mouta');
    
    setState(() {
      selectedPlayer = name;
      
      // タップ効果のアニメーション - より緩やかに
      _animationController.reset();
      
      // アニメーションの開始値を0ではなく、0.5から始めることで
      // フェードアウト→フェードインの激しさを抑える
      _animationController.value = 0.5;
      _animationController.forward();
    });
  }
  
  // 説明ダイアログを表示
  void _showExplanationDialog(String term, {String area = ''}) {
    // ヘルプを開く効果音を再生
    SettingsService().playSound('helpon');
    
    // 現在のテーマモードを取得
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 用語ごとの説明文を定義
    Map<String, String> explanations = {
      '通った筋': '既に通った筋の本数です。筋カウント理論の要！！',
      '残り筋': 'まだ通ってない筋の本数です。少なくなるほど危険！！',
      '放銃率': '相手が両面待ちだった場合、通ってない筋を打った際に相手に和了される確率です。',
      '要求打点': '現状の放銃危険度に対して、押して勝負するために最低限必要な和了点です。',
      '局収支差': '要求打点での和了時打点期待打点と、ベタオリ時の局収支とイコールになる打点Xの和了時打点期待値との差です。この値が大きいほど、要求打点を基準とした押しの価値が高まります。',
      '片スジ': '片方が筋となっている牌です。例）2索が通っているときの5索は片スジです',
      '両無スジ': '両方とも筋になっていない牌です。4・5・6の牌でどちら側も通っていなければ、これ。',
      '勝負牌': '押したい瞬間が一発だったり、押したい牌がドラだったりする場合には、このトグルボタンをONにしましょう。',
      '自身の待ち': '両面以上の待ちを「良形」とし、それ以外の待ちを「愚形」とします。',
    };

    // デフォルトの説明文
    String explanation = explanations[term] ?? 'この項目の説明はまだ用意されていません。';

    // 局収支差の場合はエリアに応じたデータを表示
    if (term == '局収支差' && selectedPlayer != '自家') {
      // 選択中のプレイヤーのデータを取得
      Map<String, dynamic> playerData = _calculationManager.getPlayerDisplayData(selectedPlayer);
      
      if (playerData['isCalculated']) {
        // 片スジデータの表示（片スジエリアからのタップの場合のみ）
        if (area == '片スジ') {
          final dynamic kataSujiData = playerData['kataSujiData'];
          
          if (kataSujiData != null) {
            final dynamic requiredPoints = kataSujiData['requiredPoints'];
            final int bBalanceIncome = kataSujiData['bBalanceIncome'] ?? 0;
            final dynamic pointDiff = kataSujiData['pointDiff'];
            
            if (requiredPoints != '-' && pointDiff.toString() != '-') {
              final int expectedValue = bBalanceIncome + (pointDiff is int ? pointDiff : 0);
              
              explanation += '\n\n現在の状況【片スジ】：\n\n';
              explanation += '・要求打点（$requiredPoints点）の和了時打点期待値: $expectedValue\n';
              explanation += '・ベタオリ均衡打点期待値: $bBalanceIncome\n';
              explanation += '・局収支差: $pointDiff';
            }
          }
        }
        
        // 両無スジデータの表示（両無スジエリアからのタップの場合のみ）
        if (area == '両無スジ') {
          final dynamic ryouNashiData = playerData['ryouNashiData'];
          
          if (ryouNashiData != null) {
            final dynamic requiredPoints = ryouNashiData['requiredPoints'];
            final int bBalanceIncome = ryouNashiData['bBalanceIncome'] ?? 0;
            final dynamic pointDiff = ryouNashiData['pointDiff'];
            
            if (requiredPoints != '-' && pointDiff.toString() != '-') {
              final int expectedValue = bBalanceIncome + (pointDiff is int ? pointDiff : 0);
              
              explanation += '\n\n現在の状況【両無スジ】：\n\n';
              explanation += '・要求打点（$requiredPoints点）の和了時打点期待値: $expectedValue\n';
              explanation += '・ベタオリ均衡打点期待値: $bBalanceIncome\n';
              explanation += '・局収支差: $pointDiff';
            }
          }
        }
      }
    }

    // ダイアログを閉じる関数
    void closeDialog() {
      SettingsService().playSound('helpoff');
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          // 戻るボタンの処理
          onWillPop: () async {
            SettingsService().playSound('helpoff');
            return true; // ダイアログを閉じることを許可
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                  ? const Color(0xFF1A1A2E)
                  : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                    ? Colors.blue.withOpacity(0.3)
                    : Color(0xFF1976D2).withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    term,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.blue : Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        explanation,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Color(0xFF212121),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: closeDialog, // 閉じるボタンに関数を設定
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: isDarkMode 
                        ? Colors.blue.withOpacity(0.7) 
                        : Color(0xFF1976D2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('閉じる'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // カウントを増やす
  void _incrementCount(String playerName) {
    setState(() {
      _calculationManager.incrementCount(playerName);
      selectedPlayer = playerName;
      
      // カウント効果音を再生
      SettingsService().playSound('count');
    });
  }
  
  // カウントをリセット
  void _resetCount(String playerName) {
    setState(() {
      _calculationManager.resetPlayer(playerName);
      
      // キャンセル効果音を再生
      SettingsService().playSound('cancel');
    });
  }
  
  // すべてリセット
  void _resetAll() {
    setState(() {
      _calculationManager.resetAll();
      
      // キャンセル効果音を再生
      SettingsService().playSound('cancel');
    });
  }
  
  // 親/子状態の切り替え
  void _toggleParent(String playerName, bool isParent) {
    setState(() {
      _calculationManager.toggleParent(playerName, isParent);
      
      // スイッチ効果音を再生
      SettingsService().playSound('switch');
    });
  }
}