import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/approved_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/new_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/pending_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/rejected_page.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_state.dart';

class DoctorStatusHandler extends StatelessWidget {
  const DoctorStatusHandler({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
      builder: (context, state) {
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
              child: _buildStatusPage(context, status),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPage(
    BuildContext context, [
    DoctorStatus status = DoctorStatus.Pending,
  ]) {
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
}
