import 'package:fitness_app/features/home/presentation/widgets/recommendation_item_widget.dart';
import 'package:flutter/material.dart';


class UpcomingWorkoutsWidget extends StatelessWidget {
  const UpcomingWorkoutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (_, index) {
          return const RecommendationItemWidget(
            width: 80,
            height: 80,
            image: 'https://iili.io/33p7ww7.png',
            title: 'chest',
          );
        },
      ),
    );
  }
}
