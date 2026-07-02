import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_error_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_cubit.dart';
import 'package:tabibi/features/doctor/profile/presentation/pages/edit_doctor_profile_page.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/account_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/availability_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/danger_zone_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/profile_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/quick_action_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/security_section.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_state.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = DoctorLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<DoctorProfileCubit>()..getDoctorProfile(),
        ),
        BlocProvider(
          create: (_) => sl<ReviewsCubit>()..getReviews(),
        ),
        BlocProvider(
          create: (_) => sl<DoctorLogoutCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(loc.settings, style: theme.textTheme.titleLarge),
          centerTitle: true,
        ),
        body: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.profile != current.profile ||
              previous.errorMessage != current.errorMessage,
          builder: (context, profileState) {
            if (profileState.status == DoctorProfileStatus.loading ||
                profileState.status == DoctorProfileStatus.initial) {
              return const DoctorLoadingState();
            }

            if (profileState.status == DoctorProfileStatus.failure) {
              return DoctorErrorState(
                message: profileState.errorMessage ?? loc.errorLoadingProfile,
                onRetry: () {
                  context.read<DoctorProfileCubit>().getDoctorProfile();
                  context.read<ReviewsCubit>().getReviews();
                },
              );
            }

            final profile = profileState.profile;
            if (profile == null) {
              return DoctorErrorState(
                message: loc.errorLoadingProfile,
                onRetry: () {
                  context.read<DoctorProfileCubit>().getDoctorProfile();
                  context.read<ReviewsCubit>().getReviews();
                },
              );
            }

            return BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, reviewsState) {
                final rating = reviewsState.summary.averageRating;
                final reviewsCount = reviewsState.summary.totalReviews;

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => Future.wait([
                    context.read<DoctorProfileCubit>().getDoctorProfile(),
                    context.read<ReviewsCubit>().getReviews(),
                  ]),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(
                          profile: profile,
                          rating: rating,
                          reviews: reviewsCount,
                          onCameraTap: () => _openEditProfile(
                            context,
                            profile,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        AccountSection(
                          profile: profile,
                          onPersonalInfoTap: () => _openEditProfile(
                            context,
                            profile,
                          ),
                          onClinicInfoTap: () => _openEditProfile(
                            context,
                            profile,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SecuritySection(
                          onChangePasswordTap: () =>
                              context.push(AppRoutes.forgotPassword),
                          onNotificationsTap: () =>
                              context.push(AppRoutes.notifications),
                        ),
                        SizedBox(height: 24.h),
                        AvailabilitySection(
                          profile: profile,
                          onTap: () => context.push(AppRoutes.doctorAvailability),
                        ),
                        SizedBox(height: 24.h),
                        const QuickActionsSection(),
                        SizedBox(height: 24.h),
                        const DangerZoneSection(),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEditProfile(
    BuildContext context,
    DoctorProfile profile,
  ) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<DoctorProfileCubit>(),
          child: EditDoctorProfilePage(profile: profile),
        ),
      ),
    );
  }
}
