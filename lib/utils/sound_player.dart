// lib/utils/sound_player.dart

import 'package:audioplayers/audioplayers.dart';

/// 短い効果音を低レイテンシ＆一定音量で再生するユーティリティ
class SoundPlayer {
  // シングルトン
  static final SoundPlayer _instance = SoundPlayer._internal();
  factory SoundPlayer() => _instance;
  SoundPlayer._internal();

  final Map<String, AudioPool> _pools = {};
  double _volume = 0.7;

  /// 一度だけ呼び出して、効果音をプリロード
  /// names は assets/sounds/ 以下のファイル名（拡張子なし）
  Future<void> preload(List<String> names) async {
    for (final name in names) {
      if (_pools.containsKey(name)) continue;
      final pool = await AudioPool.createFromAsset(
        path: 'sounds/$name.mp3',  // ← 修正！
        maxPlayers: 3,
      );
      _pools[name] = pool;
    }
  }

  /// 再生
  Future<void> play(String name) async {
    final pool = _pools[name];
    if (pool == null) {
      print('SoundPlayer: 未プリロードのサウンド: $name');
      return;
    }
    await pool.start(volume: _volume);
  }

  /// 音量更新 (0.0～1.0)
  void setVolume(double v) {
    _volume = v.clamp(0.0, 1.0);
  }

  /// リソース解放
  Future<void> release() async {
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _pools.clear();
  }
}
