// lib/screens/purchase_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../services/purchase_service.dart';
import '../services/settings_service.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  PurchaseScreenState createState() => PurchaseScreenState();
}

class PurchaseScreenState extends State<PurchaseScreen> {
  final PurchaseService _purchaseService = PurchaseService();
  final SettingsService _settingsService = SettingsService();
  
  bool _isPremium = false;
  bool _isLoading = false;
  String _statusMessage = '';
  
  @override
  void initState() {
    super.initState();
    _isPremium = _purchaseService.isPremium;
    _isLoading = _purchaseService.isLoading;
    
    // 購入状態監視
    _purchaseService.addStatusListener(_onPurchaseStatusChanged);
    
    // 初期化を確認
    _checkInitialization();
  }
  
  // 初期化状態を確認
  Future<void> _checkInitialization() async {
    if (!_purchaseService.isInitialized) {
      setState(() {
        _isLoading = true;
        _statusMessage = '課金システムを初期化中...';
      });
      
      await _purchaseService.initialized;
      
      if (mounted) {
        setState(() {
          _isLoading = _purchaseService.isLoading;
          _isPremium = _purchaseService.isPremium;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _purchaseService.removeStatusListener(_onPurchaseStatusChanged);
    super.dispose();
  }
  
  // 購入状態変更ハンドラ
  void _onPurchaseStatusChanged(PurchaseStatus status, String message) {
    if (!mounted) return;
    
    setState(() {
      _isLoading = _purchaseService.isLoading;
      _isPremium = _purchaseService.isPremium;
      _statusMessage = message;
    });
    
    if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
      // 購入成功時はスナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // 少し待ってから前の画面に戻る
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    } else if (status == PurchaseStatus.error) {
      // エラー時はスナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアム機能'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // メインコンテンツ
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ヘッダー
                const Icon(
                  Icons.star,
                  size: 64,
                  color: Color(0xFFFFD700), // ゴールド
                ),
                const SizedBox(height: 20),
                const Text(
                  '広告非表示機能',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _isPremium 
                      ? '現在、広告非表示機能が有効です' 
                      : '広告なしで快適に使おう',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isPremium ? Colors.green : Colors.grey,
                    fontWeight: _isPremium ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // ステータスメッセージ
                if (_statusMessage.isNotEmpty && _isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // 購入ボタン
                if (!_isPremium)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handlePurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '広告を削除する ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getPriceDisplay(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                
                // リストアボタン
                if (!_isPremium)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleRestore,
                      child: const Text(
                        '以前の購入を復元',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                
                // 購入済みの場合は戻るボタン
                if (_isPremium)
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '戻る',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // テスト用ボタン (デバッグモードのみ)
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _toggleTestPurchase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(
                        _isPremium ? 'テスト：広告を表示する' : 'テスト：広告を非表示にする',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          // ローディングオーバーレイ
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
  
  // 購入ハンドラ
  Future<void> _handlePurchase() async {
    // 効果音再生
    _settingsService.playSound('menu');
    
    setState(() {
      _isLoading = true;
      _statusMessage = '購入処理中...';
    });
    
    try {
      await _purchaseService.purchasePremium();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'エラーが発生しました: $e';
      });
    }
  }
  
  // 復元ハンドラ
  Future<void> _handleRestore() async {
    // 効果音再生
    _settingsService.playSound('switch');
    
    setState(() {
      _isLoading = true;
      _statusMessage = '購入履歴を復元中...';
    });
    
    try {
      await _purchaseService.restorePurchases();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'エラーが発生しました: $e';
      });
    }
  }
  
  // テスト購入ハンドラ
  Future<void> _toggleTestPurchase() async {
    // 効果音再生
    _settingsService.playSound('switch');
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'テスト購入処理中...';
    });
    
    try {
      await _purchaseService.togglePremiumStatus();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'エラーが発生しました: $e';
      });
    }
  }
  
  // 価格表示の取得
  String _getPriceDisplay() {
    // 商品情報がある場合は実際の価格を表示
    if (_purchaseService.premiumProduct != null) {
      return _purchaseService.premiumProduct!.price;
    }
    
    // デフォルト価格
    return '(¥240)';
  }
}