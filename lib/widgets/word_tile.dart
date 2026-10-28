import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/word.dart';

// Bitta so'z qatori: inglizcha, o'zbekcha va daraja belgisi
class WordTile extends StatelessWidget {
  final Word word;
  const WordTile({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word.en, style: display(18)),
                const SizedBox(height: 2),
                Text(
                  word.uz,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F1F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              word.level,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B6B6D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}