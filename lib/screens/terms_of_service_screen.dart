// lib/screens/terms_of_service_screen.dart
import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    final screenSize = MediaQuery.of(context).size;
    // 画面の幅に応じて余白を調整
    final horizontalPadding = screenSize.width * 0.06; // 画面幅の6%
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
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
                  // タイトル
                  _buildSection(
                    '筋カウンターα 利用規約',
                    '本利用規約（以下「本規約」といいます）は、「筋カウンターα」（以下「本アプリ」といいます）の利用に関する条件を定めるものです。ユーザーの皆様は、本アプリをダウンロードまたは使用することにより、本規約に同意したものとみなされます。',
                    context,
                    isTitle: true,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  
                  // 第1条
                  _buildSection(
                    '第1条（サービス概要）',
                    '本アプリは、麻雀における「筋カウント理論」の学習および実践をサポートするためのツールです。本アプリは情報提供を目的としており、ギャンブルや賭博を推奨するものではありません。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第2条
                  _buildSection(
                    '第2条（利用条件）',
                    '1. 本アプリは、個人的、非商業的な目的でのみ使用することができます。\n'
                    '2. ユーザーは、本アプリを使用するにあたり、自己の責任において適切なデバイスおよびインターネット環境を用意するものとします。\n'
                    '3. 本アプリは、予告なく仕様変更、サービス停止、終了する場合があります。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第3条
                  _buildSection(
                    '第3条（知的財産権）',
                    '1. 本アプリに関する著作権、商標権その他の知的財産権は、開発者または正当な権利者に帰属します。\n'
                    '2. ユーザーは、開発者の書面による事前の承諾なく、本アプリの複製、改変、再配布、リバースエンジニアリングなどを行うことはできません。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第4条
                  _buildSection(
                    '第4条（禁止事項）',
                    'ユーザーは、本アプリの使用にあたり、以下の行為を行ってはならないものとします：\n\n'
                    '1. 法令または公序良俗に違反する行為\n'
                    '2. 本アプリの運営を妨害する行為\n'
                    '3. 他のユーザーまたは第三者に不利益を与える行為\n'
                    '4. 本アプリを賭博や違法な活動に使用する行為\n'
                    '5. 本アプリのセキュリティを侵害する行為\n'
                    '6. その他、開発者が不適切と判断する行為',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第5条
                  _buildSection(
                    '第5条（広告表示）',
                    '1. 本アプリは、第三者の広告を表示する場合があります。\n'
                    '2. 広告の内容は、開発者が管理するものではなく、広告に関する責任は広告主に帰属します。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第6条
                  _buildSection(
                    '第6条（免責事項）',
                    '1. 開発者は、本アプリの内容の正確性、完全性、有用性、特定目的への適合性について、いかなる保証も行いません。\n'
                    '2. 開発者は、本アプリの使用または使用不能から生じるいかなる損害（直接的、間接的、偶発的、結果的損害を含む）についても、一切の責任を負いません。\n'
                    '3. 本アプリを使用して行われるゲームやコンテンツに関する責任は、すべてユーザー自身が負うものとします。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第7条
                  _buildSection(
                    '第7条（利用規約の変更）',
                    '1. 開発者は、必要と判断した場合には、ユーザーに通知することなく本規約を変更することがあります。\n'
                    '2. 変更後の利用規約は、本アプリ内または開発者の指定するウェブサイト上に表示された時点から効力を生じるものとします。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第8条
                  _buildSection(
                    '第8条（準拠法および管轄）',
                    '1. 本規約の解釈および適用は、日本国法に準拠するものとします。\n'
                    '2. 本アプリの利用に関して紛争が生じた場合には、開発者の所在地を管轄する裁判所を第一審の専属的合意管轄裁判所とします。',
                    context,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  
                  // 第9条
                  _buildSection(
                    '第9条（お問い合わせ）',
                    '本規約に関するお問い合わせは、以下の連絡先までお願いいたします：\n\n'
                    '- メール：magurophone-app@yahoo.co.jp',
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

  Widget _buildSection(String title, String content, BuildContext context, {bool isTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _getAdaptiveFontSize(context, isTitle ? 20 : 18),
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