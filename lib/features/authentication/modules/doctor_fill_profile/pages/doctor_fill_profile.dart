import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_state.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/clinic_location_screen.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/doctor_fill_profile_body.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';

class DoctorFillProfile extends StatefulWidget {
  const DoctorFillProfile({super.key});

  @override
  State<DoctorFillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<DoctorFillProfile> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _consultationFeeController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _departmentIdController;
  late TextEditingController _clinicNameController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _clinicPhoneController;

  // Page navigation
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _pageController = PageController();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _consultationFeeController = TextEditingController();
    _yearsOfExperienceController = TextEditingController();
    _departmentIdController = TextEditingController();
    _clinicNameController = TextEditingController();
    _clinicAddressController = TextEditingController();
    _clinicPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _consultationFeeController.dispose();
    _yearsOfExperienceController.dispose();
    _departmentIdController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleBackPressed(DoctorFillProfileFormCubit formCubit) {
    if (formCubit.state.currentPage == 0) {
      context.goNamed(AppRoutes.signUp);
      return;
    }
    formCubit.previousPage();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleNextPage(DoctorFillProfileFormCubit formCubit) {
    if (formCubit.state.currentPage == 2) {
      _openClinicLocation(formCubit);
      return;
    }

    formCubit.nextPage();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleSubmit(DoctorFillProfileFormState formState) {
    final uploadedImageUrl = context.read<UploadImageCubit>().uploadedImageUrl;
    final uploadedClinicImageUrl = context
        .read<ClinicUploadImageCubit>()
        .uploadedImageUrl;
    final credentialImageUrl = context
        .read<CredentialUploadImageCubit>()
        .uploadedImageUrl;

    final params = UpdateDoctorProfileParams(
      name: _nameController.text,
      bio: _bioController.text,
      consultationFee: double.tryParse(_consultationFeeController.text),
      yearsOfExperience: int.tryParse(_yearsOfExperienceController.text),
      departmentId: _departmentIdController.text,
      dateOfBirth: formState.selectedBirthdate,
      avatarUrl: uploadedImageUrl,
      credentialImageUrl: credentialImageUrl,
      gender: formState.gender,
      clinicName: _clinicNameController.text,
      clinicImageUrl: uploadedClinicImageUrl,
      clinicAddress: _clinicAddressController.text,
      clinicPhoneNumber: _clinicPhoneController.text,
      clinicCityId: formState.selectedClinicCityId,
      clinicLatitude: formState.clinicLatitude,
      clinicLongitude: formState.clinicLongitude,
      schedule: formState.schedules,
    );

    context.read<DoctorProfileCubit>().updateDoctorProfile(params);
  }

  Future<void> _openClinicLocation(DoctorFillProfileFormCubit formCubit) async {
    final result = await context.push<ClinicLocationResult>(
      AppRoutes.clinicLocation,
    );
    if (result != null) {
      formCubit.setClinicLocation(result.latitude, result.longitude);
      // Move to next page after selecting location
      formCubit.nextPage();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<DoctorFillProfileFormCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child:
              BlocBuilder<
                DoctorFillProfileFormCubit,
                DoctorFillProfileFormState
              >(
                builder: (context, formState) {
                  return DoctorFillProfileBody(
                    formState: formState,
                    formCubit: formCubit,
                    pageController: _pageController,
                    nameController: _nameController,
                    bioController: _bioController,
                    consultationFeeController: _consultationFeeController,
                    yearsOfExperienceController: _yearsOfExperienceController,
                    departmentIdController: _departmentIdController,
                    clinicNameController: _clinicNameController,
                    clinicAddressController: _clinicAddressController,
                    clinicPhoneController: _clinicPhoneController,
                    onBackPressed: () => _handleBackPressed(formCubit),
                    onNextPage: () => _handleNextPage(formCubit),
                    onSubmit: () => _handleSubmit(formState),
                  );
                },
              ),
        ),
      ),
    );
  }
}
