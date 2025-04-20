// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';
import 'purchase_screen.dart';
import '../services/purchase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  // 将来的なリファラルコードの状態管理用
  String? _referralCode;
  final List<String> _invitedFriends = [];
  
  // 設定サービスのインスタンス
  final SettingsService _settingsService = SettingsService();
  // 購入サービスのインスタンス
  final PurchaseService _purchaseService = PurchaseService();
  
  @override
  void initState() {
    super.initState();
    // 将来的にはユーザー情報からリファラルコードを取得
    // _loadReferralData();
    
    // 状態を監視するリスナーを追加
    _purchaseService.addStatusListener(_onPurchaseStatusChange);
  }
  
  @override
  void dispose() {
    // リスナーを削除
    _purchaseService.removeStatusListener(_onPurchaseStatusChange);
    super.dispose();
  }
  
  // 課金状態変更ハンドラ
  void _onPurchaseStatusChange(PurchaseStatus status, String message) {
    // UIを更新
    if (mounted) {
      setState(() {});
    }
  }
  
  // 将来的な実装用のプレースホルダー
  // Future<void> _loadReferralData() async {
  //   // Firebase or local storageからデータ取得
  // }
  
  @override
  Widget build(BuildContext context) {
    // 現在のテーマモードを取得
    final isDarkMode = _settingsService.isDarkMode;
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // アプリ設定セクション
              _buildSectionHeader('アプリ設定'),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: '画面モード',
                subtitle: isDarkMode ? 'ダークモードを使用中' : 'ライトモードを使用中',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) async {
                    // 効果音を再生
                    _settingsService.playSound('switch');
                    
                    // テーマを設定
                    await _settingsService.setDarkMode(value);
                    
                    setState(() {
                      // UIを更新
                    });
                    
                    // テーマ変更の通知
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? 'ダークモードに切り替えました' : 'ライトモードに切り替えました'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              
              // 音量調整
              _buildSettingItem(
                icon: Icons.volume_up,
                title: '音量設定',
                subtitle: 'アプリ内の効果音や通知音の調整',
                onTap: () => _showVolumeDialog(),
              ),
              const Divider(),
              
              // 友達招待セクション（将来的な実装用）
              _buildSectionHeader('友達招待'),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.people,
                title: '友達を招待する',
                subtitle: '友達を招待して特典をゲット！',
                onTap: () {
                  // 将来的なリファラル機能
                  _showComingSoonDialog('友達招待機能');
                },
              ),
              const Divider(),
              
              // プレミアム機能セクション
              _buildSectionHeader('プレミアム'),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: _purchaseService.isPremium ? Icons.check_circle : Icons.star,
                title: 'プレミアム機能',
                subtitle: _purchaseService.isPremium 
                    ? '広告は表示されません' 
                    : '広告を非表示にして全機能にアクセス',
                trailing: _purchaseService.isPremium 
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                onTap: () {
                  // プレミアム状態なら何もしない
                  if (_purchaseService.isPremium) {
                    return;
                  }
                  
                  // 効果音を再生
                  _settingsService.playSound('menu');
                  
                  // 課金画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PurchaseScreen()),
                  ).then((_) {
                    // 画面から戻ってきたらステートを更新
                    setState(() {});
                  });
                },
              ),
              const Divider(),
              
              // アプリ情報セクション
              _buildSectionHeader('アプリ情報'),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.info,
                title: 'バージョン情報',
                subtitle: 'バージョン 1.0.0',
              ),
              _buildSettingItem(
                icon: Icons.description,
                title: '利用規約',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.privacy_tip,
                title: 'プライバシーポリシー',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // セクションヘッダーウィジェット
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
  
  // 設定項目ウィジェット
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
  
  // 開発中機能のダイアログ
  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureは開発中'),
        content: const Text('この機能は今後のアップデートで利用可能になります。しばらくお待ちください。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // 音量設定ダイアログ
  void _showVolumeDialog() {
    // 現在の設定から初期値を取得
    double effectVolume = _settingsService.effectVolume;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('音量設定'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 効果音の音量スライダー
              Row(
                children: [
                  Icon(
                    effectVolume <= 0 ? Icons.volume_off : Icons.volume_up,
                    color: effectVolume <= 0 ? Colors.grey : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Text('効果音'),
                ],
              ),
              Slider(
                value: effectVolume,
                onChanged: (value) {
                  setState(() {
                    effectVolume = value;
                  });
                  // スライダー操作時にも設定を反映（インタラクティブな操作感のため）
                  _settingsService.setEffectVolume(value);
                  
                  // 設定の変更時に音を鳴らして確認
                  if (value > 0) {
                    _settingsService.playSound('switch');
                  }
                },
                divisions: 10,
                label: '${(effectVolume * 100).round()}%',
              ),
              const SizedBox(height: 16),
              

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                // 設定を保存
                await _settingsService.setEffectVolume(effectVolume);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('音量設定を保存しました')),
                  );
                  Navigator.of(context).pop();
                  
                  // 設定保存時に効果音を再生して確認
                  if (effectVolume > 0) {
                    _settingsService.playSound('setting');
                  }
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}