import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';

class DoctorDetailsCard extends StatelessWidget {
  final DoctorMapModel doctor;
  final VoidCallback onClose;

  const DoctorDetailsCard({
    super.key,
    required this.doctor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DoctorAvatar(avatarUrl: doctor.avatarUrl),
                SizedBox(width: 12.w),
                Expanded(child: _DoctorInfo(doctor: doctor)),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.grey400,
                  onPressed: onClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _DoctorAvatar({this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.grey100,
        image: avatarUrl != null
            ? DecorationImage(
                image: CachedNetworkImageProvider(avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: avatarUrl == null
          ? const Icon(Icons.person, color: AppColors.grey400, size: 40)
          : null,
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  final DoctorMapModel doctor;

  const _DoctorInfo({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.midnightBlue,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          doctor.department ?? "Specialist",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        SizedBox(height: 8.h),
        _LocationRow(address: doctor.clinicName),
        SizedBox(height: 8.h),
        _RatingAndPriceRow(consultationFee: doctor.consultationFee),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String? address;

  const _LocationRow({this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 14.sp, color: AppColors.grey500),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            address ?? "Location unavailable",
            style: TextStyle(fontSize: 12.sp, color: AppColors.grey500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RatingAndPriceRow extends StatelessWidget {
  final double consultationFee;

  const _RatingAndPriceRow({required this.consultationFee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.warning, size: 16),
        SizedBox(width: 4.w),
        Text(
          "5.0",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.midnightBlue,
          ),
        ),
        SizedBox(width: 8.w),
        Container(height: 12, width: 1, color: AppColors.grey300),
        SizedBox(width: 8.w),
        Text(
          "\$${consultationFee.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.midnightBlue,
          ),
        ),
      ],
    );
  }
}
