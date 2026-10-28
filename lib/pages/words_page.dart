import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/word.dart';
import '../widgets/app_button.dart';
import '../widgets/word_tile.dart';


class WordsPage extends StatefulWidget {
  final List<Word> words;
  final void Function(Word) onAdd;
  final void Function(Word) onRemove;
  final void Function(int, Word) onInsert; 
  const WordsPage({
    super.key,
    required this.words,
    required this.onAdd,
    required this.onRemove,
    required this.onInsert,
  });

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  String query = '';

  void openAddSheet() {
    final en = TextEditingController();
    final uz = TextEditingController();
    final ex = TextEditingController();
    String? error; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Yangi so'z", style: display(24)),
            const SizedBox(height: 16),
            TextField(
              controller: en,
              decoration: const InputDecoration(
                  labelText: 'Inglizcha', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: uz,
              decoration: const InputDecoration(
                  labelText: "O'zbekcha", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ex,
              decoration: const InputDecoration(
                  labelText: 'Misol gap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  error!,
                  style: const TextStyle(
                    color: Color(0xFFC43E2A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            AppButton(
              text: "So'zni saqlash",
              style: AppButtonStyle.teal,
              expand: true,
              onPressed: () {
                if (en.text.trim().isEmpty || uz.text.trim().isEmpty) {
                  setSheet(() => error =
                      "Inglizcha va o'zbekcha maydonlarni to'ldiring");
                  return;
                }
                widget.onAdd(
                  Word(en.text.trim(), uz.text.trim(), ex.text.trim(), 'B1'),
                );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  
  Widget _dismissible(Word w) {
    return Dismissible(
      key: ObjectKey(w),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFE5533D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        final index = widget.words.indexOf(w); 
        widget.onRemove(w);
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text("'${w.en}' o'chirildi"),
            action: SnackBarAction(
              label: 'Qaytarish',
              onPressed: () => widget.onInsert(index, w),
            ),
          ),
        );
      },
      child: WordTile(word: w),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final list = widget.words
        .where((w) => w.en.toLowerCase().contains(q) || w.uz.toLowerCase().contains(q))
        .toList();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text("Mening so'zlarim", style: display(30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: "So'z qidirish",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        widget.words.isEmpty
                            ? "Hali so'z yo'q. Pastdagi tugma bilan qo'shing"
                            : 'Hech narsa topilmadi',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                      itemCount: list.length,
                      itemBuilder: (_, i) => _dismissible(list[i]),
                    ),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: AppButton(
            text: "So'z qo'shish",
            icon: Icons.add,
            onPressed: openAddSheet,
          ),
        ),
      ],
    );
  }
}