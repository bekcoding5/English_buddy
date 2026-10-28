import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/word.dart';
import '../services/speaker.dart';
import '../widgets/app_button.dart';

// Takrorlash: aylanadigan kartochkalar
class ReviewPage extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onReviewed; // har bir javobdan keyin chaqiriladi
  const ReviewPage({super.key, required this.words, required this.onReviewed});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final List<Word> queue = List<Word>.of(widget.words); // kartalar navbati
  final seen = <Word>{}; // bu mashqda ko'rilgan so'zlar
  final missed = <Word>{}; // bir marta bo'lsa ham bilmagan so'zlar
  int index = 0; // navbatdagi hozirgi karta
  int mastered = 0; // nechta so'z o'zlashtirildi
  int firstTry = 0; // birinchi urinishda bilganlar
  bool flipped = false; // karta orqa tomonga aylanganmi

  int get total => widget.words.length;
  bool get finished => index >= queue.length;

  void answer(bool knew) {
    final w = queue[index];
    // Kunlik hisobga har bir so'z faqat bir marta kiradi
    if (seen.add(w)) widget.onReviewed();
    setState(() {
      if (knew) {
        mastered++;
        if (!missed.contains(w)) firstTry++;
      } else {
        missed.add(w);
        queue.add(w); // bilmagan so'zni navbat oxiriga qaytaramiz
      }
      index++;
      flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: finished ? _buildResult() : _buildQuiz(),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // ---------- Savol ekrani ----------
  Widget _buildQuiz() {
    final w = queue[index];

    final front = _face(
      Colors.white,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (missed.contains(w)) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE3A3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Qayta takrorlash',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(w.en, style: display(44), textAlign: TextAlign.center),
          const SizedBox(height: 14),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFE2F1F1),
              foregroundColor: const Color(0xFF0B6B6D),
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.volume_up_outlined),
            onPressed: () => Speaker.speak(w.en),
          ),
        ],
      ),
    );

    final back = _face(
      const Color(0xFF0F7A7C),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(w.uz,
              style: display(34, color: Colors.white), textAlign: TextAlign.center),
          if (w.example.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              w.example,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );

    return Column(
      children: [
        Row(
          children: [
            _backButton(),
            const SizedBox(width: 12),
            Text('$mastered / $total', style: display(18)),
            const SizedBox(width: 8),
            Text("o'zlashtirildi", style: TextStyle(color: ink.withOpacity(0.6))),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: mastered / total,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFE5533D),
          backgroundColor: ink.withOpacity(0.1),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => flipped = !flipped),
            child: TweenAnimationBuilder<double>(
              key: ValueKey(index), // har bir karta yangidan boshlanadi
              tween: Tween(end: flipped ? 1 : 0),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
              builder: (_, v, __) {
                final showBack = v > 0.5;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(v * pi),
                  child: showBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: back,
                        )
                      : front,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          flipped ? '' : "Javobni ko'rish uchun kartani bosing",
          style: TextStyle(color: ink.withOpacity(0.6)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Bilmadim',
                style: AppButtonStyle.outline,
                expand: true,
                onPressed: () => answer(false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Bildim',
                style: AppButtonStyle.teal,
                expand: true,
                onPressed: () => answer(true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _face(Color color, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: child,
    );
  }

  // ---------- Natija ekrani ----------
  Widget _buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ajoyib!', style: display(40)),
        const SizedBox(height: 12),
        Text(
          "$total ta so'zdan $firstTry tasini birinchi urinishda bildingiz",
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppButton(
          text: 'Yakunlash',
          expand: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}