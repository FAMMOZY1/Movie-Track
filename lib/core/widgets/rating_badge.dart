import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/theme/export.dart';

/// Yellow value-rating badge shown on poster corners.
class RatingBadge extends StatelessWidget {
  final double rating;
  final bool showStar;

  const RatingBadge({super.key, required this.rating, this.showStar = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFACC15),
        borderRadius: BorderRadius.circular(AppRadiusToken.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showStar) ...[
            const Icon(PhosphorIconsFill.star, size: 12, color: Color(0xFF3C2F00)),
            const SizedBox(width: 2),
          ],
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xFF3C2F00),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
