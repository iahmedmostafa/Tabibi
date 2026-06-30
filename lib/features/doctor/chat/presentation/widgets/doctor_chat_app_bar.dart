import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DoctorChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String patientName;
  final String? patientImage;

  const DoctorChatAppBar({
    required this.patientName,
    this.patientImage,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = patientImage != null && patientImage!.isNotEmpty;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.midnightBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            backgroundImage:
                hasImage ? CachedNetworkImageProvider(patientImage!) : null,
            child: !hasImage
                ? Icon(Icons.person_rounded, color: Colors.white, size: 22.sp)
                : null,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patientName.isNotEmpty ? patientName : 'Patient',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Patient',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
