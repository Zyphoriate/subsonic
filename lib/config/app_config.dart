class AppConfig {
  // API Configuration
  static const String apiVersion = '1.16.1';
  static const String clientName = 'SubsonicFlutter';
  static const String clientVersion = '1.0.0';
  
  // Storage keys
  static const String keyServerUrl = 'server_url';
  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyIsLoggedIn = 'is_logged_in';
  
  // Cache configuration
  static const int cacheMaxAge = 7; // days
  static const int imageCacheMaxAge = 30; // days
  
  // Player configuration
  static const int crossfadeDuration = 300; // milliseconds
  static const bool enableGaplessPlayback = true;
  
  // UI configuration
  static const double borderRadius = 16.0;
  static const double glassOpacity = 0.15;
  static const double glassBlur = 10.0;
}
