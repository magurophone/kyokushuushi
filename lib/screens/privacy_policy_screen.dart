// lib/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    final screenSize = MediaQuery.of(context).size;
    // 画面の幅に応じて余白を調整
    final horizontalPadding = screenSize.width * 0.06; // 画面幅の6%
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: constraints.maxHeight * 0.03, // 高さの3%
            ),
            child: Container(
              constraints: BoxConstraints(
                // 最大幅を制限して大画面でも読みやすく
                maxWidth: 800,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // はじめに
                  _buildSection(
                    'はじめに',
                    '筋カウンターαは、麻雀における「筋カウント理論」の学習をサポートするアプリです。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  
                  // 1. 収集する情報について
                  _buildSection(
                    '1. 収集する情報について',
                    '本アプリは、ユーザーの個人情報を収集しません。アプリの使用状況や個人を特定できる情報は一切収集していません。\n\n'
                    'アプリの設定（音量設定など）は、お使いのデバイス内にのみ保存され、外部に送信されることはありません。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  
                  // 2. 広告について
                  _buildSection(
                    '2. 広告について',
                    '本アプリは、広告を表示します。広告は第三者の広告配信サービスによって提供されています。広告配信サービスはアプリの使用状況に関する非個人情報を収集する場合があります。詳細については、使用している広告サービスのプライバシーポリシーをご参照ください。\n\n'
                    'Google AdMobのプライバシーポリシー:\n'
                    'https://policies.google.com/technologies/ads',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  
                  // お問い合わせ
                  _buildSection(
                    'お問い合わせ',
                    'プライバシーに関するご質問やご懸念がある場合は、以下の連絡先までお問い合わせください：\n\n'
                    'Mail: magurophone-app@yahoo.co.jp',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  
                  // 最終更新日
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '最終更新日: 2025/3/15',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: _getAdaptiveFontSize(context, 12),
                      ),
                    ),
                  ),
                  // 画面下部に余白を追加
                  SizedBox(height: constraints.maxHeight * 0.03),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _getAdaptiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        Text(
          content,
          style: TextStyle(
            fontSize: _getAdaptiveFontSize(context, 16),
            height: 1.5,
          ),
        ),
      ],
    );
  }
  
  // 画面サイズに応じたフォントサイズを計算
  double _getAdaptiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 小さい画面では少し小さく、大きい画面では少し大きく
    if (screenWidth < 360) {
      return baseSize * 0.9; // 小さい画面
    } else if (screenWidth > 600) {
      return baseSize * 1.1; // 大きい画面（タブレットなど）
    }
    
    return baseSize; // 標準サイズ
  }
}