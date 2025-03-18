// lib/utils/sound_player.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SoundPlayer {
  static final SoundPlayer _instance = SoundPlayer._internal();
  
  // 複数の効果音に対応するためのプレイヤー管理
  final Map<String, AudioPlayer> _audioPlayers = {};
  
  // Web環境用のシンプルプレイヤー
  final AudioPlayer _webPlayer = AudioPlayer();
  
  // オーディオ設定
  bool _soundEnabled = true;
  double _volume = 0.7; // デフォルト音量
  bool _isInitialized = false;

  // シングルトンパターン
  factory SoundPlayer() {
    return _instance;
  }

  SoundPlayer._internal();
  
  // アプリ起動時の初期化処理
  Future<void> preloadSounds() async {
    // Web環境では何もしない
    if (kIsWeb) {
      print('Web環境: 効果音のプリロードをスキップします');
      return;
    }
    
    if (_isInitialized) return; // 既に初期化済み
    
    // プレイヤーの作成
    final commonSounds = ['menu', 'setting', 'click', 'count', 'cancel', 'switch', 'helpon', 'helpoff', 'mouta', 'type'];
    for (final sound in commonSounds) {
      _audioPlayers[sound] = AudioPlayer();
    }
    
    // 実機環境のみで初期化を実行
    try {
      print('実機環境: 効果音エンジンを初期化します');
      
      // まず一つのサウンドで初期化
      final initialPlayer = _audioPlayers['menu'] ?? AudioPlayer();
      await initialPlayer.setVolume(0.01);
      await initialPlayer.play(AssetSource('sounds/menu.mp3'));
      await initialPlayer.stop();
      await initialPlayer.setVolume(_volume);
      
      _isInitialized = true;
      print('実機環境: 効果音エンジンの初期化が完了しました');
    } catch (e) {
      print('効果音エンジンの初期化に失敗しました: $e');
    }
  }

  // 効果音を再生
  Future<void> playSound(String soundName) async {
    if (!_soundEnabled) return;
    
    try {
      if (kIsWeb) {
        // Web環境ではシンプルに再生を試みるのみ
        try {
          await _webPlayer.stop();
          await _webPlayer.setVolume(_volume);
          await _webPlayer.play(AssetSource('sounds/$soundName.mp3'));
        } catch (e) {
          // Web環境でのエラーは静かに無視（コンソールには出力）
          print('Web環境: 効果音再生エラー（実機では正常に動作します）: $e');
        }
      } else {
        // 実機環境では複数のプレイヤーを使用
        
        // プレイヤーがなければ作成
        if (!_audioPlayers.containsKey(soundName)) {
          _audioPlayers[soundName] = AudioPlayer();
        }
        
        // 通常通り再生
        final player = _audioPlayers[soundName]!;
        
        // 既に再生中のプレイヤーなら一度停止
        if (player.state == PlayerState.playing) {
          await player.stop();
        }
        
        // 音量を設定してから再生
        await player.setVolume(_volume);
        await player.play(AssetSource('sounds/$soundName.mp3'));
      }
    } catch (e) {
      print('音声の再生に失敗しました: $e');
    }
  }

  // 音量設定
  Future<void> setVolume(double volume) async {
    if (volume < 0) volume = 0;
    if (volume > 1) volume = 1;
    
    _volume = volume;
    
    // 音がオフの場合は有効化
    if (volume > 0 && !_soundEnabled) {
      _soundEnabled = true;
    }
    // 音量が0の場合は無効化
    else if (volume == 0 && _soundEnabled) {
      _soundEnabled = false;
    }
    
    // 現在再生中のプレイヤーに音量を適用
    if (!kIsWeb) {
      for (final player in _audioPlayers.values) {
        if (player.state == PlayerState.playing) {
          await player.setVolume(_volume);
        }
      }
    } else if (_webPlayer.state == PlayerState.playing) {
      await _webPlayer.setVolume(_volume);
    }
  }

  // 音の有効/無効を切り替え
  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
    
    // 再生中のサウンドを停止
    if (!enabled) {
      for (final player in _audioPlayers.values) {
        player.stop();
      }
      if (kIsWeb) _webPlayer.stop();
    }
  }

  // 音が有効かどうかを取得
  bool get isSoundEnabled => _soundEnabled;
  
  // 現在の音量を取得
  double get volume => _volume;
  
  // リソースの解放
  void dispose() {
    for (final player in _audioPlayers.values) {
      player.dispose();
    }
    _audioPlayers.clear();
    _webPlayer.dispose();
    _isInitialized = false;
  }
}