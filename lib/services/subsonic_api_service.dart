import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/song.dart';
import '../models/album.dart';
import '../models/artist.dart';

class SubsonicApiService {
  String? _serverUrl;
  String? _username;
  String? _password;
  
  bool get isConfigured => _serverUrl != null && _username != null && _password != null;
  
  void configure(String serverUrl, String username, String password) {
    _serverUrl = serverUrl.endsWith('/') ? serverUrl : '$serverUrl/';
    _username = username;
    _password = password;
  }
  
  String _generateAuthToken() {
    final salt = DateTime.now().millisecondsSinceEpoch.toString();
    final token = md5.convert(utf8.encode('$_password$salt')).toString();
    return 't=$token&s=$salt';
  }
  
  String _buildUrl(String endpoint, [Map<String, String>? params]) {
    if (!isConfigured) throw Exception('API not configured');
    
    final queryParams = {
      'u': _username!,
      'v': AppConfig.apiVersion,
      'c': AppConfig.clientName,
      'f': 'json',
      ...?params,
    };
    
    final auth = _generateAuthToken();
    final query = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '${_serverUrl}rest/$endpoint?$query&$auth';
  }
  
  Future<Map<String, dynamic>> _get(String endpoint, [Map<String, String>? params]) async {
    try {
      final url = _buildUrl(endpoint, params);
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subsonicResponse = data['subsonic-response'];
        
        if (subsonicResponse['status'] == 'ok') {
          return subsonicResponse;
        } else {
          final error = subsonicResponse['error'];
          throw Exception('Subsonic error: ${error['message']} (${error['code']})');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Authentication
  Future<bool> ping() async {
    try {
      await _get('ping');
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Library methods
  Future<List<Artist>> getArtists() async {
    final response = await _get('getArtists');
    final artists = <Artist>[];
    
    final indexes = response['artists']['index'] as List?;
    if (indexes != null) {
      for (var index in indexes) {
        final artistList = index['artist'] as List?;
        if (artistList != null) {
          for (var artistJson in artistList) {
            artists.add(Artist.fromJson(artistJson));
          }
        }
      }
    }
    
    return artists;
  }
  
  Future<List<Album>> getAlbumList({
    String type = 'alphabeticalByName',
    int size = 500,
    int offset = 0,
  }) async {
    final response = await _get('getAlbumList2', {
      'type': type,
      'size': size.toString(),
      'offset': offset.toString(),
    });
    
    final albumList = response['albumList2']['album'] as List?;
    if (albumList == null) return [];
    
    return albumList.map((json) => Album.fromJson(json)).toList();
  }
  
  Future<Map<String, dynamic>> getAlbum(String albumId) async {
    final response = await _get('getAlbum', {'id': albumId});
    final albumData = response['album'];
    
    final album = Album.fromJson(albumData);
    final songList = albumData['song'] as List?;
    final songs = songList?.map((json) => Song.fromJson(json)).toList() ?? [];
    
    return {
      'album': album,
      'songs': songs,
    };
  }
  
  Future<List<Song>> getRandomSongs({int size = 50}) async {
    final response = await _get('getRandomSongs', {'size': size.toString()});
    final songList = response['randomSongs']['song'] as List?;
    if (songList == null) return [];
    
    return songList.map((json) => Song.fromJson(json)).toList();
  }
  
  Future<List<Song>> search(String query) async {
    final response = await _get('search3', {
      'query': query,
      'artistCount': '20',
      'albumCount': '20',
      'songCount': '50',
    });
    
    final searchResult = response['searchResult3'];
    final songList = searchResult['song'] as List?;
    if (songList == null) return [];
    
    return songList.map((json) => Song.fromJson(json)).toList();
  }
  
  // Media URLs
  String getStreamUrl(String songId) {
    return _buildUrl('stream', {'id': songId});
  }
  
  String getCoverArtUrl(String coverArtId, {int size = 300}) {
    return _buildUrl('getCoverArt', {
      'id': coverArtId,
      'size': size.toString(),
    });
  }
  
  // Favorites
  Future<void> star(String id, {String type = 'song'}) async {
    await _get('star', {'id': id});
  }
  
  Future<void> unstar(String id, {String type = 'song'}) async {
    await _get('unstar', {'id': id});
  }
  
  Future<List<Song>> getStarred() async {
    final response = await _get('getStarred2');
    final starredData = response['starred2'];
    final songList = starredData['song'] as List?;
    if (songList == null) return [];
    
    return songList.map((json) => Song.fromJson(json)).toList();
  }
}
