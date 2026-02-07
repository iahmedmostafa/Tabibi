import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class RemoveFavoriteDialog extends StatelessWidget {
  final String doctorName;
  final VoidCallback onConfirm;

  const RemoveFavoriteDialog({
    super.key,
    required this.doctorName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppWidth.w20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.removeFromFavorites,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            Divider(color: AppColors.grey200, height: AppHeight.h32),
            Text(
              AppStrings.areYouSureRemoveFavorite,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppHeight.h8),
            Text(
              doctorName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.midnightBlue,
              ),
            ),
            SizedBox(height: AppHeight.h24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.grey200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: AppHeight.h12),
                    ),
                    child: Text(
                      AppStrings.cancel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.midnightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.w12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.midnightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: AppHeight.h12),
                    ),
                    child: Text(
                      AppStrings.yesRemove,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
