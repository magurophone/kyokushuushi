// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'four_player_screen.dart';
import '../utils/noise_texture_util.dart';
import '../services/settings_service.dart';
import '../utils/custom_page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'settings_screen.dart';
import '../services/ad_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  
  // アニメーションテキスト関連
  final String _fullText = '勝負牌の押し引きをサポート';
  String _displayText = '';
  List<double> _charOffsets = [];
  List<double> _charOpacities = [];
  Timer? _textAnimationTimer;
  
  @override
  void initState() {
    super.initState();
    
    // メインアニメーションコントローラー
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    
    // テキストアニメーションの準備
    _prepareTextAnimation();
    
    // モダンなテキストアニメーションを開始
    _startModernTextAnimation();
  }
  
  // アニメーションの準備
  void _prepareTextAnimation() {
    // 各文字の初期オフセットと不透明度を設定
    _charOffsets = List.generate(
      _fullText.length,
      (_) => 20.0 + Random().nextDouble() * 30.0
    );
    
    _charOpacities = List.generate(
      _fullText.length,
      (_) => 0.0
    );
  }
  
  // モダンなテキストアニメーションを開始
  void _startModernTextAnimation() {
    // 効果音を再生（実機のみ）
    if (!kIsWeb) {
      SettingsService().playSound('type');
    }
    
    int charIndex = 0;
    
    _textAnimationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (charIndex < _fullText.length) {
        setState(() {
          // テキストを1文字追加
          _displayText = _fullText.substring(0, charIndex + 1);
          
          // アニメーション中の文字を設定
          _charOpacities[charIndex] = 1.0;
          
          // アニメーション効果のため、現在の文字のオフセットを徐々に0に近づける
          for (int i = 0; i <= charIndex; i++) {
            // より緩やかな減衰を適用
            _charOffsets[i] *= 0.7;
            if (_charOffsets[i] < 0.5) _charOffsets[i] = 0.0;
          }
        });
        
        charIndex++;
      } else {
        timer.cancel();
        
        // すべての文字が表示されたら、ゆっくりと自然に整列させる
        // 急激な「ギュン」を避けるため、複数のステップで徐々に整える
        _smoothFinishAnimation();
      }
    });
  }
  
  // アニメーション終了時の滑らかな整列
  void _smoothFinishAnimation() {
    // 3段階に分けて徐々に整える
    for (int step = 0; step < 3; step++) {
      Future.delayed(Duration(milliseconds: 80 * (step + 1)), () {
        if (mounted) {
          setState(() {
            for (int i = 0; i < _charOffsets.length; i++) {
              // 段階的に減衰率を下げる（より滑らかに）
              double decayFactor = 0.5 - (step * 0.15);
              _charOffsets[i] *= decayFactor;
              
              // 最終ステップでは完全に0に設定
              if (step == 2 || _charOffsets[i] < 0.2) {
                _charOffsets[i] = 0.0;
              }
              
              _charOpacities[i] = 1.0;
            }
          });
        }
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationTimer?.cancel();
    super.dispose();
  }

  // メイン画面への遷移（広告なし）
  void _navigateToMainScreen() {
    // メニュー決定音を再生
    SettingsService().playSound('menu');
    
    // 効果音が少し流れてから画面遷移するように少し待機
    Future.delayed(const Duration(milliseconds: 300), () {
      // 1.5秒のカスタムトランジションを使用
      Navigator.push(
        context,
        CustomPageTransition(
          page: const FourPlayerScreen(),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutCubic,
        ),
      );
    });
  }
  
  // タイトル用のTextStyle
  TextStyle _getTitleStyle() {
    // 現在のテーマに応じてテキストスタイルを調整
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextStyle(
      fontFamily: 'MPLUSRounded1c',
      fontSize: 42,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.blue.shade800,
      letterSpacing: 2.0,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: Colors.black38,
          offset: const Offset(2.0, 2.0),
        ),
      ],
    );
  }
  
  // サブタイトル用のTextStyle
  TextStyle _getSubtitleStyle() {
    // 現在のテーマに応じてテキストスタイルを調整
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextStyle(
      fontFamily: 'MPLUSRounded1c',
      fontSize: 16,
      color: isDarkMode ? Colors.white70 : Colors.blue.shade700,
    );
  }
  
  // スタートテキスト用のTextStyle
  TextStyle _getStartTextStyle() {
    // 現在のテーマに応じてテキストスタイルを調整
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextStyle(
      fontFamily: 'MPLUSRounded1c',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: isDarkMode ? Colors.white : Colors.blue.shade800,
      letterSpacing: 1.0,
    );
  }

  // モダンなテキストアニメーションウィジェット - シンプルなカラー
  Widget _buildModernTextAnimation() {
    // 現在のテーマに応じてテキストスタイルを調整
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      height: 24, // 高さを固定
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_displayText.length, (index) {
          // 各文字のスタイル - テーマに応じた色で
          final TextStyle charStyle = _getSubtitleStyle().copyWith(
            color: (isDarkMode ? Colors.white : Colors.blue.shade700).withOpacity(_charOpacities[index]),
          );
          
          // 各文字のアニメーション
          return Transform.translate(
            offset: Offset(0, _charOffsets[index]),
            child: Text(
              _displayText[index],
              style: charStyle,
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // グラデーションの色を定義
    final List<Color> gradientColors = isDarkMode
        ? [
            Colors.black,
            Color(0xFF0A0A14),
            Color(0xFF12121F),
            Color(0xFF15152A),
            const Color(0xFF1A1A2E),
          ]
        : [
            Colors.white,
            Colors.blue.shade50,
            Colors.blue.shade100,
            Colors.blue.shade200,
            Colors.blue.shade300,
          ];
    
    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToMainScreen,
        child: NoiseTextureUtil.buildNoiseBackground(
          colors: gradientColors,
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          noiseOpacity: isDarkMode ? 0.04 : 0.02, // ライトモードではノイズを少し薄く
          noisePixelDensity: 120,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
              child: Column(
                children: [
                  // 上部1/13 - 設定ボタン用エリア
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: isDarkMode ? Colors.white70 : Colors.blue.shade700,
                          size: 28,
                        ),
                        onPressed: () {
                          // 設定サウンド再生
                          SettingsService().playSound('setting');
                          
                          // 設定画面への遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // 下部12/13 - メインコンテンツ
                  Expanded(
                    flex: 12,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // アプリロゴ - 麻雀牌の画像を使用
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: (isDarkMode ? Colors.white : Colors.blue).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // 麻雀牌の「中」の画像を表示
                            child: Image.asset(
                              'assets/images/chun.png',
                              width: 160,
                              height: 220,
                              filterQuality: FilterQuality.high, // ここを追加
                              // ダークモードでは明るさを調整
                              color: isDarkMode ? Colors.white.withOpacity(0.95) : null,
                              colorBlendMode: isDarkMode ? BlendMode.modulate : null,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // アプリ名
                          Text(
                            '筋カウンターα',
                            style: _getTitleStyle(),
                          ),
                          
                          const SizedBox(height: 10),
                          
                          // サブタイトル - モダンなアニメーション
                          Center(child: _buildModernTextAnimation()),
                          
                          const SizedBox(height: 60),
                          
                          // タップでスタートのテキスト
                          AnimatedBuilder(
                            animation: _opacityAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: Text(
                                  'タップでスタート',
                                  style: _getStartTextStyle(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // バージョン情報 - 下部に追加
                  Text(
                    'version 1.0.0',
                    style: TextStyle(
                      fontFamily: 'MPLUSRounded1c',
                      fontSize: 12,
                      color: isDarkMode ? Colors.white38 : Colors.blue.shade300,
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
}