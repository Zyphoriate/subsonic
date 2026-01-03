import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../services/subsonic_api_service.dart';

class LibraryProvider with ChangeNotifier {
  SubsonicApiService? _api;
  
  List<Artist> _artists = [];
  List<Album> _albums = [];
  List<Song> _songs = [];
  List<Song> _starredSongs = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Artist> get artists => _artists;
  List<Album> get albums => _albums;
  List<Song> get songs => _songs;
  List<Song> get starredSongs => _starredSongs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  void setApi(SubsonicApiService api) {
    _api = api;
  }
  
  Future<void> loadLibrary() async {
    if (_api == null) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Load artists and albums in parallel
      final results = await Future.wait([
        _api!.getArtists(),
        _api!.getAlbumList(size: 500),
      ]);
      
      _artists = results[0] as List<Artist>;
      _albums = results[1] as List<Album>;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<Map<String, dynamic>?> getAlbumDetails(String albumId) async {
    if (_api == null) return null;
    
    try {
      return await _api!.getAlbum(albumId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  Future<void> loadRandomSongs() async {
    if (_api == null) return;
    
    try {
      _songs = await _api!.getRandomSongs(size: 50);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  Future<List<Song>> search(String query) async {
    if (_api == null) return [];
    
    try {
      return await _api!.search(query);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }
  
  Future<void> loadStarredSongs() async {
    if (_api == null) return;
    
    try {
      _starredSongs = await _api!.getStarred();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> toggleStar(Song song) async {
    if (_api == null) return;
    
    try {
      if (song.starred == true) {
        await _api!.unstar(song.id);
      } else {
        await _api!.star(song.id);
      }
      
      // Reload starred songs
      await loadStarredSongs();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
