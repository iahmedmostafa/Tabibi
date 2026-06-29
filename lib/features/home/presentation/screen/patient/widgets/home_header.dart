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
        final name = state is ProfileLoaded
            ? state.patientProfile.name
            : 'Guest';
        final city = state is ProfileLoaded
            ? state.patientProfile.city?.name ?? 'Your city'
            : 'Your city';
        final firstName = name.trim().split(' ').first;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $firstName',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.location5,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 180.w),
                          child: Text(
                            city,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.white : AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.grey500,
                          size: 18.sp,
                        ),
                      ],
                    ),
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
