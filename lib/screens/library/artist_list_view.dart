import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/library_provider.dart';
import '../../widgets/glassmorphic/glassmorphic_container.dart';

class ArtistListView extends StatelessWidget {
  const ArtistListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, _) {
        final artists = libraryProvider.artists;
        
        if (artists.isEmpty) {
          return Center(
            child: Text(
              'No artists found',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => libraryProvider.loadLibrary(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassmorphicContainer(
                  padding: const EdgeInsets.all(16),
                  opacity: 0.1,
                  child: Row(
                    children: [
                      // Artist icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Artist info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artist.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (artist.albumCount != null)
                              Text(
                                '${artist.albumCount} album${artist.albumCount! > 1 ? 's' : ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      
                      // Arrow icon
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
