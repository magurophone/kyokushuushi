import 'package:flutter/material.dart';
import '../utils/three_player_calculation_manager.dart';

class ThreePlayerScreen extends StatefulWidget {
  const ThreePlayerScreen({super.key});

  @override
  ThreePlayerScreenState createState() => ThreePlayerScreenState();
}

class ThreePlayerScreenState extends State<ThreePlayerScreen> {
  // 計算マネージャー
  final ThreePlayerCalculationManager _calculationManager = ThreePlayerCalculationManager();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('三人麻雀'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // プレイヤーパネル
              _buildPlayerPanel('プレイヤー1', 
                  _calculationManager.getPlayerData('player1'), 
                  () => _incrementCount('player1'), 
                  () => _resetCount('player1')),
                  
              _buildPlayerPanel('プレイヤー2', 
                  _calculationManager.getPlayerData('player2'), 
                  () => _incrementCount('player2'), 
                  () => _resetCount('player2')),
              
              const SizedBox(height: 20),
              // 全リセットボタン
              ElevatedButton(
                onPressed: _resetAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('全てリセット', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // プレイヤーパネルを構築
  Widget _buildPlayerPanel(String name, Map<String, dynamic> playerData, VoidCallback onIncrement, VoidCallback onReset) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn('通った筋', '${playerData['count']}'),
                _buildInfoColumn('残り筋', '${playerData['remaining']}'),
                _buildInfoColumn('放銃率(片スジ)', playerData['houjuRate']),
                _buildInfoColumn('放銃率(両無スジ)', playerData['houjuRateRyounashi']),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onIncrement,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('カウント'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('リセット'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 情報カラムを構築
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
  
  // カウントを増やす
  void _incrementCount(String player) {
    setState(() {
      _calculationManager.incrementCount(player);
    });
  }
  
  // カウントをリセット
  void _resetCount(String player) {
    setState(() {
      _calculationManager.resetPlayer(player);
    });
  }
  
  // すべてリセット
  void _resetAll() {
    setState(() {
      _calculationManager.resetAll();
    });
  }
}