// lib/services/purchase_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PurchaseStatus {
  purchased,
  pending,
  error,
  restored,
  notPurchased,
}

class PurchaseService {
  // シングルトンパターン
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  
  // 商品ID
  static const String _premiumProductId = 'com.example.kyokushuushi.premium';
  static const String _keyIsPremium = 'is_premium_user';
  
  // プレミアム状態
  bool _isPremium = false;
  bool get isPremium => _isPremium;
  
  // アプリ内課金インスタンス
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  // 商品情報
  List<ProductDetails> _products = [];
  ProductDetails? get premiumProduct => 
      _products.isNotEmpty ? _products.first : null;
  
  // 購入中フラグ
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // 購入ストリーム購読
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  // 初期化完了フラグ
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  // 初期化完了通知
  final Completer<bool> _initializedCompleter = Completer<bool>();
  Future<bool> get initialized => _initializedCompleter.future;
  
  // ステータス通知リスナー
  final List<Function(PurchaseStatus, String)> _statusListeners = [];
  
  PurchaseService._internal();
  
  // 初期化
  Future<void> init() async {
    // Web環境またはすでに初期化済みの場合はスキップ
    if (kIsWeb || _isInitialized) {
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.complete(false);
      }
      return;
    }
    
    try {
      // SharedPreferencesからプレミアム状態を取得
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool(_keyIsPremium) ?? false;
      
      // アプリ内課金が利用可能か確認
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        // 利用不可の場合は初期化完了とする
        if (!_initializedCompleter.isCompleted) {
          _initializedCompleter.complete(false);
        }
        _notifyStatusChange(PurchaseStatus.error, '課金システムが利用できません');
        return;
      }
      
// Android固有の設定
if (Platform.isAndroid) {
  // enablePendingPurchasesメソッドは現在のAPIでは存在しない可能性があるため、
  // この部分をコメントアウトします。最新バージョンのin_app_purchaseでは
  // デフォルトで有効になっている場合があります。
  
  // 古いバージョンと新しいバージョンの両方に対応する方法
  try {
    final InAppPurchaseAndroidPlatformAddition androidAddition = 
        _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    
    // メソッドが存在するかどうかをチェック（リフレクションなどを使用）
    // もし必要なら実行
    // androidAddition.enablePendingPurchases();
    
    // あるいは代替メソッドがあれば、それを使用
    print('Android IAP initialized');
  } catch (e) {
    print('Android IAP initialization: $e');
    // エラーを無視して続行
  }
}
      // 過去の購入を復元チェック（非消費型アイテムの場合）
      await _restorePurchases();
      
      // 商品情報を取得
      await _loadProducts();
      
