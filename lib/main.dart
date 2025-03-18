// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart'; // AdMobをインポート
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';
import 'services/ad_service.dart'; // 新しいAdServiceをインポート
import 'services/purchase_service.dart'; // 追加

void main() async {
  // Flutter初期化を確実に行う
  WidgetsFlutterBinding.ensureInitialized();
  
  // WebとそれIOS以外で処理を分ける
  if (!kIsWeb) {
    // Web以外のプラットフォームでのみAdMobを初期化
    await MobileAds.instance.initialize();
  }
  
  // 設定サービスの初期化
  await SettingsService().init();
  
  // 課金サービスの初期化
  await PurchaseService().init();
  
  // AdServiceのインスタンスを作成（Web環境では限定機能）
  AdService();
  
  // システムUIオーバーレイスタイルを設定
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // テーマモードの状態
  late bool _isDarkMode;
  
  @override
  void initState() {
    super.initState();
    // 初期テーマ設定を読み込み
    _isDarkMode = SettingsService().isDarkMode;
    
    // テーマ変更通知のリスナーを設定
    SettingsService().addThemeChangeListener(_updateTheme);
  }
  
  @override
  void dispose() {
    // リスナーを解除
    SettingsService().removeThemeChangeListener(_updateTheme);
    super.dispose();
  }
  
  // テーマ変更時のコールバック
  void _updateTheme() {
    setState(() {
      _isDarkMode = SettingsService().isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // システムのテキストスケーリングを無視して固定サイズにする
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        title: '筋カウンターα',
        debugShowCheckedModeBanner: false, // デバッグバナーを非表示
        
        // ダークテーマの設定
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.lightBlue,
            surface: Color(0xFF1F1F1F),
            background: Colors.black,
          ),
          fontFamily: 'MPLUSRounded1c', // アプリ全体のフォントを設定
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'MPLUSRounded1c',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // ライトテーマの設定
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D47A1), // 濃い青
            secondary: Color(0xFF1976D2), // ミディアム青
            surface: Colors.white,
            background: Color(0xFFF5F5F5), // 非常に薄いグレー
            onBackground: Color(0xFF212121), // 非常に濃いグレー (テキスト用)
            onSurface: Color(0xFF212121), // 非常に濃いグレー (テキスト用)
            onPrimary: Colors.white,
          ),
          fontFamily: 'MPLUSRounded1c',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFF1976D2), // ミディアム青
            foregroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'MPLUSRounded1c',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF212121)),
            bodyMedium: TextStyle(color: Color(0xFF212121)),
            bodySmall: TextStyle(color: Color(0xFF212121)),
            titleLarge: TextStyle(color: Color(0xFF212121)),
            titleMedium: TextStyle(color: Color(0xFF212121)),
            titleSmall: TextStyle(color: Color(0xFF212121)),
          ),
        ),
        
        // 現在のモードを設定
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        
        home: const SplashScreen(), // スプラッシュ画面から開始
      ),
    );
  }
}