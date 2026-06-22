import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/features/review/cubit/review/review_cubit.dart';
import 'package:movie_track/core/models/review.dart';
import 'package:movie_track/core/theme/export.dart';

class ReviewScreen extends StatelessWidget {
  final int movieId;
  final String movieTitle;
  final String? posterPath;
  final String? subtitle;
  final double? rating;

  const ReviewScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
    this.posterPath,
    this.subtitle,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewCubit(),
      child: _ReviewView(
        movieId: movieId,
        movieTitle: movieTitle,
        posterPath: posterPath,
        subtitle: subtitle,
        rating: rating,
      ),
    );
  }
}

class _ReviewView extends StatefulWidget {
  final int movieId;
  final String movieTitle;
  final String? posterPath;
  final String? subtitle;
  final double? rating;

  const _ReviewView({
    required this.movieId,
    required this.movieTitle,
    this.posterPath,
    this.subtitle,
    this.rating,
  });

  @override
  State<_ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<_ReviewView> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _stars = 0;
  bool _submitted = false;
  bool _ratingError = false;

  void _submit() {
    final formValid = _formKey.currentState?.saveAndValidate() ?? false;
    final ratingValid = _stars > 0;
    setState(() => _ratingError = !ratingValid);
    if (!formValid || !ratingValid) return;

    final values = _formKey.currentState!.value;
    final review = Review(
      movieId: widget.movieId,
      movieTitle: widget.movieTitle,
      reviewerName: (values['name'] as String).trim(),
      rating: _stars,
      comment: (values['comment'] as String).trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    setState(() => _submitted = true);
    context.read<ReviewCubit>().submitReview(review);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.primary,
        content: Text('Review submitted for "${widget.movieTitle}"!'),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(PhosphorIconsBold.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: const Text('Write a Review'),
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadiusToken.md),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColor.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadiusToken.normal),
                      border: Border.all(color: AppColor.outlineVariant),
                    ),
                    child: const Icon(PhosphorIconsBold.filmSlate,
                        color: AppColor.textMuted),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.movieTitle,
                            style: theme.textTheme.titleSmall),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(widget.subtitle!,
                              style: theme.textTheme.bodySmall),
                        ],
                        if (widget.rating != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(PhosphorIconsFill.star,
                                  color: AppColor.rating, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.rating!.toStringAsFixed(1)} RATING',
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: AppColor.rating),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DISPLAY NAME', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'name',
                    style: const TextStyle(color: AppColor.onSurface),
                    decoration: const InputDecoration(
                      hintText: 'Enter your reviewer name',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Name is required'),
                      FormBuilderValidators.minLength(2,
                          errorText: 'Minimum 2 characters'),
                      FormBuilderValidators.maxLength(50,
                          errorText: 'Maximum 50 characters'),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Text('YOUR RATING', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      final filled = i < _stars;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _stars = i + 1;
                          _ratingError = false;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            filled
                                ? PhosphorIconsFill.star
                                : PhosphorIconsBold.star,
                            color: filled
                                ? AppColor.rating
                                : AppColor.outline,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  if (_ratingError) ...[
                    const SizedBox(height: 6),
                    Text('Please select a rating',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColor.error)),
                  ],
                  const SizedBox(height: 20),
                  Text('YOUR REVIEW', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'comment',
                    maxLines: 6,
                    style: const TextStyle(color: AppColor.onSurface),
                    decoration: const InputDecoration(
                      hintText:
                          'What did you think of the story, visuals, and acting?',
                      alignLabelWithHint: true,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Review is required'),
                      FormBuilderValidators.minLength(10,
                          errorText: 'Minimum 10 characters'),
                      FormBuilderValidators.maxLength(500,
                          errorText: 'Maximum 500 characters'),
                    ]),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitted ? null : _submit,
                      icon: _submitted
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(PhosphorIconsBold.paperPlaneTilt,
                              size: 18),
                      label: Text(
                          _submitted ? 'Submitting...' : 'Submit Review'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Your review will be public and associated with your\nMovieTrack account. Please be respectful and avoid spoilers.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
