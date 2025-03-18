// lib/services/premium_service.dart
import 'package:shared_preferences/shared_preferences.dart';

/// プレミアム機能（広告非表示）を管理するサービス
class PremiumService {
  // シングルトンパターン
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  
  // SharedPreferencesのキー
  static const String _keyIsPremium = 'is_premium_user';
  
  // プレミアムステータス
  bool _isPremium = false;
  
  // リスナー
  final List<Function(bool)> _listeners = [];
  
  // ゲッター
  bool get isPremium => _isPremium;
  
  PremiumService._internal();
  
  // 初期化
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_keyIsPremium) ?? false;
  }
  
  // プレミアム状態の切り替え
  Future<void> togglePremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = !_isPremium;
    await prefs.setBool(_keyIsPremium, _isPremium);
    
    // リスナーに通知
    _notifyListeners();
  }
  
  // リスナーの追加
  void addListener(Function(bool) listener) {
    _listeners.add(listener);
  }
  
  // リスナーの削除
  void removeListener(Function(bool) listener) {
    _listeners.remove(listener);
  }
  
  // リスナーへの通知
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_isPremium);
    }
  }
}