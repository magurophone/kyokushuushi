// lib/screens/help_screen.dart
import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 現在のテーマモードを取得
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('使い方ガイド'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 戻るボタン効果音再生
            SettingsService().playSound('helpoff');
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "筋カウンターαの使い方",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blue : const Color(0xFF0D47A1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // ここに使い方説明のコンテンツを追加
              // 例として枠組みだけ作成しています
              _buildHelpSection(
                title: "アプリの概要",
                content: "※ 正確な説明文をここに記載してください",
                isDarkMode: isDarkMode,
              ),
              
              _buildHelpSection(
                title: "画面の見方",
                content: "※ 正確な説明文をここに記載してください",
                isDarkMode: isDarkMode,
              ),
              
              _buildHelpSection(
                title: "筋カウントの使い方",
                content: "※ 正確な説明文をここに記載してください",
                isDarkMode: isDarkMode,
              ),
              
              _buildHelpSection(
                title: "各種設定について",
                content: "※ 正確な説明文をここに記載してください",
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ヘルプセクションを構築するヘルパーメソッド
  Widget _buildHelpSection({
    required String title,
    required String content,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDarkMode 
                ? Colors.blue.withOpacity(0.2) 
                : const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDarkMode
                  ? Colors.blue.withOpacity(0.3)
                  : const Color(0xFF1976D2).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.blue.shade300 : const Color(0xFF0D47A1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}