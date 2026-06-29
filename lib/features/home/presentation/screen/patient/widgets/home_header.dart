import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/notification_badge.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final name = state is ProfileLoaded ? state.patientProfile.name : 'Guest';
        final city = state is ProfileLoaded
            ? state.patientProfile.city?.name ?? 'Your city'
            : 'Your city';
        final firstName = name.trim().split(' ').first;

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $firstName',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Location',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location5,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          city,
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey500,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const NotificationBadge(),
          ],
        );
      },
    );
  }
}
