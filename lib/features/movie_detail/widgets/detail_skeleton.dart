import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:movie_track/core/theme/export.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  Widget _bar({double? width, double height = 14}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadiusToken.sm),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColor.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: AppColor.surfaceContainer),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColor.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadiusToken.md),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bar(height: 20),
                        const SizedBox(height: 8),
                        _bar(width: 100, height: 16),
                        const SizedBox(height: 8),
                        _bar(width: 130),
                        const SizedBox(height: 4),
                        _bar(width: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _bar(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
