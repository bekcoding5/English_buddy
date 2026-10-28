import 'package:shared_preferences/shared_preferences.dart';


class Stats {
  final int doneToday;
  final int streak;
  const Stats({this.doneToday = 0, this.streak = 0});
}


class StatsStorage {
  static const goal = 10; 

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String get _today => _fmt(DateTime.now());
  static String get _yesterday =>
      _fmt(DateTime.now().subtract(const Duration(days: 1)));

  
  static Future<Stats> load() async {
    final p = await SharedPreferences.getInstance();
    final lastDate = p.getString('lastDate');
    var streak = p.getInt('streak') ?? 0;
    
    final done = lastDate == _today ? (p.getInt('doneToday') ?? 0) : 0;
    
    if (lastDate != _today && lastDate != _yesterday) streak = 0;
    return Stats(doneToday: done, streak: streak);
  }

  
  static Future<Stats> recordReview() async {
    final p = await SharedPreferences.getInstance();
    final lastDate = p.getString('lastDate');
    var streak = p.getInt('streak') ?? 0;
    var done = lastDate == _today ? (p.getInt('doneToday') ?? 0) : 0;

    if (lastDate != _today) {
      
      streak = lastDate == _yesterday ? streak + 1 : 1;
    }
    done++;

    await p.setString('lastDate', _today);
    await p.setInt('streak', streak);
    await p.setInt('doneToday', done);
    return Stats(doneToday: done, streak: streak);
  }
}