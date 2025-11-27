import 'package:flutter/material.dart';
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
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/date_picker_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/image_upload_section.dart';

class FillProfile extends StatefulWidget {
  const FillProfile({super.key});

  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  DateTime? selectedBirthdate;

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
              const CustomInputField(
                hintText: AppStrings.nameFillProfile,
                isPassword: false,
                isPrefixIconNotExist: false,
              ),
              VerticalSpace(height: AppHeight.h20),
              const CustomInputField(
                hintText: AppStrings.emailFillProfile,
                isPassword: false,
                isPrefixIconNotExist: false,
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
              VerticalSpace(height: AppHeight.h32),
              PrimaryButton(onPress: () {}, title: AppStrings.saveFillProfile),
            ],
          ),
        ),
      ),
    );
  }
}
