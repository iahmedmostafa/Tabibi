import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/logout_dialog.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: CupertinoIcons.person,
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
          icon: CupertinoIcons.heart,
          text: AppStrings.favorites,
          onTap: () {
            context.pushNamed(AppRoutes.favorites);
          },
        ),
        _buildDivider(context),
        ProfileMenuItem(
          icon: CupertinoIcons.bell,
          text: AppStrings.notification,
          onTap: () {
            context.pushNamed(AppRoutes.notifications);
          },
        ),
        _buildDivider(context),
        ProfileMenuItem(
          icon: CupertinoIcons.settings,
          text: AppStrings.settings,
          onTap: () {},
        ),
        _buildDivider(context),
        ProfileMenuItem(
          icon: CupertinoIcons.question_circle,
          text: AppStrings.helpAndSupport,
          onTap: () {},
        ),
        _buildDivider(context),
        ProfileMenuItem(
          icon: CupertinoIcons.shield,
          text: AppStrings.termsAndConditions,
          onTap: () {},
        ),
        _buildDivider(context),
        ProfileMenuItem(
          icon: Icons.logout,
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
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor,
      indent: AppWidth.w20,
      endIndent: AppWidth.w20,
    );
  }
}
