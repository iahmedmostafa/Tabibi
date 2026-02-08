import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomOffset;

  const MyLocationButton({
    super.key,
    required this.onPressed,
    required this.bottomOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomOffset,
      right: 16.w,
      child: FloatingActionButton(
        heroTag: 'myLocation',
        mini: true,
        backgroundColor: Colors.white,
        onPressed: onPressed,
        child: const Icon(Icons.my_location, color: AppColors.midnightBlue),
      ),
    );
  }
}
