import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/widgets/success_dialog.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_state.dart';

class ProfileActionButton extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNextPage;
  final VoidCallback onSubmit;

  const ProfileActionButton({
    super.key,
    required this.currentPage,
    required this.onNextPage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorProfileCubit, DoctorProfileState>(
      listener: (context, state) {
    
        if (state.updateStatus == DoctorProfileUpdateStatus.loading) {
          EasyLoading.show(status: 'Loading...');
        }
        // Handle profile update success
        else if (state.updateStatus == DoctorProfileUpdateStatus.success) {
          EasyLoading.dismiss();
          log('Profile updated successfully, showing success dialog...');

          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const SuccessDialog(),
          );

          // After 2 seconds, close dialog and navigate to pending, then fetch status
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pop(context); // Close success dialog
              context.go(AppRoutes.doctorStatusHandler);
            }
          });
        }
        // Handle profile update failure
        else if (state.updateStatus == DoctorProfileUpdateStatus.failure) {
          EasyLoading.dismiss();
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'Error',
            message: state.errorMessage ?? 'Failed to update profile',
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: PrimaryButton(
        onPress: currentPage < 3 ? onNextPage : onSubmit,
        title: currentPage == 3 ? AppStrings.saveFillProfile : "Next",
      ),
    );
  }
}
