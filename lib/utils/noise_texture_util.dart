// lib/utils/noise_texture_util.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// グラデーションのバンディングを軽減するためのノイズテクスチャユーティリティ
class NoiseTextureUtil {
  /// ノイズテクスチャを追加したグラデーション背景を作成する
  static Widget buildNoiseBackground({
    required Widget child,
    required List<Color> colors,
    List<double>? stops,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    double noiseOpacity = 0.02,
    int noisePixelDensity = 300,
  }) {
    return Stack(
      children: [
        // ベースのグラデーション
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              stops: stops,
              begin: begin,
              end: end,
            ),
          ),
        ),
        
        // ノイズレイヤー
        Opacity(
          opacity: noiseOpacity,
          child: CustomPaint(
            painter: NoisePainter(pixelDensity: noisePixelDensity),
            child: Container(),
          ),
        ),
        
        // メインコンテンツ
        child,
      ],
    );
  }
  
  /// グラデーションバックグラウンドにノイズを追加するデコレーションを作成する
  static Widget buildNoiseGradientContainer({
    required Widget child,
    required List<Color> colors,
    List<double>? stops,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    double noiseOpacity = 0.02,
    int noisePixelDensity = 300,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: [
            // ベースのグラデーション
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  stops: stops,
                  begin: begin,
                  end: end,
                ),
              ),
            ),
            
            // ノイズレイヤー
            Opacity(
              opacity: noiseOpacity,
              child: CustomPaint(
                painter: NoisePainter(pixelDensity: noisePixelDensity),
                child: Container(),
              ),
            ),
            
            // メインコンテンツ
            child,
          ],
        ),
      ),
    );
  }
}

/// ノイズを生成するカスタムペインター
class NoisePainter extends CustomPainter {
  final int pixelDensity;
  final List<Color> noiseColors;
  final math.Random random = math.Random();
  
  NoisePainter({
    this.pixelDensity = 100,
    List<Color>? noiseColors,
  }) : noiseColors = noiseColors ?? [
         Colors.white.withOpacity(0.05),
         Colors.white.withOpacity(0.02),
         Colors.black.withOpacity(0.02),
         Colors.black.withOpacity(0.05),
       ];
  
  @override
  void paint(Canvas canvas, Size size) {
    final double pixelSize = size.width / pixelDensity;
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;
    
    for (int x = 0; x < pixelDensity; x++) {
      for (int y = 0; y < (size.height / pixelSize).ceil(); y++) {
        // ランダムなノイズカラーを選択
        paint.color = noiseColors[random.nextInt(noiseColors.length)];
        
        // ノイズピクセルを描画
        canvas.drawRect(
          Rect.fromLTWH(
            x * pixelSize,
            y * pixelSize,
            pixelSize,
            pixelSize,
          ),
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}