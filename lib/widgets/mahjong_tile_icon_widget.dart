// lib/widgets/mahjong_tile_icon.dart
import 'package:flutter/material.dart';

/// 麻雀牌のアイコンウィジェット
/// 
/// アプリのタイトルアイコンや装飾として使用できるシンプルな麻雀牌表示
class MahjongTileIcon extends StatelessWidget {
  /// アイコンの幅
  final double width;
  
  /// アイコンの高さ
  final double height;
  
  /// 牌の文字（デフォルトは五）
  final String value;
  
  /// 牌の種類（デフォルトは萬）
  final String suit;
  
  /// 牌の文字の色
  final Color valueColor;
  
  const MahjongTileIcon({
    Key? key,
    this.width = 210,
    this.height = 280,
    this.value = '五',
    this.suit = '萬',
    this.valueColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.transparent,
      child: CustomPaint(
        painter: MahjongTilePainter(
          value: value,
          suit: suit,
          valueColor: valueColor,
        ),
        size: Size(width, height),
      ),
    );
  }
}

class MahjongTilePainter extends CustomPainter {
  final String value;
  final String suit;
  final Color valueColor;

  MahjongTilePainter({
    required this.value,
    required this.suit,
    required this.valueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 麻雀牌の比率：高さ28mm×幅21mm×厚み16.5mm
    // 2Dで表現するため、厚みは斜めの影として表現します
    
    final Paint tilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    final Paint shadePaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;
    
    // 牌の厚みを表現する部分（右側と下側）
    final double thicknessRatio = 16.5 / 28.0; // 厚みと高さの比率
    final double thicknessPixels = size.height * thicknessRatio * 0.3; // 画面上で見やすいよう調整
    
    // 牌のメイン部分（前面）
    final RRect frontRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width - thicknessPixels, size.height - thicknessPixels),
      const Radius.circular(10),
    );
    
    // 影部分（厚み）- 右側
    final Path rightShadePath = Path()
      ..moveTo(frontRect.right, frontRect.top + frontRect.tlRadiusY)
      ..lineTo(frontRect.right + thicknessPixels, frontRect.top + frontRect.tlRadiusY + thicknessPixels)
      ..lineTo(frontRect.right + thicknessPixels, frontRect.bottom + thicknessPixels - frontRect.brRadiusY)
      ..lineTo(frontRect.right, frontRect.bottom - frontRect.brRadiusY)
      ..close();
    
    // 影部分（厚み）- 下側
    final Path bottomShadePath = Path()
      ..moveTo(frontRect.left + frontRect.blRadiusX, frontRect.bottom)
      ..lineTo(frontRect.left + frontRect.blRadiusX + thicknessPixels, frontRect.bottom + thicknessPixels)
      ..lineTo(frontRect.right + thicknessPixels - frontRect.brRadiusX, frontRect.bottom + thicknessPixels)
      ..lineTo(frontRect.right - frontRect.brRadiusX, frontRect.bottom)
      ..close();
    
    // 描画順序：影→前面
    canvas.drawPath(rightShadePath, shadePaint);
    canvas.drawPath(bottomShadePath, shadePaint);
    canvas.drawRRect(frontRect, tilePaint);
    canvas.drawRRect(frontRect, borderPaint);
    
    // 五萬（中央の赤い文字）を描画
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: valueColor,
          fontSize: size.width * 0.48,  // 親要素のサイズに対して相対的に設定
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final double textX = (frontRect.width - textPainter.width) / 2;
    final double textY = (frontRect.height - textPainter.height) / 2;
    
    textPainter.paint(canvas, Offset(textX, textY));
    
    // 萬の文字（下部）
    final TextPainter characterPainter = TextPainter(
      text: TextSpan(
        text: suit,
        style: TextStyle(
          color: Colors.black,
          fontSize: size.width * 0.19,  // 親要素のサイズに対して相対的に設定
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    characterPainter.layout();
    
    final double charX = (frontRect.width - characterPainter.width) / 2;
    final double charY = frontRect.height - characterPainter.height - (size.height * 0.07);
    
    characterPainter.paint(canvas, Offset(charX, charY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}