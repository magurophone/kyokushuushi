// lib/utils/custom_page_transition.dart
import 'package:flutter/material.dart';

/// カスタムページトランジションアニメーション
class CustomPageTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Curve curve;
  
  CustomPageTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOut,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      
      // フェードイン + スケールアップアニメーションの組み合わせ
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}