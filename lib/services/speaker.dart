import 'package:flutter_tts/flutter_tts.dart';


class Speaker {
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> speak(String text) async {
    if (!_ready) {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45); 
      _ready = true;
    }
    await _tts.stop(); 
    await _tts.speak(text);
  }
}