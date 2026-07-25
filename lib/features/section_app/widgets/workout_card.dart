import 'package:fitness_app/core/reusable_widgets/custom_media_card.dart';
import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMediaCard(
      image: image,
      title: title,
      onTap: onTap,
      borderRadius: 20.0,
      style: CustomMediaCardStyle.pillOverlay,
    );
  }
}
