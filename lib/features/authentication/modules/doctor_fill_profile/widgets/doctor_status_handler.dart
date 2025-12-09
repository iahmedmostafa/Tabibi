import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/approved_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/new_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/pending_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/rejected_page.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_state.dart';

class DoctorStatusHandler extends StatelessWidget {
  const DoctorStatusHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
      listenWhen: (prev, curr) =>
          prev.doctorStatus != curr.doctorStatus &&
          curr.doctorStatus == DoctorStatusAction.success,
      listener: (context, state) {
        final status = state.newDoctorStatus;
        if (status != null) {
          // Navigate immediately to the status page
          _navigateToStatusPage(context, status);
        }
      },
      builder: (context, state) {
        // Show appropriate page based on current status
        final status = state.newDoctorStatus ?? DoctorStatus.Pending;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<DoctorProfileCubit>().getDoctorStatus();
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _buildStatusPage(status),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildStatusPage(DoctorStatus status) {
    switch (status) {
      case DoctorStatus.Pending:
        return const PendingPage();
      case DoctorStatus.Approved:
        return const ApprovedPage();
      case DoctorStatus.New:
        return const NewPage();
      case DoctorStatus.Rejected:
        return const RejectedPage();
    }
  }

  static void _navigateToStatusPage(BuildContext context, DoctorStatus status) {
    switch (status) {
      case DoctorStatus.Pending:
        context.goNamed(AppRoutes.pending);
        break;
      case DoctorStatus.Approved:
        context.goNamed(AppRoutes.approved);
        break;
      case DoctorStatus.New:
        context.goNamed(AppRoutes.newpage);
        break;
      case DoctorStatus.Rejected:
        context.goNamed(AppRoutes.rejected);
        break;
    }
  }

  /// Static method to navigate to status page from outside the widget tree
  static void navigateTo(BuildContext context, DoctorStatus status) {
    _navigateToStatusPage(context, status);
  }
}
