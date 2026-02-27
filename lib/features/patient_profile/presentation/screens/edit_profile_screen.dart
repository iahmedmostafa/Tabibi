import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_state.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_patient_profile_params.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_avatar.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_date_field.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_dropdown.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  String? _selectedBirthdate;
  String? _selectedCityId;
  int? _selectedGender;
  File? _localImageFile;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _prefillFromState();
  }

  void _prefillFromState() {
    final profile = context.read<PatientProfileCubit>().state.profile;
    if (profile != null) {
      _prefillFromProfile(profile);
    }
  }

  void _prefillFromProfile(PatientProfileModel profile) {
    _nameController.text = profile.name;
    _selectedBirthdate = profile.dateOfBirth;
    _selectedGender = profile.gender;
    _networkImageUrl = profile.avatarUrl;
    _selectedCityId = profile.city?.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleImageSelection() {
    selectImage((file) {
      setState(() {
        _localImageFile = file;
      });
      context.read<UploadImageCubit>().uploadImage(file);
    }, context);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final uploadCubit = context.read<UploadImageCubit>();
    final avatarUrl = uploadCubit.uploadedImageUrl ?? _networkImageUrl;

    final params = UpdatePatientProfileParams(
      name: _nameController.text.trim(),
      dateOfBirth: _selectedBirthdate,
      cityId: _selectedCityId,
      avatarUrl: avatarUrl,
      gender: _selectedGender,
    );

    context.read<PatientProfileCubit>().updatePatientProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state.status == UploadImageStatus.success &&
            state.imageUrl != null) {
          setState(() {
            _networkImageUrl = state.imageUrl;
          });
        } else if (state.status == UploadImageStatus.failure) {
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'Error',
            message: state.errorMessage ?? 'Image upload failed',
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: BlocListener<PatientProfileCubit, PatientProfileState>(
        listenWhen: (prev, curr) => prev.updateStatus != curr.updateStatus,
        listener: (context, state) {
          if (state.updateStatus == PatientProfileUpdateStatus.loading) {
            EasyLoading.show(status: 'Saving...');
          } else if (state.updateStatus == PatientProfileUpdateStatus.success) {
            EasyLoading.dismiss();
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'Success',
              message: AppStrings.profileUpdatedSuccess,
              contentType: ContentType.success,
              context: context,
            );
            // Pop and pass true so ProfileScreen knows to refresh
            context.pop(true);
          } else if (state.updateStatus == PatientProfileUpdateStatus.failure) {
            EasyLoading.dismiss();
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'Error',
              message: state.errorMessage ?? 'Failed to update profile',
              contentType: ContentType.failure,
              context: context,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              AppStrings.editProfile,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => context.pop(),
            ),
          ),
          body: BlocBuilder<PatientProfileCubit, PatientProfileState>(
            buildWhen: (prev, curr) =>
                prev.status != curr.status && curr.profile != null,
            builder: (context, profileState) {
              if (profileState.profile != null &&
                  _nameController.text.isEmpty) {
                _prefillFromProfile(profileState.profile!);
              }
              return _buildBody(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
        child: Column(
          children: [
            SizedBox(height: AppHeight.h24),

            // Avatar
            BlocBuilder<UploadImageCubit, UploadImageState>(
              builder: (context, uploadState) {
                return EditProfileAvatar(
                  networkImageUrl: _networkImageUrl,
                  localImageFile: _localImageFile,
                  isUploading: uploadState.status == UploadImageStatus.loading,
                  onTap: _handleImageSelection,
                );
              },
            ),

            SizedBox(height: AppHeight.h32),

            // Name Field
            EditProfileTextField(
              controller: _nameController,
              label: AppStrings.fullName,
              hint: AppStrings.enterFullName,
              prefixIcon: Iconsax.user,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.nameRequired;
                }
                return null;
              },
            ),

            SizedBox(height: AppHeight.h20),

            // Gender Dropdown
            EditProfileDropdown<int>(
              label: AppStrings.selectGender,
              hint: AppStrings.selectGender,
              value: _selectedGender,
              prefixIcon: Iconsax.user_edit,
              items: const [
                DropdownMenuItem(value: 1, child: Text(AppStrings.male)),
                DropdownMenuItem(value: 2, child: Text(AppStrings.female)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),

            SizedBox(height: AppHeight.h20),

            // Date of Birth
            EditProfileDateField(
              label: AppStrings.dateOfBirth,
              selectedDate: _selectedBirthdate,
              onDateSelected: (date) {
                setState(() {
                  _selectedBirthdate = date;
                });
              },
            ),

            SizedBox(height: AppHeight.h20),

            // City Dropdown
            _buildCityDropdown(),

            SizedBox(height: AppHeight.h40),

            // Save Button
            PrimaryButton(title: AppStrings.saveChanges, onPress: _submitForm),

            SizedBox(height: AppHeight.h40),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, citiesState) {
        if (citiesState.status == CitiesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (citiesState.status == CitiesStatus.failure) {
          return Text(
            citiesState.errorMessage ?? 'Failed to load cities',
            style: const TextStyle(color: Colors.red),
          );
        }

        if (citiesState.cities.isEmpty) {
          return const SizedBox.shrink();
        }

        return EditProfileDropdown<String>(
          label: AppStrings.city,
          hint: AppStrings.city,
          value: _selectedCityId,
          prefixIcon: Iconsax.location,
          items: citiesState.cities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city.id,
                  child: Text(city.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCityId = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.cityRequired;
            }
            return null;
          },
        );
      },
    );
  }
}
