import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String doctorName;
  final String? doctorImage;

  const ChatAppBar({required this.doctorName, this.doctorImage, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = doctorImage != null && doctorImage!.isNotEmpty;

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
            backgroundImage: hasImage
                ? CachedNetworkImageProvider(doctorImage!)
                : null,
            child: !hasImage
                ? Icon(Icons.person_rounded, color: Colors.white, size: 22.sp)
                : null,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName.isNotEmpty ? 'Dr. $doctorName' : 'Doctor',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
