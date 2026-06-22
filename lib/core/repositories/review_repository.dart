import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:movie_track/core/models/review.dart';

/// Persists reviews to a JSON file in the app documents directory.
class ReviewRepository {
  static const String _fileName = 'reviews.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Review>> loadAll() async {
    try {
      final file = await _file();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final list = jsonDecode(content) as List<dynamic>;
      return list
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Review>> reviewsFor(int movieId) async {
    final all = await loadAll();
    return all.where((r) => r.movieId == movieId).toList();
  }

  Future<List<Review>> addReview(Review review) async {
    final all = await loadAll();
    final updated = [review, ...all];
    final file = await _file();
    await file.writeAsString(jsonEncode(updated.map((e) => e.toJson()).toList()));
    return updated;
  }
}
