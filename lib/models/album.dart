class Album {
  final String id;
  final String name;
  final String? artist;
  final String? artistId;
  final String? coverArt;
  final int? songCount;
  final int? duration;
  final int? year;
  final String? genre;
  final DateTime? created;
  final bool? starred;

  Album({
    required this.id,
    required this.name,
    this.artist,
    this.artistId,
    this.coverArt,
    this.songCount,
    this.duration,
    this.year,
    this.genre,
    this.created,
    this.starred,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['album'] as String? ?? 'Unknown',
      artist: json['artist'] as String?,
      artistId: json['artistId'] as String?,
      coverArt: json['coverArt'] as String?,
      songCount: json['songCount'] as int?,
      duration: json['duration'] as int?,
      year: json['year'] as int?,
      genre: json['genre'] as String?,
      created: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
      starred: json['starred'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'artistId': artistId,
      'coverArt': coverArt,
      'songCount': songCount,
      'duration': duration,
      'year': year,
      'genre': genre,
      'created': created?.toIso8601String(),
      'starred': starred,
    };
  }
}
