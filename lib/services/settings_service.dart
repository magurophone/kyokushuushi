// lib/services/settings_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/sound_player.dart';

/// アプリ共通の設定管理サービス
class SettingsService {
  // ─── シングルトン実装 ───
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // ─── SharedPreferences のキー定数 ───
  static const String _keyEffectVolume = 'effect_volume';
  static const String _keyDarkMode     = 'is_dark_mode';

  // ─── プリロードする効果音リスト ───
  static const List<String> _effectNames = [
    'menu', 'setting', 'count', 'cancel',
    'switch', 'helpon', 'helpoff', 'mouta', 'type'
  ];

  // ─── 内部ステート ───
  double _effectVolume = 0.7;
  bool   _isDarkMode   = true;

  // ─── テーマ変更リスナー一覧 ───
  final List<VoidCallback> _themeListeners = [];

  /// 効果音プレイヤーへのショートカット
  SoundPlayer get soundPlayer => SoundPlayer();

  // ─── ゲッター ───
  double get effectVolume => _effectVolume;
  bool   get isDarkMode   => _isDarkMode;

  /// アプリ起動時に一度だけ呼び出す初期化処理
  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 保存された音量とダークモード設定を読み込む
    _effectVolume = prefs.getDouble(_keyEffectVolume) ?? 0.7;
    _isDarkMode   = prefs.getBool(_keyDarkMode)       ?? true;

    // 効果音をプリロードしておく
    await soundPlayer.preload(_effectNames);
    // プリロード後に必ず音量を適用
    soundPlayer.setVolume(_effectVolume);

    // 起動時にテーマ状態を通知
    _notifyThemeChanged();
  }

  /// 効果音を再生（外部から呼ぶ）
  void playSound(String name) {
    if (_effectVolume <= 0) return;
    soundPlayer.play(name);
  }

  /// 効果音の音量を変更し保存
  Future<void> setEffectVolume(double v) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyEffectVolume, v);
    _effectVolume = v;
    soundPlayer.setVolume(v);
  }

  /// ダークモード設定を変更し保存
  Future<void> setDarkMode(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
    _isDarkMode = isDark;
    _notifyThemeChanged();
  }

  /// テーマ変更リスナーを追加
  void addThemeChangeListener(VoidCallback listener) {
    _themeListeners.add(listener);
  }

  /// テーマ変更リスナーを削除
  void removeThemeChangeListener(VoidCallback listener) {
    _themeListeners.remove(listener);
  }

  /// テーマ変更をリスナーに通知
  void _notifyThemeChanged() {
    for (final listener in List<VoidCallback>.from(_themeListeners)) {
      listener();
    }
  }
}
