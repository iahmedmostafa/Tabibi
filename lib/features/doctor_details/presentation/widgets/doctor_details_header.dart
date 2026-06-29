import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class DoctorDetailsHeader extends StatelessWidget {
  final DoctorDetails doctor;

  const DoctorDetailsHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorName = doctor.name.startsWith('Dr.') ? doctor.name : 'Dr. ${doctor.name}';
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 90.w,
              height: 90.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey100,
                image: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(doctor.avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(AppImages.person), 
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: 2.h,
              right: 2.w,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(2.r),
                child: Icon(
                  Icons.verified,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                doctor.department,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Iconsax.location5,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      doctor.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Iconsax.map,
                    size: 16.sp,
                    color: AppColors.primary,
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
