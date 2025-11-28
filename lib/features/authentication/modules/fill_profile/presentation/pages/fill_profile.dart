import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/arrow_back.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/city_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/date_picker_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/image_upload_section.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_state.dart';

class FillProfile extends StatefulWidget {
  const FillProfile({super.key});

  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  DateTime? selectedBirthdate;
  String? selectedCityId;

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
                  final initialName =
                      state.status == PatientProfileStatus.success
                      ? state.profile?.name ?? ''
                      : '';

                  final nameController = TextEditingController(
                    text: initialName,
                  );

                  return CustomInputField(
                    hintText: AppStrings.nameFillProfile,
                    isPassword: false,
                    isPrefixIconNotExist: false,
                    controller: nameController,
                  );
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
                maxDateTime: DateTime.now(),
                minDateTime: DateTime(1900),
              ),
              VerticalSpace(height: AppHeight.h8),
              DropMenu(
                hint: AppStrings.genderFillProfile,
                items: const ['Male', 'Female'],
                onChanged: (value) {},
                value: null,
              ),
              CityDropdown(
                selectedCityId: selectedCityId,
                onCitySelected: (cityId) {
                  setState(() {
                    selectedCityId = cityId;
                  });
                },
              ),
              VerticalSpace(height: AppHeight.h32),
              PrimaryButton(
                onPress: () {
                  final uploadedImageUrl = context
                      .read<UploadImageCubit>()
                      .uploadedImageUrl;

                  print('Uploaded Image URL: $uploadedImageUrl');
                  print('Selected City ID: $selectedCityId');
                  print('Selected Birthdate: $selectedBirthdate');

                  
                },
                title: AppStrings.saveFillProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
