import 'package:audioplayers/audioplayers.dart';
import '../models/models.dart';

enum AudioPlayerState {
  stopped,
  playing,
  paused,
  loading,
  error,
}

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayerState _state = AudioPlayerState.stopped;
  String? _currentAudioUrl;

  AudioPlayerState get state => _state;
  String? get currentAudioUrl => _currentAudioUrl;

  AudioService() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      switch (state) {
        case PlayerState.stopped:
          _state = AudioPlayerState.stopped;
          break;
        case PlayerState.playing:
          _state = AudioPlayerState.playing;
          break;
        case PlayerState.paused:
          _state = AudioPlayerState.paused;
          break;
        case PlayerState.completed:
          _state = AudioPlayerState.stopped;
          _currentAudioUrl = null;
          break;
      }
    });
  }

  Future<void> playFromUrl(String url) async {
    try {
      _state = AudioPlayerState.loading;
      _currentAudioUrl = url;
      
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      _state = AudioPlayerState.error;
      _currentAudioUrl = null;
      throw Exception('Failed to play audio: $e');
    }
  }

  Future<void> playPrompt(Prompt prompt) async {
    await playFromUrl(prompt.audioUrl);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _state = AudioPlayerState.stopped;
    _currentAudioUrl = null;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration?> get durationStream => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get stateStream => _audioPlayer.onPlayerStateChanged;

  Future<Duration?> getDuration() async {
    return await _audioPlayer.getDuration();
  }

  Future<Duration> getCurrentPosition() async {
    return await _audioPlayer.getCurrentPosition() ?? Duration.zero;
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  bool get isPlaying => _state == AudioPlayerState.playing;
  bool get isPaused => _state == AudioPlayerState.paused;
  bool get isStopped => _state == AudioPlayerState.stopped;
  bool get isLoading => _state == AudioPlayerState.loading;
  bool get hasError => _state == AudioPlayerState.error;

  void dispose() {
    _audioPlayer.dispose();
  }
}