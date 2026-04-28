import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class DoctorDetailsHeader extends StatelessWidget {
  final DoctorDetails doctor;

  const DoctorDetailsHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.grey100,
            image: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(doctor.avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage(
                    AppImages.onboarding3,
                    ), // Fallback
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                doctor.department,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      doctor.address,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
