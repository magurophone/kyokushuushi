// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'menu_screen.dart';
import '../utils/noise_texture_util.dart';
import '../services/settings_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _loadingText = "loading";
  int _dotCount = 0;
  Timer? _loadingTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    
    // ローディングテキストのアニメーション
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
        _loadingText = "loading${".".replaceAll(".", "").padRight(_dotCount, '.')}";
      });
    });
    
    // 起動時に行う初期化処理
    _initializeApp();
  }
  
  // アプリの初期化処理を行う
  Future<void> _initializeApp() async {
    try {
      // 最低表示時間用の変数（スプラッシュ画面を少なくともこの時間は表示する）
      final minimumSplashDuration = Duration(seconds: 2);
      final startTime = DateTime.now();
      
      // 設定サービスを初期化（効果音の事前ロードを含む）
      await SettingsService().init();
      
      // その他の初期化処理があればここに追加
      
      // 初期化処理にかかった時間を計算
      final elapsedTime = DateTime.now().difference(startTime);
      
      // 最低表示時間に達していない場合は残りの時間だけ待機
      final remainingTime = elapsedTime < minimumSplashDuration
          ? minimumSplashDuration - elapsedTime
          : Duration.zero;
      
      // 初期化完了後、最低表示時間を確保してからメニュー画面に遷移
      if (mounted) {
        _navigationTimer = Timer(remainingTime, () {
          if (mounted) {
            print('初期化が完了しました。メニュー画面に遷移します。');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          }
        });
      }
    } catch (e) {
      print('アプリの初期化中にエラーが発生しました: $e');
      
      // 最低でも2秒は表示してからメニュー画面に遷移
      if (mounted) {
        _navigationTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            print('初期化中にエラーが発生しましたが、メニュー画面に遷移します。');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          }
        });
      }
    }
  }
  
  @override
  void dispose() {
    _loadingTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Colors.blue.shade300,
            Colors.blue.shade400,
            Colors.blue.shade500,
            Colors.blue.shade600,
            Colors.blue.shade700,
          ];
    
    return Scaffold(
      body: NoiseTextureUtil.buildNoiseBackground(
        colors: gradientColors,
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        noiseOpacity: 0.04, // ノイズの不透明度を調整
        noisePixelDensity: 120, // ノイズの密度を調整
        child: Center(
          child: Text(
            _loadingText,
            style: const TextStyle(
              fontFamily: 'MPLUSRounded1c',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}