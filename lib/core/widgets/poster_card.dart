import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/utils/date_utils.dart';
import 'poster_image.dart';
import 'rating_badge.dart';

/// Vertical movie card: 2:3 poster with rating badge overlay, title + metadata
/// below. Used in home shelves, search results, and grids.
class PosterCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final VoidCallback onTap;
  final Widget? cornerAction;

  const PosterCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 160,
    this.cornerAction,
  });

  @override
  Widget build(BuildContext context) {
    final year = AppDateUtils.formatYear(movie.releaseDate);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
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
                      top: 8,
                      right: 8,
                      child: RatingBadge(rating: movie.voteAverage),
                    ),
                  if (cornerAction != null)
                    Positioned(top: 8, left: 8, child: cornerAction!),
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
              year,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
