// lib/widgets/divider_widget.dart
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final bool isSmall;

  const DividerWidget({
    super.key, 
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmall ? 1 : 2,
      margin: isSmall 
          ? const EdgeInsets.symmetric(horizontal: 8) 
          : const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.1),
            isSmall ? Colors.grey.withOpacity(0.3) : Colors.blue.withOpacity(0.5),
            Colors.grey.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}