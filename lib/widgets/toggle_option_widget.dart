// lib/widgets/toggle_option_widget.dart
import 'package:flutter/material.dart';

class ToggleOptionWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final String trueText;
  final String falseText;
  final TextStyle toggleLabelStyle;
  final double fontRatio;
  final double width;
  final VoidCallback onExplanationTap;
  final bool isDarkMode;

  const ToggleOptionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.trueText,
    required this.falseText,
    required this.toggleLabelStyle,
    required this.fontRatio,
    required this.width,
    required this.onExplanationTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 大画面(600以上)では状態テキストとスイッチの間に余分なスペースを追加
    final double textSwitchSpacing = screenWidth >= 600 ? 20.0 : 0.0;
    
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: onExplanationTap,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: toggleLabelStyle.fontSize,
                fontWeight: FontWeight.bold,
                // より濃い色でコントラストを向上
                color: isDarkMode ? Colors.white : Color(0xFF0D47A1),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onExplanationTap,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              value ? trueText : falseText,
              style: TextStyle(
                fontSize: toggleLabelStyle.fontSize,
                // 選択されていない場合も視認性の高い色を使用
                color: value 
                  ? (isDarkMode ? Colors.blue : Color(0xFF0D47A1))  // 濃い青
                  : (isDarkMode ? Colors.white70 : Color(0xFF424242)),  // 濃いグレー
                fontWeight: value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: textSwitchSpacing), // 状態テキストとスイッチの間のスペース
          Transform.scale(
            scale: fontRatio * 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: isDarkMode ? Colors.blue : Color(0xFF1976D2),
              activeTrackColor: isDarkMode 
                ? Colors.blue.withOpacity(0.5)
                : Color(0xFF1976D2).withOpacity(0.5),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
/*
// 3段階切り替えトグルボタン - リセットボタン付き
// 最大段階（三翻UP）では自動的に通常に戻らない
class ThreeStateToggle extends StatefulWidget {
  final Function(int) onToggle;
  final int initialState; // 0=通常, 1=一翻UP, 2=二翻UP, 3=三翻UP
  final List<String> labels;
  
  const ThreeStateToggle({
    Key? key,
    required this.onToggle,
    this.initialState = 0,
    required this.labels,
  }) : super(key: key);

  @override
  _ThreeStateToggleState createState() => _ThreeStateToggleState();
}

class _ThreeStateToggleState extends State<ThreeStateToggle> {
  late int currentState;
  
  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
  }
  
  void _nextState() {
    setState(() {
      // 0 → 1 → 2 → 3 の順で状態を切り替え（3で止まる）
      if (currentState < 3) {
        currentState += 1;
      }
      // 3の後は自動的に0に戻らない
    });
    widget.onToggle(currentState);
  }
  
  void _resetState() {
    setState(() {
      currentState = 0; // 通常状態にリセット
    });
    widget.onToggle(currentState);
  }
  
  @override
  Widget build(BuildContext context) {
    // 状態に応じた色とラベルを設定
    Color backgroundColor;
    String label;
    
    switch (currentState) {
      case 0:
        backgroundColor = Colors.grey.shade600; // 通常状態
        label = widget.labels[0];
        break;
      case 1:
        backgroundColor = Colors.blue; // 一翻UP状態
        label = widget.labels[1];
        break;
      case 2:
        backgroundColor = Colors.amber.shade700; // 二翻UP状態
        label = widget.labels[2];
        break;
      case 3:
        backgroundColor = Colors.red; // 三翻UP状態
        label = widget.labels[3];
        break;
      default:
        backgroundColor = Colors.grey.shade600;
        label = widget.labels[0];
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _nextState,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  currentState == 0 ? Icons.toggle_off : Icons.toggle_on,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // 通常状態以外の場合のみリセットボタンを表示
        if (currentState != 0)
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.shade300),
            onPressed: _resetState,
            tooltip: '通常に戻す',
            splashRadius: 24,
          ),
      ],
    );
  }
}

// 使用例
/*
ThreeStateToggle(
  labels: ["通常", "一翻UP", "二翻UP", "三翻UP"],
  initialState: 0, 
  onToggle: (state) {
    setState(() {
      _fanUpState = state;
    });
    // 状態に応じた処理...
    print("翻UP状態: $state");
  },
)
*/
*/