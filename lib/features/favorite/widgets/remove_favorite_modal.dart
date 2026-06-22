import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/models/favorite_movie.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/poster_image.dart';
import 'package:movie_track/core/utils/date_utils.dart';

/// Bottom sheet confirming removal of a movie from favorites.
/// Returns `true` from `showModalBottomSheet` if the user confirms.
class RemoveFavoriteModal extends StatelessWidget {
  final FavoriteMovie movie;

  const RemoveFavoriteModal({super.key, required this.movie});

  static Future<bool> show(BuildContext context, FavoriteMovie movie) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColor.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadiusToken.xl)),
      ),
      builder: (_) => RemoveFavoriteModal(movie: movie),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final year = AppDateUtils.formatYear(movie.releaseDate);
    final runtime = movie.runtime > 0
        ? '${movie.runtime ~/ 60}h ${movie.runtime % 60}m'
        : '';
    final subtitle = [
      if (movie.genre.isNotEmpty) movie.genre,
      if (runtime.isNotEmpty) runtime else if (year != 'N/A') year,
    ].join(' โ€ข ');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColor.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Remove from favorites?',
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This movie will be removed from your favorites list.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadiusToken.md),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  PosterImage(
                    path: movie.posterPath,
                    width: 48,
                    height: 48,
                    radius: AppRadiusToken.normal,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(subtitle, style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(PhosphorIconsBold.trash, size: 18),
                label: const Text('Remove'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.errorContainer,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
