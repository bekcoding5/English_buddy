import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../data/stats_storage.dart';
import '../models/word.dart';
import '../widgets/app_button.dart';
import '../widgets/word_tile.dart';


class HomePage extends StatelessWidget {
  final List<Word> words;
  final Stats stats;
  final VoidCallback onStart;
  const HomePage({
    super.key,
    required this.words,
    required this.stats,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text('Salom, bugun\nyana bir qadam', style: display(30)),
            ),
            _StreakPill(days: stats.streak),
          ],
        ),
        const SizedBox(height: 22),
        _GoalCard(
          done: stats.doneToday,
          goal: StatsStorage.goal,
          onStart: onStart,
        ),
        const SizedBox(height: 24),
        Text("Bugungi so'zlar", style: display(20)),
        const SizedBox(height: 12),
        for (final w in words.take(3)) WordTile(word: w),
      ],
    );
  }
}


class _StreakPill extends StatelessWidget {
  final int days;
  const _StreakPill({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: sun,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, size: 18, color: ink),
          const SizedBox(width: 4),
          Text('$days kun',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}


class _GoalCard extends StatelessWidget {
  final int done, goal;
  final VoidCallback onStart;
  const _GoalCard({required this.done, required this.goal, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: (done / goal).clamp(0.0, 1.0).toDouble(),
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0x33FFFFFF),
                    color: sun,
                  ),
                ),
                Text('$done/$goal', style: display(22, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kunlik maqsad', style: display(18, color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  done >= goal
                      ? "Bugungi maqsad bajarildi!"
                      : "Yana ${goal - done} ta so'z qoldi",
                  style: const TextStyle(fontSize: 14, color: Color(0xCCFFFFFF)),
                ),
                const SizedBox(height: 14),
                AppButton(
                  text: 'Takrorlashni boshlash',
                  onPressed: onStart,
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}