// lib/services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/sound_player.dart';

class SettingsService {
  // キー定数
  static const String keyEffectVolume = 'effect_volume';
  static const String keyBgmVolume = 'bgm_volume';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyPremiumStatus = 'premium_status';
  
  // シングルトンパターン
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();
  
  // 設定のデフォルト値
  double _effectVolume = 0.7;
  double _bgmVolume = 0.5;
  bool _isDarkMode = true; // デフォルトはダークモード
  bool _isPremium = false;
  
  // テーマ変更リスナー
  final List<Function()> _themeChangeListeners = [];
  
  // ゲッター
  double get effectVolume => _effectVolume;
  double get bgmVolume => _bgmVolume;
  bool get isDarkMode => _isDarkMode;
  bool get isPremium => _isPremium;
  
  // サウンドプレイヤーを取得するためのゲッター
  SoundPlayer get soundPlayer => SoundPlayer();
  
  // 初期化 - アプリ起動時に呼び出す
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 保存された設定を読み込む（なければデフォルト値を使用）
    _effectVolume = prefs.getDouble(keyEffectVolume) ?? 0.7;
    _bgmVolume = prefs.getDouble(keyBgmVolume) ?? 0.5;
    _isDarkMode = prefs.getBool(keyIsDarkMode) ?? true;
    _isPremium = prefs.getBool(keyPremiumStatus) ?? false;
    
    // サウンド設定を適用
    soundPlayer.toggleSound(_effectVolume > 0);
    soundPlayer.setVolume(_effectVolume);
    
    // 効果音を事前ロード
    await soundPlayer.preloadSounds();
  }
  
  // 効果音の音量設定
  Future<void> setEffectVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyEffectVolume, volume);
    _effectVolume = volume;
    
    // サウンドプレイヤーに音量を適用
    await soundPlayer.setVolume(volume);
    
    // サウンド有効・無効の処理
    if (volume > 0) {
      soundPlayer.toggleSound(true);
    } else {
      soundPlayer.toggleSound(false);
    }
  }
  
  // BGMの音量設定
  Future<void> setBgmVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyBgmVolume, volume);
    _bgmVolume = volume;
    
    // BGM機能は将来的に実装
  }
  
  // ダークモード設定
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsDarkMode, isDark);
    _isDarkMode = isDark;
    
    // テーマ変更通知
    _notifyThemeChanged();
  }
  
  // プレミアムステータス設定
  Future<void> setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPremiumStatus, isPremium);
    _isPremium = isPremium;
  }
  
  // 簡単にサウンドを再生するためのヘルパーメソッド
  void playSound(String soundName) {
    // 効果音がオンの場合のみ再生
    if (_effectVolume > 0) {
      soundPlayer.playSound(soundName);
    }
  }
  
  // テーマ変更リスナーの追加
  void addThemeChangeListener(Function() listener) {
    _themeChangeListeners.add(listener);
  }
  
  // テーマ変更リスナーの削除
  void removeThemeChangeListener(Function() listener) {
    _themeChangeListeners.remove(listener);
  }
  
  // テーマ変更通知
  void _notifyThemeChanged() {
    for (var listener in _themeChangeListeners) {
      listener();
    }
  }
}