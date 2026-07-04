import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CreatePrescriptionSubmitBar extends StatelessWidget {
  const CreatePrescriptionSubmitBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CreatePrescriptionCubit, CreatePrescriptionState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.grey800 : AppColors.grey200,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.canSubmit
                    ? context.read<CreatePrescriptionCubit>().submit
                    : null,
                icon: isLoading
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Iconsax.tick_circle),
                label: Text(
                  isLoading
                      ? 'savingPrescription'.tr()
                      : 'savePrescription'.tr(),
                  style: AppTextStyle.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midnightBlue,
                  disabledBackgroundColor: isDark
                      ? AppColors.grey800
                      : AppColors.grey400,
                  disabledForegroundColor: isDark
                      ? AppColors.grey500
                      : Colors.white,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
