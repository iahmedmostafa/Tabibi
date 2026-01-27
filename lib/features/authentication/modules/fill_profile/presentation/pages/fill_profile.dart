import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/arrow_back.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/widgets/success_dialog.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/city_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/date_picker_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/image_upload_section.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/name_input_field.dart';
import 'package:tabibi/features/home/data/models/update_patient_profile_params.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_state.dart';

class FillProfile extends StatefulWidget {
  const FillProfile({super.key});

  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  String? selectedBirthdate;
  String? selectedCityId;
  late TextEditingController _nameController;
  int gender = 0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PatientProfileCubit>();
    cubit.getPatientProfile();
    _nameController = TextEditingController();
    if (cubit.state.status == PatientProfileStatus.success) {
      _nameController.text = cubit.state.profile?.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Column(
            children: [
              VerticalSpace(height: AppHeight.h32),
              Row(
                children: [
                  const ArrowBack(nameRoute: AppRoutes.signUp),
                  HorizentalSpace(width: AppWidth.w14),
                  Text(
                    "Fill Your Profile",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              VerticalSpace(height: AppHeight.h32),
              const ImageUploadSection(),
              VerticalSpace(height: AppHeight.h24),
              BlocBuilder<PatientProfileCubit, PatientProfileState>(
                builder: (context, state) {
                  return NameInputField(controller: _nameController);
                },
              ),

              VerticalSpace(height: AppHeight.h20),
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
              VerticalSpace(height: AppHeight.h20),
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
              VerticalSpace(height: AppHeight.h20),

              CityDropdown(
                selectedCityId: selectedCityId,
                onCitySelected: (cityId) {
                  setState(() {
                    selectedCityId = cityId;
                  });
                },
              ),
              VerticalSpace(height: AppHeight.h32),
              BlocListener<PatientProfileCubit, PatientProfileState>(
                listener: (context, state) {
                  log(
                    'BlocListener: Status=${state.status}, Name=${state.profile?.name}, Error=${state.errorMessage}',
                  );
                  if (state.status == PatientProfileStatus.success &&
                      _nameController.text.isEmpty) {
                    _nameController.text = state.profile?.name ?? '';
                    log('BlocListener: Set text to ${_nameController.text}');
                  }
                  if (state.updateStatus ==
                      PatientProfileUpdateStatus.loading) {
                    EasyLoading.show(status: 'Loading...');
                  } else if (state.updateStatus ==
                      PatientProfileUpdateStatus.success) {
                    EasyLoading.dismiss();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const SuccessDialog(),
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      if (context.mounted) {
                        context.goNamed(AppRoutes.patientHome);
                      }
                    });
                  } else if (state.updateStatus ==
                      PatientProfileUpdateStatus.failure) {
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
                  onPress: () {
                    final uploadedImageUrl = context
                        .read<UploadImageCubit>()
                        .uploadedImageUrl;
                    log(_nameController.text);
                    final params = UpdatePatientProfileParams(
                      name: _nameController.text,
                      dateOfBirth: selectedBirthdate,
                      cityId: selectedCityId,
                      avatarUrl: uploadedImageUrl,
                      gender: gender,
                    );
                    context.read<PatientProfileCubit>().updatePatientProfile(
                      params,
                    );
                  },
                  title: AppStrings.saveFillProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
