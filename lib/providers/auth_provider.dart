import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/subsonic_api_service.dart';
import '../config/app_config.dart';

class AuthProvider with ChangeNotifier {
  final SubsonicApiService _api = SubsonicApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _serverUrl;
  String? _username;
  String? _errorMessage;
  
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get serverUrl => _serverUrl;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  SubsonicApiService get api => _api;
  
  AuthProvider() {
    _loadAuthData();
  }
  
  Future<void> _loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(AppConfig.keyIsLoggedIn) ?? false;
      _serverUrl = prefs.getString(AppConfig.keyServerUrl);
      _username = prefs.getString(AppConfig.keyUsername);
      
      if (_isLoggedIn && _serverUrl != null && _username != null) {
        final password = await _secureStorage.read(key: AppConfig.keyPassword);
        if (password != null) {
          _api.configure(_serverUrl!, _username!, password);
        } else {
          _isLoggedIn = false;
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth data: $e');
    }
  }
  
  Future<bool> login(String serverUrl, String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Configure API
      _api.configure(serverUrl, username, password);
      
      // Test connection
      final success = await _api.ping();
      
      if (success) {
        // Save credentials
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConfig.keyServerUrl, serverUrl);
        await prefs.setString(AppConfig.keyUsername, username);
        await prefs.setBool(AppConfig.keyIsLoggedIn, true);
        await _secureStorage.write(key: AppConfig.keyPassword, value: password);
        
        _isLoggedIn = true;
        _serverUrl = serverUrl;
        _username = username;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to connect to server';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.keyServerUrl);
      await prefs.remove(AppConfig.keyUsername);
      await prefs.setBool(AppConfig.keyIsLoggedIn, false);
      await _secureStorage.delete(key: AppConfig.keyPassword);
      
      _isLoggedIn = false;
      _serverUrl = null;
      _username = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
}
