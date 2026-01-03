import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/subsonic_api_service.dart';

enum PlayerState { stopped, playing, paused, loading }

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  SubsonicApiService? _api;
  
  List<Song> _playlist = [];
  int _currentIndex = 0;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isShuffled = false;
  bool _isRepeat = false;
  
  PlayerProvider() {
    _initPlayer();
  }
  
  void _initPlayer() {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
    
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _playerState = PlayerState.playing;
      } else if (state.processingState == ProcessingState.loading) {
        _playerState = PlayerState.loading;
      } else {
        _playerState = PlayerState.paused;
      }
      notifyListeners();
      
      // Auto-play next song when current finishes
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
  }
  
  void setApi(SubsonicApiService api) {
    _api = api;
  }
  
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong => _playlist.isEmpty ? null : _playlist[_currentIndex];
  PlayerState get playerState => _playerState;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isShuffled => _isShuffled;
  bool get isRepeat => _isRepeat;
  
  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (_api == null || songs.isEmpty) return;
    
    _playlist = songs;
    _currentIndex = startIndex;
    await _playCurrent();
  }
  
  Future<void> _playCurrent() async {
    if (_api == null || _playlist.isEmpty) return;
    
    final song = _playlist[_currentIndex];
    final url = _api!.getStreamUrl(song.id);
    
    try {
      _playerState = PlayerState.loading;
      notifyListeners();
      
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      
      _playerState = PlayerState.playing;
      notifyListeners();
    } catch (e) {
      _playerState = PlayerState.stopped;
      notifyListeners();
      debugPrint('Error playing song: $e');
    }
  }
  
  Future<void> play() async {
    await _audioPlayer.play();
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> next() async {
    if (_playlist.isEmpty) return;
    
    if (_isRepeat) {
      await _playCurrent();
      return;
    }
    
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _playCurrent();
  }
  
  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    
    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _playCurrent();
  }
  
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      // Implement shuffle logic
    }
    notifyListeners();
  }
  
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
