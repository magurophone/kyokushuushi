// lib/utils/gradient_helper.dart
// グラデーションの品質を向上させるためのヘルパークラス

import 'package:flutter/material.dart';

/// グラデーションの品質を向上させるためのヘルパークラス
class GradientHelper {
  /// 滑らかなダークグラデーションを生成
  /// [startColor]と[endColor]の間に複数の中間色を自動的に挿入
  static LinearGradient smoothDarkGradient({
    required Color startColor,
    required Color endColor,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        startColor,
        _interpolateColor(startColor, endColor, 0.2),
        _interpolateColor(startColor, endColor, 0.4),
        _interpolateColor(startColor, endColor, 0.6),
        _interpolateColor(startColor, endColor, 0.8),
        endColor,
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );
  }
  
  /// 滑らかなカラーグラデーションを生成
  /// 特にアクセントカラーを使用したグラデーションに適しています
  static LinearGradient smoothAccentGradient({
    required Color color,
    double startOpacity = 0.05,
    double endOpacity = 0.2,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color.withOpacity(startOpacity),
        color.withOpacity(_interpolateValue(startOpacity, endOpacity, 0.3)),
        color.withOpacity(_interpolateValue(startOpacity, endOpacity, 0.7)),
        color.withOpacity(endOpacity),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
  }
  
  /// 二つの色の間を補間して中間色を生成
  static Color _interpolateColor(Color a, Color b, double t) {
    return Color.fromARGB(
      _interpolateValue(a.alpha.toDouble(), b.alpha.toDouble(), t).round(),
      _interpolateValue(a.red.toDouble(), b.red.toDouble(), t).round(),
      _interpolateValue(a.green.toDouble(), b.green.toDouble(), t).round(),
      _interpolateValue(a.blue.toDouble(), b.blue.toDouble(), t).round(),
    );
  }
  
  /// 二つの値の間を線形補間
  static double _interpolateValue(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  /// ディザリング効果を適用したグラデーションコンテナを生成
  /// ノイズテクスチャを直接適用することはできないため、微細なシャドウでバンディングを軽減
  static BoxDecoration ditheringGradientDecoration({
    required Gradient gradient,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? extraShadows,
  }) {
    final List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 0.5,
        spreadRadius: 0.5,
      ),
    ];
    
    if (extraShadows != null) {
      shadows.addAll(extraShadows);
    }
    
    return BoxDecoration(
      gradient: gradient,
      borderRadius: borderRadius,
      border: border,
      boxShadow: shadows,
    );
  }
}