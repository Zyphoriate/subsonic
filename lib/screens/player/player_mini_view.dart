import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/player_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glassmorphic/glassmorphic_container.dart';

class PlayerMiniView extends StatelessWidget {
  const PlayerMiniView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PlayerProvider, AuthProvider>(
      builder: (context, playerProvider, authProvider, _) {
        final song = playerProvider.currentSong;
        if (song == null) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassmorphicContainer(
            padding: const EdgeInsets.all(12),
            opacity: 0.2,
            blur: 15,
            child: Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: song.coverArt != null
                      ? CachedNetworkImage(
                          imageUrl: authProvider.api.getCoverArtUrl(song.coverArt!),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 48,
                            height: 48,
                            color: Colors.white10,
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 48,
                            height: 48,
                            color: Colors.white10,
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: Colors.white30,
                            ),
                          ),
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: Colors.white10,
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white30,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                
                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        song.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (song.artist != null)
                        Text(
                          song.artist!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // Play/Pause button
                IconButton(
                  icon: Icon(
                    playerProvider.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    size: 40,
                  ),
                  onPressed: () {
                    if (playerProvider.isPlaying) {
                      playerProvider.pause();
                    } else {
                      playerProvider.play();
                    }
                  },
                ),
                
                // Next button
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () {
                    playerProvider.next();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
