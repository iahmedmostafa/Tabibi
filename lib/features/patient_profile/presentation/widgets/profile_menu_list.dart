import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/logout_dialog.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Main Options Card
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.grey900 : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Iconsax.user,
                  text: AppStrings.editProfile,
                  onTap: () async {
                    final result = await context.pushNamed(AppRoutes.editProfile);
                    if (result == true) {
                      if (context.mounted) {
                        context.read<ProfileCubit>().getProfile();
                      }
                    }
                  },
                ),
                _buildDivider(context),
                ProfileMenuItem(
                  icon: Iconsax.heart,
                  text: AppStrings.favorites,
                  onTap: () {
                    context.pushNamed(AppRoutes.favorites);
                  },
                ),
                _buildDivider(context),
                ProfileMenuItem(
                  icon: Iconsax.notification,
                  text: AppStrings.notification,
                  onTap: () {
                    context.pushNamed(AppRoutes.notifications);
                  },
                ),
                _buildDivider(context),
                ProfileMenuItem(
                  icon: Iconsax.setting_2,
                  text: AppStrings.settings,
                  onTap: () {},
                ),
                _buildDivider(context),
                ProfileMenuItem(
                  icon: Iconsax.info_circle,
                  text: AppStrings.helpAndSupport,
                  onTap: () {},
                ),
                _buildDivider(context),
                ProfileMenuItem(
                  icon: Iconsax.shield_security,
                  text: AppStrings.termsAndConditions,
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Log Out Card
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.grey900 : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ProfileMenuItem(
              icon: Iconsax.logout,
              text: AppStrings.logOut,
              isLogout: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => LogoutDialog(
                    onLogout: () {
                      context.read<ProfileCubit>().logOut();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return const Divider(
      color: AppColors.grey200,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
