import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

// So'zlarni telefon xotirasida saqlaydi va o'qiydi
class WordStorage {
  static const _key = 'words';

  // Saqlangan so'zlar yo'q bo'lsa (birinchi ishga tushish) null qaytaradi
  static Future<List<Word>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List;
    return list.map((e) => Word.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> save(List<Word> words) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(words.map((w) => w.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}