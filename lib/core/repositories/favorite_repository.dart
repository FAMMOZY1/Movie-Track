import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:movie_track/core/models/favorite_movie.dart';

/// Persists favorites to a JSON file in the app documents directory.
class FavoriteRepository {
  static const String _fileName = 'favorites.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<FavoriteMovie>> loadFavorites() async {
    try {
      final file = await _file();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final list = jsonDecode(content) as List<dynamic>;
      return list
          .map((e) => FavoriteMovie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(List<FavoriteMovie> favorites) async {
    final file = await _file();
    final jsonList = favorites.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<FavoriteMovie>> addFavorite(FavoriteMovie movie) async {
    final favorites = await loadFavorites();
    if (favorites.any((m) => m.id == movie.id)) return favorites;
    final updated = [...favorites, movie];
    await _save(updated);
    return updated;
  }

  Future<List<FavoriteMovie>> removeFavorite(int movieId) async {
    final favorites = await loadFavorites();
    final updated = favorites.where((m) => m.id != movieId).toList();
    await _save(updated);
    return updated;
  }

  Future<bool> isFavorite(int movieId) async {
    final favorites = await loadFavorites();
    return favorites.any((m) => m.id == movieId);
  }
}
