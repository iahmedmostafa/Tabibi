import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.grey100,
              image: doctor.avatarUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(doctor.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.avatarUrl == null
                ? const Icon(Icons.person, color: AppColors.grey400, size: 40)
                : null,
          ),
          const HorizentalSpace(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.midnightBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: onFavoriteTap,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.error : AppColors.grey400,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                VerticalSpace(height: 4.h),
                Container(
                  height: 1,
                  color: AppColors.grey100,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                ),
                // Specialization
                Text(
                  doctor.department ?? "Specialist",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                  ),
                ),
                VerticalSpace(height: 8.h),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14.sp,
                      color: AppColors.grey500,
                    ),
                    const HorizentalSpace(width: 4),
                    Expanded(
                      child: Text(
                        doctor.address ?? "New York, USA", // Mock default
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                VerticalSpace(height: 8.h),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 16),
                    const HorizentalSpace(width: 4),
                    Text(
                      "5.0", // Mock rating
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.midnightBlue,
                      ),
                    ),
                    const HorizentalSpace(width: 8),
                    Container(height: 12, width: 1, color: AppColors.grey300),
                    const HorizentalSpace(width: 8),
                    Text(
                      "${doctor.yearsOfExperience * 10 + 5} Reviews", // Mock reviews
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
