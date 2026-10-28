import 'package:flutter/material.dart';
import '../data/sample_words.dart';
import '../data/stats_storage.dart';
import '../data/word_storage.dart';
import '../models/word.dart';
import 'home_page.dart';
import 'review_page.dart';
import 'words_page.dart';

// Ilovaning "skeleti": pastki navigatsiya + umumiy ma'lumotlar
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;
  bool loading = true;
  List<Word> words = [];
  Stats stats = const Stats();

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Ilova ochilganda saqlangan so'zlar va statistikani o'qiydi
  Future<void> _load() async {
    final savedWords = await WordStorage.load();
    final savedStats = await StatsStorage.load();
    setState(() {
      words = savedWords ?? List<Word>.from(sampleWords);
      stats = savedStats;
      loading = false;
    });
  }

  void addWord(Word w) {
    setState(() => words.insert(0, w));
    WordStorage.save(words);
  }

  void removeWord(Word w) {
    setState(() => words.remove(w));
    WordStorage.save(words);
  }

  void insertWord(int index, Word w) {
    setState(() => words.insert(index.clamp(0, words.length).toInt(), w));
    WordStorage.save(words);
  }

  void _startReview() {
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avval \"So'zlar\" tabida so'z qo'shing")),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReviewPage(words: words, onReviewed: _onReviewed),
      ),
    );
  }

  // Takrorlashda har bir javobdan keyin chaqiriladi
  Future<void> _onReviewed() async {
    final s = await StatsStorage.recordReview();
    setState(() => stats = s);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      HomePage(
        words: words,
        stats: stats,
        onStart: _startReview,
      ),
      WordsPage(
        words: words,
        onAdd: addWord,
        onRemove: removeWord,
        onInsert: insertWord,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFE3A3),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Bugun',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: "So'zlar",
          ),
        ],
      ),
    );
  }
}