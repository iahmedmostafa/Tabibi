import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_state.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/schedule_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/clinic_info_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/credentials_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/personal_info_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_action_button.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_page_header.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/profile_progress_indicator.dart';

class DoctorFillProfileBody extends StatelessWidget {
  const DoctorFillProfileBody({
    super.key,
    required this.formState,
    required this.formCubit,
    required this.pageController,
    required this.nameController,
    required this.bioController,
    required this.consultationFeeController,
    required this.yearsOfExperienceController,
    required this.departmentIdController,
    required this.clinicNameController,
    required this.clinicAddressController,
    required this.clinicPhoneController,
    required this.onBackPressed,
    required this.onNextPage,
    required this.onSubmit,
  });

  final DoctorFillProfileFormState formState;
  final DoctorFillProfileFormCubit formCubit;
  final PageController pageController;

  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController consultationFeeController;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController departmentIdController;
  final TextEditingController clinicNameController;
  final TextEditingController clinicAddressController;
  final TextEditingController clinicPhoneController;

  final VoidCallback onBackPressed;
  final VoidCallback onNextPage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileProgressIndicator(
            currentPage: formState.currentPage,
            totalPages: 4,
          ),
          ProfilePageHeader(
            currentPage: formState.currentPage,
            totalPages: 4,
            onBackPressed: onBackPressed,
          ),
          SizedBox(
            height: AppHeight.h595,
            child: ProfilePagesView(
              formState: formState,
              formCubit: formCubit,
              pageController: pageController,
              nameController: nameController,
              bioController: bioController,
              consultationFeeController: consultationFeeController,
              yearsOfExperienceController: yearsOfExperienceController,
              departmentIdController: departmentIdController,
              clinicNameController: clinicNameController,
              clinicAddressController: clinicAddressController,
              clinicPhoneController: clinicPhoneController,
            ),
          ),
          VerticalSpace(height: AppHeight.h20),
          ProfileActionButton(
            currentPage: formState.currentPage,
            onNextPage: onNextPage,
            onSubmit: onSubmit,
          ),
        ],
      ),
    );
  }
}

class ProfilePagesView extends StatelessWidget {
  const ProfilePagesView({
    super.key,
    required this.formState,
    required this.formCubit,
    required this.pageController,
    required this.nameController,
    required this.bioController,
    required this.consultationFeeController,
    required this.yearsOfExperienceController,
    required this.departmentIdController,
    required this.clinicNameController,
    required this.clinicAddressController,
    required this.clinicPhoneController,
  });

  final DoctorFillProfileFormState formState;
  final DoctorFillProfileFormCubit formCubit;
  final PageController pageController;

  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController consultationFeeController;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController departmentIdController;
  final TextEditingController clinicNameController;
  final TextEditingController clinicAddressController;
  final TextEditingController clinicPhoneController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: formCubit.setCurrentPage,
      children: [
        PersonalInfoPage(
          nameController: nameController,
          bioController: bioController,
          gender: formState.gender,
          selectedBirthdate: formState.selectedBirthdate,
          selectedCityId: formState.selectedDoctorCityId,
          onGenderChanged: formCubit.setGender,
          onBirthdateSelected: formCubit.setBirthdate,
          onCitySelected: formCubit.setDoctorCity,
        ),
        CredentialsPage(
          selectedDepartmentId: formState.selectedDepartmentId,
          onDepartmentSelected: (departmentId) {
            formCubit.setDepartment(departmentId);
            departmentIdController.text = departmentId ?? '';
          },
        ),
        ClinicInfoPage(
          clinicNameController: clinicNameController,
          clinicAddressController: clinicAddressController,
          clinicPhoneController: clinicPhoneController,
          consultationFeeController: consultationFeeController,
          yearsOfExperienceController: yearsOfExperienceController,
          selectedClinicCityId: formState.selectedClinicCityId,
          onClinicCitySelected: formCubit.setClinicCity,
        ),
        SchedulePage(onScheduleChanged: formCubit.setSchedules),
      ],
    );
  }
}
