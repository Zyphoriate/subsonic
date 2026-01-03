import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/library_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glassmorphic/glassmorphic_container.dart';

class AlbumListView extends StatelessWidget {
  const AlbumListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LibraryProvider, AuthProvider>(
      builder: (context, libraryProvider, authProvider, _) {
        final albums = libraryProvider.albums;
        
        if (albums.isEmpty) {
          return Center(
            child: Text(
              'No albums found',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => libraryProvider.loadLibrary(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              
              return GlassmorphicContainer(
                padding: const EdgeInsets.all(12),
                opacity: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album cover
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: album.coverArt != null
                            ? CachedNetworkImage(
                                imageUrl: authProvider.api.getCoverArtUrl(album.coverArt!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.white10,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white10,
                                  child: const Icon(
                                    Icons.album_rounded,
                                    size: 48,
                                    color: Colors.white30,
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.white10,
                                child: const Icon(
                                  Icons.album_rounded,
                                  size: 48,
                                  color: Colors.white30,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Album name
                    Text(
                      album.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Artist name
                    if (album.artist != null)
                      Text(
                        album.artist!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
