// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob の初期化（Web ではスキップ）
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  // 設定サービスの初期化（効果音プリロード＋音量設定含む）
  await SettingsService().init();

  // 課金サービスの初期化
  await PurchaseService().init();

  // AdService のインスタンス作成（Web では限定動作）
  AdService();

  // システム UI オーバーレイスタイル設定
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
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // 保存されたテーマ設定を取得
    _isDarkMode = SettingsService().isDarkMode;
    // テーマ変更リスナーを登録
    SettingsService().addThemeChangeListener(_updateTheme);
  }

  @override
  void dispose() {
    // リスナー解除
    SettingsService().removeThemeChangeListener(_updateTheme);
    super.dispose();
  }

  void _updateTheme() {
    setState(() {
      _isDarkMode = SettingsService().isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // テキストスケールを固定
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        title: '筋カウンターα',
        debugShowCheckedModeBanner: false,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

        // ライトテーマ
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D47A1),
            secondary: Color(0xFF1976D2),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
            onBackground: Color(0xFF212121),
            onSurface: Color(0xFF212121),
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
            backgroundColor: Color(0xFF1976D2),
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

        // ダークテーマ
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.lightBlue,
            surface: Color(0xFF1F1F1F),
            background: Colors.black,
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

        home: const SplashScreen(),
      ),
    );
  }
}
