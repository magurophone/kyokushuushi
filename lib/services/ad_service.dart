// lib/services/ad_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  
  // テスト用広告ID
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  // 本番用広告ID
  static const String _liveInterstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  
  // デバッグモードではテスト広告、リリースモードでは本番広告を使用
  String get interstitialAdUnitId => 
    kDebugMode ? _testInterstitialAdUnitId : _liveInterstitialAdUnitId;
    
  // インタースティシャル広告
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  DateTime? _lastAdShownTime;
  
  // 5分間隔を定義 (5分 = 300秒)
  static const int _adIntervalSeconds = 300;
  
  // 定期的な広告表示用タイマー
  Timer? _periodicAdTimer;
  
  // シングルトンパターン
  factory AdService() {
    return _instance;
  }
  
  AdService._internal() {
    // Web環境では広告を初期化しない
    if (!kIsWeb) {
      // 初期化時に最初の広告をロード
      _loadInterstitialAd();
    } else {
      print('Web環境では広告機能は無効です');
    }
  }
  
  // インタースティシャル広告のロード
  void _loadInterstitialAd() {
    // Web環境では何もしない
    if (kIsWeb) return;
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          // 広告クローズ時のコールバック
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _isInterstitialAdReady = false;
              ad.dispose();
              _loadInterstitialAd(); // 次の広告を事前にロード
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isInterstitialAdReady = false;
              ad.dispose();
              _loadInterstitialAd(); // エラー発生時も次の広告をロード
            },
          );
          
          print('インタースティシャル広告がロードされました');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
          print('インタースティシャル広告のロードに失敗: $error');
          
          // 少し待ってから再ロード
          Future.delayed(const Duration(minutes: 1), _loadInterstitialAd);
        },
      ),
    );
  }
  
  // 広告を表示するメソッド
  Future<bool> showInterstitialAd() async {
    // Web環境では広告を表示しない
    if (kIsWeb) {
      print('Web環境では広告は表示されません');
      return false;
    }
    
    // 前回の広告表示からの経過時間をチェック
    if (_lastAdShownTime != null) {
      final currentTime = DateTime.now();
      final difference = currentTime.difference(_lastAdShownTime!).inSeconds;
      
      // 5分経過していない場合は広告を表示しない
      if (difference < _adIntervalSeconds) {
        print('前回の広告から5分経過していないため、広告を表示しません');
        return false;
      }
    }
    
    // 広告がロードされていない場合
    if (_interstitialAd == null || !_isInterstitialAdReady) {
      print('広告の準備ができていないため、表示できません');
      _loadInterstitialAd(); // 念のため再ロード
      return false;
    }
    
    // 広告を表示
    await _interstitialAd!.show();
    _lastAdShownTime = DateTime.now();
    _isInterstitialAdReady = false;
    
    return true;
  }
  
  // 定期的な広告表示を開始（初回も表示）
  void startPeriodicAds() {
    // Web環境では何もしない
    if (kIsWeb) {
      print('Web環境では定期広告は表示されません');
      return;
    }
    
    // 初回広告表示
    showInterstitialAd();
    
    // すでにタイマーが動いていれば一旦停止
    stopPeriodicAds();
    
    // 5分（300秒）ごとに広告表示を試行
    _periodicAdTimer = Timer.periodic(const Duration(seconds: 300), (timer) {
      showInterstitialAd();
    });
    
    print('定期的な広告表示を開始しました');
  }
  
  // 定期的な広告表示を停止
  void stopPeriodicAds() {
    // Web環境では何もしない
    if (kIsWeb) return;
    
    _periodicAdTimer?.cancel();
    _periodicAdTimer = null;
    print('定期的な広告表示を停止しました');
  }
  
  // リソースの解放
  void dispose() {
    // Web環境では何もしない
    if (kIsWeb) return;
    
    _interstitialAd?.dispose();
    stopPeriodicAds();
  }
}