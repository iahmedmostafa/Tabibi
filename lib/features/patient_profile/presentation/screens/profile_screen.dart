import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

import 'package:go_router/go_router.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/logout_dialog.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(), // Inject ProfileCubit
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is LogOutSuccess) {
            context.go(AppRoutes.login);
          } else if (state is LogOutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                AppStrings.profile,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppHeight.h24),
                  // Profile Header
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: AppColors.grey200,
                        backgroundImage: const AssetImage(
                          AppImages.carouselImage,
                        ), // Placeholder or handle dynamic
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: AppColors.midnightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h16),
                  Text(
                    "Daniel Martinez", // TODO: Get from State
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: AppHeight.h8),
                  Text(
                    "+123 856479683", // TODO: Get from State
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: AppHeight.h32),

                  // Menu Items
                  ProfileMenuItem(
                    icon: CupertinoIcons.person,
                    text: AppStrings.editProfile,
                    onTap: () {},
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.heart,
                    text: AppStrings
                        .favorites, // Was AppStrings.favorite, adjusted to favorites
                    onTap: () {
                      context.pushNamed(AppRoutes.favorites);
                    },
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.bell,
                    text: AppStrings.notification, // Was notifications
                    onTap: () {
                      context.pushNamed(AppRoutes.notifications);
                    },
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.settings,
                    text: AppStrings.settings,
                    onTap: () {},
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.question_circle,
                    text: AppStrings.helpAndSupport,
                    onTap: () {},
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.shield,
                    text: AppStrings.termsAndConditions,
                    onTap: () {},
                  ),
                  Divider(
                    color: AppColors.grey100,
                    indent: AppWidth.w20,
                    endIndent: AppWidth.w20,
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: AppStrings.logOut,
                    isLogout: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => LogoutDialog(
                          onLogout: () {
                            ServerConnection().disconnect();
                            context.read<ProfileCubit>().logOut();
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppHeight.h40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
