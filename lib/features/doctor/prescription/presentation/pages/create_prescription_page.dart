import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/create_prescription_form.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/create_prescription_submit_bar.dart';

class CreatePrescriptionPage extends StatelessWidget {
  final CreatePrescriptionArgs args;

  const CreatePrescriptionPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePrescriptionCubit, CreatePrescriptionState>(
      listener: _handlePrescriptionState,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            AppStrings.doctorCreatePrescription,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
        ),
        bottomNavigationBar: const CreatePrescriptionSubmitBar(),
        body: CreatePrescriptionForm(args: args),
      ),
    );
  }

  void _handlePrescriptionState(
    BuildContext context,
    CreatePrescriptionState state,
  ) {
    if (state.status == CreatePrescriptionStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription saved and appointment completed.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop(true);
      return;
    }

    if (state.hasFailureFeedback) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Failed to save prescription.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
