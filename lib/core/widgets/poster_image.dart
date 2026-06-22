import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/constants/app_constants.dart';

/// Cached poster/backdrop image with the 1px inner border the design system
/// requires so light posters don't bleed into the UI.
class PosterImage extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;

  const PosterImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadiusToken.md,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: path != null && path!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: '${AppConstants.imageBaseUrl}$path',
              width: width,
              height: height,
              fit: fit,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColor.surfaceContainer,
      );

  Widget _fallback() => Container(
        width: width,
        height: height,
        color: AppColor.surfaceContainer,
        child: const Center(
          child: Icon(PhosphorIconsBold.filmSlate,
              color: AppColor.textMuted, size: 32),
        ),
      );
}
