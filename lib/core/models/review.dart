import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// A user-written movie review, persisted to the reviews JSON file.
@freezed
class Review with _$Review {
  const factory Review({
    required int movieId,
    required String movieTitle,
    required String reviewerName,
    required int rating, // 1..5 stars
    required String comment,
    required String createdAt, // ISO-8601 string
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
