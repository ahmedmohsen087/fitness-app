import 'package:fitness_app/features/home/presentation/widgets/recommendation_item_widget.dart';
import 'package:flutter/material.dart';

class RecommendationForYouWidget extends StatelessWidget {
  const RecommendationForYouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (_, index) {
          return const RecommendationItemWidget(
            image:'https://www.themealdb.com/images/category/chicken.png',
            title: 'text',
          );
        },
      ),
    );
  }
}
