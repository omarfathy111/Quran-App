import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false; // 🔄 حالة التحميل
  int? _currentSurah;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  int? get currentSurah => _currentSurah;
  Duration get position => _position;
  Duration get duration => _duration;

  AudioProvider() {
    _audioPlayer.onPositionChanged.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> play(String url, int surahNo) async {
    _isLoading = true;
    notifyListeners();

    if (_isPlaying && _currentSurah != surahNo) {
      await stop();
    }

    _currentSurah = surahNo;
    await _audioPlayer.play(UrlSource(url));

    _isLoading = false;
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    _isLoading = true; // ⏳ ابدأ التحميل
    notifyListeners();

    await _audioPlayer.seek(position);

    // ننتظر شوية لحد ما الصوت يجهز من النقطة الجديدة
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }
}
