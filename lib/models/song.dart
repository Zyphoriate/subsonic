class Song {
  final String id;
  final String title;
  final String? album;
  final String? artist;
  final String? albumId;
  final String? artistId;
  final int? duration;
  final int? bitRate;
  final int? year;
  final String? genre;
  final String? coverArt;
  final int? track;
  final int? discNumber;
  final String? path;
  final String? suffix;
  final String? contentType;
  final int? size;
  final bool? starred;
  final DateTime? created;

  Song({
    required this.id,
    required this.title,
    this.album,
    this.artist,
    this.albumId,
    this.artistId,
    this.duration,
    this.bitRate,
    this.year,
    this.genre,
    this.coverArt,
    this.track,
    this.discNumber,
    this.path,
    this.suffix,
    this.contentType,
    this.size,
    this.starred,
    this.created,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Unknown',
      album: json['album'] as String?,
      artist: json['artist'] as String?,
      albumId: json['albumId'] as String?,
      artistId: json['artistId'] as String?,
      duration: json['duration'] as int?,
      bitRate: json['bitRate'] as int?,
      year: json['year'] as int?,
      genre: json['genre'] as String?,
      coverArt: json['coverArt'] as String?,
      track: json['track'] as int?,
      discNumber: json['discNumber'] as int?,
      path: json['path'] as String?,
      suffix: json['suffix'] as String?,
      contentType: json['contentType'] as String?,
      size: json['size'] as int?,
      starred: json['starred'] != null,
      created: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'album': album,
      'artist': artist,
      'albumId': albumId,
      'artistId': artistId,
      'duration': duration,
      'bitRate': bitRate,
      'year': year,
      'genre': genre,
      'coverArt': coverArt,
      'track': track,
      'discNumber': discNumber,
      'path': path,
      'suffix': suffix,
      'contentType': contentType,
      'size': size,
      'starred': starred,
      'created': created?.toIso8601String(),
    };
  }

  String get durationFormatted {
    if (duration == null) return '--:--';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
