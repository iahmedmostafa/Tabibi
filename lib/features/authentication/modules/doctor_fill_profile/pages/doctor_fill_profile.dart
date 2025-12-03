import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/widgets/success_dialog.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/department_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/city_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/date_picker_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/image_upload_section.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/credential_image_upload_section.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/schedule_page.dart';
import 'package:tabibi/features/home/data/models/work_schedule_dto.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/name_input_field.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_state.dart';

class DoctorFillProfile extends StatefulWidget {
  const DoctorFillProfile({super.key});

  @override
  State<DoctorFillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<DoctorFillProfile> {
  String? selectedBirthdate;
  String? selectedDoctorCityId;
  String? selectedDepartmentId;
  String? selectedClinicCityId;

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _consultationFeeController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _departmentIdController;
  late TextEditingController _clinicNameController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _clinicPhoneController;
  late TextEditingController _clinicCityIdController;

  List<WorkScheduleDto> schedules = [];

  int gender = 0;
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DoctorProfileCubit>();
    cubit.getDoctorProfile();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _consultationFeeController = TextEditingController();
    _yearsOfExperienceController = TextEditingController();
    _departmentIdController = TextEditingController();
    _clinicNameController = TextEditingController();
    _clinicAddressController = TextEditingController();
    _clinicPhoneController = TextEditingController();
    _clinicCityIdController = TextEditingController();
    _pageController = PageController();

    if (cubit.state.status == DoctorProfileStatus.success) {
      _nameController.text = cubit.state.profile?.name ?? '';
      _bioController.text = cubit.state.profile?.bio ?? '';
      _consultationFeeController.text =
          cubit.state.profile?.consultationFee.toString() ?? '';
      _yearsOfExperienceController.text =
          cubit.state.profile?.yearsOfExperience.toString() ?? '';
      _departmentIdController.text = cubit.state.profile?.departmentId ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _consultationFeeController.dispose();
    _yearsOfExperienceController.dispose();
    _departmentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentPage + 1) / 4;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpace(height: AppHeight.h12),
                Text(
                  '${currentPage + 1} from ${4}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                VerticalSpace(height: AppHeight.h12),

                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.green,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (currentPage == 0) {
                          context.goNamed(AppRoutes.signUp);
                          return;
                        }
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      currentPage == 0
                          ? "Fill Your Profile"
                          : currentPage == 1
                          ? "Upload Credentials"
                          : currentPage == 2
                          ? "complete your clinic profile"
                          : "Set Work Schedule",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: 570,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    children: [
                      BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              VerticalSpace(height: AppHeight.h28),
                              const ImageUploadSection(),
                              VerticalSpace(height: AppHeight.h28),
                              NameInputField(controller: _nameController),
                              VerticalSpace(height: AppHeight.h28),
                              // Bio Field
                              NameInputField(
                                controller: _bioController,
                                hintText: 'Bio',
                                maxLines: 3,
                              ),
                              VerticalSpace(height: AppHeight.h28),
                              DropMenu(
                                hint: AppStrings.genderFillProfile,
                                items: const ['Male', 'Female'],
                                onChanged: (value) {
                                  setState(() {
                                    gender = value == 'Male' ? 1 : 2;
                                  });
                                },
                                value: gender == 1 ? 'Male' : 'Female',
                              ),
                              VerticalSpace(height: AppHeight.h28),
                              DatePickerField(
                                selectedDate: selectedBirthdate,
                                hintText: AppStrings.dateFillProfile,
                                pickerTitle: 'Select your birthdate',
                                onDateSelected: (date) {
                                  setState(() {
                                    selectedBirthdate = date;
                                  });
                                },
                                initialDateTime: DateTime(2000, 1, 1),
                              ),
                              VerticalSpace(height: AppHeight.h28),
                              CityDropdown(
                                selectedCityId: selectedDoctorCityId,
                                onCitySelected: (cityId) {
                                  setState(() {
                                    selectedDoctorCityId = cityId;
                                  });
                                },
                              ),
                              VerticalSpace(height: AppHeight.h28),
                            ],
                          );
                        },
                      ),
                      BlocBuilder<DepartmentsCubit, DepartmentsState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              const CredentialImageUploadSection(),
                              VerticalSpace(height: AppHeight.h20),
                              // Department ID Field
                              DepartmentDropdown(
                                selectedDepartmentId: selectedDepartmentId,
                                onDepartmentSelected: (departmentId) {
                                  setState(() {
                                    selectedDepartmentId = departmentId;
                                    _departmentIdController.text =
                                        departmentId ?? '';
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              VerticalSpace(height: AppHeight.h85),
                              // Clinic Name Field
                              NameInputField(
                                controller: _clinicNameController,
                                hintText: 'Clinic Name',
                              ),
                              VerticalSpace(height: AppHeight.h20),

                              // Clinic Address Field
                              NameInputField(
                                controller: _clinicAddressController,
                                hintText: 'Clinic Address',
                              ),
                              VerticalSpace(height: AppHeight.h20),

                              // Clinic Phone Field
                              NameInputField(
                                controller: _clinicPhoneController,
                                hintText: 'Clinic Phone',
                              ),
                              VerticalSpace(height: AppHeight.h20),

                              // Clinic city id Field
                              CityDropdown(
                                selectedCityId: selectedClinicCityId,
                                onCitySelected: (cityId) {
                                  setState(() {
                                    selectedClinicCityId = cityId;
                                  });
                                },
                              ),
                              VerticalSpace(height: AppHeight.h20),
                              NameInputField(
                                controller: _consultationFeeController,
                                hintText: 'Consultation Fee',
                              ),
                              VerticalSpace(height: AppHeight.h20),
                              // Years of Experience Field
                              NameInputField(
                                controller: _yearsOfExperienceController,
                                hintText: 'Years of Experience',
                              ),
                            ],
                          );
                        },
                      ),
                      SchedulePage(
                        onScheduleChanged: (newSchedules) {
                          setState(() {
                            schedules = newSchedules;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                VerticalSpace(height: AppHeight.h20),

                BlocListener<DoctorProfileCubit, DoctorProfileState>(
                  listener: (context, state) {
                    log(
                      'BlocListener: Status=${state.status}, Name=${state.profile?.name}, Error=${state.errorMessage}',
                    );
                    if (state.status == DoctorProfileStatus.success &&
                        _nameController.text.isEmpty) {
                      _nameController.text = state.profile?.name ?? '';
                      _bioController.text = state.profile?.bio ?? '';
                      _consultationFeeController.text =
                          state.profile?.consultationFee.toString() ?? '';
                      _yearsOfExperienceController.text =
                          state.profile?.yearsOfExperience.toString() ?? '';
                      log('BlocListener: Set text to ${_nameController.text}');
                    }
                    if (state.updateStatus ==
                        DoctorProfileUpdateStatus.loading) {
                      EasyLoading.show(status: 'Loading...');
                    } else if (state.updateStatus ==
                        DoctorProfileUpdateStatus.success) {
                      EasyLoading.dismiss();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const SuccessDialog(),
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        if (context.mounted) {
                          context.goNamed(AppRoutes.pending);
                        }
                      });
                    } else if (state.updateStatus ==
                        DoctorProfileUpdateStatus.failure) {
                      EasyLoading.dismiss();
                      AppHelperFunctions.showAwesomeSnackBar(
                        title: 'Error',
                        message:
                            state.errorMessage ?? 'Failed to update profile',
                        contentType: ContentType.failure,
                        context: context,
                      );
                    }
                  },
                  child: PrimaryButton(
                    onPress: () {
                      if (currentPage < 3) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        return;
                      }
                      final uploadedImageUrl = context
                          .read<UploadImageCubit>()
                          .uploadedImageUrl;
                      final credentialImageUrl = context
                          .read<CredentialUploadImageCubit>()
                          .uploadedImageUrl;
                      log(_nameController.text);
                      final params = UpdateDoctorProfileParams(
                        name: _nameController.text,
                        bio: _bioController.text,
                        consultationFee: double.tryParse(
                          _consultationFeeController.text,
                        ),
                        yearsOfExperience: int.tryParse(
                          _yearsOfExperienceController.text,
                        ),
                        departmentId: _departmentIdController.text,
                        dateOfBirth: selectedBirthdate,
                        avatarUrl: uploadedImageUrl,
                        credentialImageUrl: credentialImageUrl,
                        gender: gender,
                        clinicName: _clinicNameController.text,
                        clinicAddress: _clinicAddressController.text,
                        clinicPhoneNumber: _clinicPhoneController.text,
                        clinicCity: selectedClinicCityId,
                        schedule: schedules,
                      );
                      context.read<DoctorProfileCubit>().updateDoctorProfile(
                        params,
                      );
                    },
                    title: currentPage == 3
                        ? AppStrings.saveFillProfile
                        : "Next",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
