import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_cubit.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/logout_dialog.dart';

class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    return BlocListener<DoctorLogoutCubit, DoctorLogoutState>(
      listener: (context, state) {
        if (state is DoctorLogoutSuccess) {
          context.go(AppRoutes.login);
        } else if (state is DoctorLogoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: isDark ? AppColors.darkRed : AppColors.error,
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: DoctorSectionHeader(title: loc.dangerZone),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: Icon(Icons.logout, size: 20.sp),
                    label: Text(loc.logOut),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                      backgroundColor: isDark
                          ? const Color(0x1AD32F2F)
                          : const Color(0xFFFFEBEE),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LogoutDialog(
        onLogout: () {
          context.read<DoctorLogoutCubit>().logOut();
        },
      ),
    );
  }
}
