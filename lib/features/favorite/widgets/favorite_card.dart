import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/models/favorite_movie.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/poster_image.dart';
import 'package:movie_track/core/widgets/rating_badge.dart';
import 'package:movie_track/core/utils/date_utils.dart';

/// Favorite poster card with a trash button overlay (top-right) that triggers
/// the remove modal.
class FavoriteCard extends StatelessWidget {
  final FavoriteMovie movie;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavoriteCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final year = AppDateUtils.formatYear(movie.releaseDate);
    final subtitle =
        movie.genre.isNotEmpty ? '$year โ€ข ${movie.genre}' : year;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadiusToken.md),
                    border: Border.all(color: AppColor.outlineVariant),
                  ),
                  child: PosterImage(
                    path: movie.posterPath,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                if (movie.voteAverage > 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: RatingBadge(rating: movie.voteAverage),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: AppColor.surface.withValues(alpha: 0.7),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onRemove,
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(PhosphorIconsBold.trash,
                            size: 18, color: AppColor.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
