# Subsonic Flutter Client

A modern, beautiful Subsonic Android client built with Flutter featuring glassmorphism UI design inspired by QQ Music and NetEase Cloud Music.

## Features

- 🎵 **Complete Music Library**: Browse artists, albums, and songs from your Subsonic server
- 🔍 **Powerful Search**: Search across your entire music collection
- ❤️ **Favorites**: Star and manage your favorite tracks
- 🎨 **Glassmorphic UI**: Modern, beautiful interface with glassmorphism design
- 🎧 **Music Playback**: High-quality audio streaming with player controls
- 🔒 **Secure Authentication**: Username and password authentication with MD5 token
- 📱 **Android Optimized**: Native Android experience

## Screenshots

*Screenshots will be added here*

## Requirements

- Android 5.0 (API level 21) or higher
- A Subsonic server (or compatible server like Airsonic, Navidrome)
- Active internet connection

## Installation

### From Source

1. Install Flutter SDK (https://flutter.dev/docs/get-started/install)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` for development or `flutter build apk --release` for production build

## Configuration

On first launch:
1. Enter your Subsonic server URL (e.g., `https://music.example.com`)
2. Enter your username
3. Enter your password
4. Tap "Login"

The app will authenticate and download your music library.

## Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Audio Playback**: just_audio
- **HTTP Client**: Dio
- **Local Storage**: Hive + Shared Preferences
- **UI Components**: Custom glassmorphic widgets

## Architecture

```
lib/
├── config/          # App configuration and themes
├── models/          # Data models (Song, Album, Artist)
├── providers/       # State management providers
├── screens/         # UI screens
│   ├── auth/        # Login screen
│   ├── home/        # Main home screen
│   ├── library/     # Library views (albums, artists, search)
│   └── player/      # Music player
├── services/        # API services
├── widgets/         # Reusable widgets
│   ├── common/      # Common widgets
│   └── glassmorphic/ # Glassmorphic UI components
└── utils/           # Utility functions
```

## Subsonic API

This app uses the Subsonic API v1.16.1 and supports:
- Authentication (ping, user authentication)
- Browsing (getArtists, getAlbumList2, getAlbum)
- Search (search3)
- Streaming (stream, getCoverArt)
- Favorites (star, unstar, getStarred2)

## Development

### Running Tests

```bash
flutter test
```

### Building for Release

```bash
flutter build apk --release
```

or for app bundle:

```bash
flutter build appbundle --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Subsonic API documentation
- Flutter and Dart teams
- QQ Music and NetEase Cloud Music for UI/UX inspiration

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