      // 購入イベント購読
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: _updateStreamOnDone,
        onError: _handleError,
      );
      
      _isInitialized = true;
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.complete(true);
      }
    } catch (e) {
      print('購入サービス初期化エラー: $e');
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.complete(false);
      }
      _notifyStatusChange(PurchaseStatus.error, 'システムエラー: $e');
    }
  }
  
  // 商品情報の取得
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails({_premiumProductId});
      
      if (response.error != null) {
        _notifyStatusChange(PurchaseStatus.error, '商品情報の取得に失敗しました: ${response.error}');
        return;
      }
      
      if (response.productDetails.isEmpty) {
        _notifyStatusChange(PurchaseStatus.error, '広告非表示オプションが見つかりません');
        return;
      }
      
      _products = response.productDetails;
    } catch (e) {
      _notifyStatusChange(PurchaseStatus.error, '商品情報の取得中にエラーが発生しました: $e');
    }
  }
  
  // 購入実行
  Future<bool> purchasePremium() async {
    if (kIsWeb) {
      return false; // Web環境では購入不可
    }
    
    if (!_isInitialized) {
      _notifyStatusChange(PurchaseStatus.error, '課金システムが初期化されていません');
      return false;
    }
    
    if (_isPremium) {
      _notifyStatusChange(PurchaseStatus.purchased, '既にプレミアム会員です');
      return true;
    }
    
    if (_products.isEmpty) {
      await _loadProducts(); // 商品情報の再取得
      if (_products.isEmpty) {
        _notifyStatusChange(PurchaseStatus.error, '商品情報が見つかりません');
        return false;
      }
    }
    
    try {
      _isLoading = true;
      _notifyStatusChange(PurchaseStatus.pending, '購入処理中...');
      
      // 購入リクエスト作成
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first,
        applicationUserName: null,
      );
      
      // 非消費型アイテムとして購入
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      // 購入成功はストリームから通知される
      return true;
    } catch (e) {
      _isLoading = false;
      _notifyStatusChange(PurchaseStatus.error, '購入処理中にエラーが発生しました: $e');
      return false;
    }
  }
  
  // 購入復元
  Future<bool> restorePurchases() async {
    if (kIsWeb) {
      return false; // Web環境では復元不可
    }
    
    if (!_isInitialized) {
      _notifyStatusChange(PurchaseStatus.error, '課金システムが初期化されていません');
      return false;
    }
    
    try {
      _isLoading = true;
      _notifyStatusChange(PurchaseStatus.pending, '購入情報を復元中...');
      
      // 購入履歴を復元
      await _inAppPurchase.restorePurchases();
      
      // 復元結果はストリームから通知される
      return true;
    } catch (e) {
      _isLoading = false;
      _notifyStatusChange(PurchaseStatus.error, '購入情報の復元中にエラーが発生しました: $e');
      return false;
    }
  }
  
  // 初期化時の購入復元確認
  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      print('自動購入復元エラー: $e');
    }
  }
  
  // 購入処理結果ハンドラ
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == _premiumProductId) {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          // 購入待機中
          _notifyStatusChange(PurchaseStatus.pending, '購入処理中...');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                  purchaseDetails.status == PurchaseStatus.restored) {
          // 購入または復元完了
          // 購入の検証（本来はサーバーサイドで実装）
          final bool valid = await _verifyPurchase(purchaseDetails);
          
          if (valid) {
            // プレミアム状態を保存
            await _savePremiumStatus(true);
            
            // トランザクション完了
            if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
            }
            
            final status = purchaseDetails.status == PurchaseStatus.purchased
                ? PurchaseStatus.purchased
                : PurchaseStatus.restored;
            
            _notifyStatusChange(
              status == PurchaseStatus.purchased 
                  ? PurchaseStatus.purchased 
                  : PurchaseStatus.restored,
              status == PurchaseStatus.purchased 
                  ? '購入が完了しました' 
                  : '購入情報が復元されました'
            );
          } else {
            _notifyStatusChange(PurchaseStatus.error, '購入の検証に失敗しました');
          }
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          // エラー発生
          _notifyStatusChange(
            PurchaseStatus.error, 
            '購入中にエラーが発生しました: ${purchaseDetails.error?.message ?? "不明なエラー"}'
          );
          
          // エラー状態のトランザクションは完了させる
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          // キャンセル
          _notifyStatusChange(PurchaseStatus.error, '購入がキャンセルされました');
        }
        
        _isLoading = false;
      }
    }
  }
  
  // 購入検証処理
  // 本番環境では、サーバーサイドでレシートを検証する実装が必要
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // iOS の場合
    if (Platform.isIOS) {
      // レシートデータの確認
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
              
      // 本番環境では、レシートデータをサーバーに送信して検証
      // ここでは簡易的な実装
      return purchaseDetails.status == PurchaseStatus.purchased || 
             purchaseDetails.status == PurchaseStatus.restored;
    }
    
    // Android の場合
    else if (Platform.isAndroid) {
      // 購入状態の確認
      if (purchaseDetails is GooglePlayPurchaseDetails) {
        // 本番環境では、purchaseDetails.billingClientPurchase.purchaseToken を
        // サーバーに送信して、Google Play Developer API で検証
        return purchaseDetails.status == PurchaseStatus.purchased || 
               purchaseDetails.status == PurchaseStatus.restored;
      }
    }
    
    return false;
  }
  
  // プレミアムステータスの保存
  Future<void> _savePremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPremium, isPremium);
    _isPremium = isPremium;
  }
  
  // ステータス変更通知
  void _notifyStatusChange(PurchaseStatus status, String message) {
    for (final listener in _statusListeners) {
      listener(status, message);
    }
  }
  
  // 購入ストリーム終了ハンドラ
  void _updateStreamOnDone() {
    _subscription?.cancel();
  }
  
  // 購入ストリームエラーハンドラ
  void _handleError(dynamic error) {
    _notifyStatusChange(PurchaseStatus.error, 'エラーが発生しました: $error');
  }
  
  // ステータスリスナー追加
  void addStatusListener(Function(PurchaseStatus, String) listener) {
    _statusListeners.add(listener);
  }
  
  // ステータスリスナー削除
  void removeStatusListener(Function(PurchaseStatus, String) listener) {
    _statusListeners.remove(listener);
  }
  
  // テスト用：プレミアムステータスを直接切り替え（テスト・開発用）
  Future<void> togglePremiumStatus() async {
    await _savePremiumStatus(!_isPremium);
    _notifyStatusChange(
      _isPremium ? PurchaseStatus.purchased : PurchaseStatus.notPurchased,
      _isPremium ? 'テスト購入完了' : 'テスト購入解除'
    );
  }
  
  // リソース解放
  void dispose() {
    _subscription?.cancel();
  }
}