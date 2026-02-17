import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/profile_header.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/profile_menu_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..getProfile(),
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
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileError) {
            return Scaffold(body: Center(child: Text(state.message)));
          }

          final profile = (state is ProfileLoaded)
              ? state.patientProfile
              : null;

          if (profile == null &&
              state is! LogOutLoading &&
              state is! LogOutError &&
              state is! LogOutSuccess) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

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
                  ProfileHeader(profile: profile),
                  SizedBox(height: AppHeight.h32),

                  // Menu Items
                  const ProfileMenuList(),
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
