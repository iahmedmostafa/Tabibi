import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';

class CreatePrescriptionSubmitBar extends StatelessWidget {
  const CreatePrescriptionSubmitBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePrescriptionCubit, CreatePrescriptionState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.midnightBlue.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -8),
              ),
            ],
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
                  isLoading ? 'Saving Prescription...' : 'Save Prescription',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midnightBlue,
                  disabledBackgroundColor: AppColors.grey400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
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
