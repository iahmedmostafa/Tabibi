import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.w32,
          vertical: AppHeight.h32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F0E8), // Light green background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9DCDC0), // Darker green circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 30),
                ),
              ),
            ),
            VerticalSpace(height: AppHeight.h24),
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF242424),
              ),
            ),
            VerticalSpace(height: AppHeight.h16),
            Text(
              'Your account is ready to use. You will be redirected to the Home Page in a few seconds...',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            VerticalSpace(height: AppHeight.h24),
            const CupertinoActivityIndicator(
              radius: 15,
              color: Color(0xFF242424),
            ),
          ],
        ),
      ),
    );
  }
}
