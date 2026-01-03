import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/library_provider.dart';
import '../../widgets/glassmorphic/glassmorphic_container.dart';
import '../../widgets/glassmorphic/glassmorphic_textfield.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    
    setState(() {
      _isSearching = true;
    });
    
    final libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
    final results = await libraryProvider.search(query);
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                
                // Search field
                GlassmorphicTextField(
                  hint: 'Search songs, albums, artists...',
                  controller: _searchController,
                  prefixIcon: Icons.search_rounded,
                  onChanged: (value) {
                    _performSearch(value);
                  },
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Search for music',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassmorphicContainer(
            padding: const EdgeInsets.all(12),
            opacity: 0.1,
            child: ListTile(
              leading: const Icon(
                Icons.music_note_rounded,
                color: Colors.white70,
              ),
              title: Text(
                item.title ?? 'Unknown',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '${item.artist ?? 'Unknown'} • ${item.album ?? 'Unknown'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                item.durationFormatted ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
