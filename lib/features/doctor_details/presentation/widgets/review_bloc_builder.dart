import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class ReviewBlocBuilder extends StatelessWidget {
  const ReviewBlocBuilder({super.key, required this.details});

  final DoctorDetails details;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.reviews,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            context.push('${AppRoutes.doctorReviews}/${details.id}');
          },
          child: Text(AppStrings.seeAll),
        ),
      ],
    );
  }
}
