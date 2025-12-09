import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_state.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/schedule_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/clinic_info_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/credentials_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/personal_info_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_action_button.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_page_header.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_progress_indicator.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_state.dart';

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
    _loadDoctorProfile();
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

  void _loadDoctorProfile() {
    final cubit = context.read<DoctorProfileCubit>();
    cubit.getDoctorProfile();

    if (cubit.state.status == DoctorProfileStatus.success) {
      _populateControllers(cubit.state);
    }
  }

  void _populateControllers(DoctorProfileState state) {
    _nameController.text = state.profile?.name ?? '';
    _bioController.text = state.profile?.bio ?? '';
    _consultationFeeController.text =
        state.profile?.consultationFee.toString() ?? '';
    _yearsOfExperienceController.text =
        state.profile?.yearsOfExperience.toString() ?? '';
    _departmentIdController.text = state.profile?.departmentId ?? '';
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
    formCubit.nextPage();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleSubmit(DoctorFillProfileFormState formState) {
    final uploadedImageUrl = context.read<UploadImageCubit>().uploadedImageUrl;
    final uploadedClinicImageUrl = context.read<ClinicUploadImageCubit>().uploadedImageUrl;
    final credentialImageUrl = context.read<CredentialUploadImageCubit>().uploadedImageUrl;

    log('Submitting profile: ${_nameController.text}');

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
      clinicURL: uploadedClinicImageUrl,
      clinicAddress: _clinicAddressController.text,
      clinicPhoneNumber: _clinicPhoneController.text,
      clinicCity: formState.selectedClinicCityId,
      schedule: formState.schedules,
    );

    context.read<DoctorProfileCubit>().updateDoctorProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<DoctorFillProfileFormCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<DoctorProfileCubit, DoctorProfileState>(
          listener: (context, state) {
            if (state.status == DoctorProfileStatus.success &&
                _nameController.text.isEmpty) {
              _populateControllers(state);
              log('Profile loaded: ${_nameController.text}');
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
              child:
                  BlocBuilder<DoctorFillProfileFormCubit, DoctorFillProfileFormState>(
                    builder: (context, formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileProgressIndicator(
                            currentPage: formState.currentPage,
                            totalPages: 4,
                          ),
                          ProfilePageHeader(
                            currentPage: formState.currentPage,
                            totalPages: 4,
                            onBackPressed: () => _handleBackPressed(formCubit),
                          ),
                          SizedBox(
                            height: AppHeight.h595,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                formCubit.setCurrentPage(index);
                              },
                              children: [
                                PersonalInfoPage(
                                  nameController: _nameController,
                                  bioController: _bioController,
                                  gender: formState.gender,
                                  selectedBirthdate:
                                      formState.selectedBirthdate,
                                  selectedCityId:
                                      formState.selectedDoctorCityId,
                                  onGenderChanged: formCubit.setGender,
                                  onBirthdateSelected: formCubit.setBirthdate,
                                  onCitySelected: formCubit.setDoctorCity,
                                ),
                                CredentialsPage(
                                  selectedDepartmentId:
                                      formState.selectedDepartmentId,
                                  onDepartmentSelected: (departmentId) {
                                    formCubit.setDepartment(departmentId);
                                    _departmentIdController.text =
                                        departmentId ?? '';
                                  },
                                ),
                                ClinicInfoPage(
                                  clinicNameController: _clinicNameController,
                                  clinicAddressController:
                                      _clinicAddressController,
                                  clinicPhoneController: _clinicPhoneController,
                                  consultationFeeController:
                                      _consultationFeeController,
                                  yearsOfExperienceController:
                                      _yearsOfExperienceController,
                                  selectedClinicCityId:
                                      formState.selectedClinicCityId,
                                  onClinicCitySelected: formCubit.setClinicCity,

                                ),
                                SchedulePage(
                                  onScheduleChanged: formCubit.setSchedules,
                                ),
                              ],
                            ),
                          ),
                          VerticalSpace(height: AppHeight.h20),
                          ProfileActionButton(
                            currentPage: formState.currentPage,
                            onNextPage: () => _handleNextPage(formCubit),
                            onSubmit: () => _handleSubmit(formState),
                          ),
                        ],
                      );
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
