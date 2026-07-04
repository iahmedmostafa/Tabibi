import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_patient_profile_params.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_form_body.dart';

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
    if (profile != null) _prefillFromProfile(profile);
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
      setState(() => _localImageFile = file);
      context.read<UploadImageCubit>().uploadImage(file);
    }, context);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final avatarUrl =
        context.read<UploadImageCubit>().uploadedImageUrl ?? _networkImageUrl;

    context.read<PatientProfileCubit>().updatePatientProfile(
      UpdatePatientProfileParams(
        name: _nameController.text.trim(),
        dateOfBirth: _selectedBirthdate,
        cityId: _selectedCityId,
        avatarUrl: avatarUrl,
        gender: _selectedGender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state.status == UploadImageStatus.success &&
            state.imageUrl != null) {
          setState(() => _networkImageUrl = state.imageUrl);
        } else if (state.status == UploadImageStatus.failure) {
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'error'.tr(),
            message: state.errorMessage ?? 'imageUploadFailed'.tr(),
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: BlocListener<PatientProfileCubit, PatientProfileState>(
        listenWhen: (prev, curr) => prev.updateStatus != curr.updateStatus,
        listener: (context, state) {
          if (state.updateStatus == PatientProfileUpdateStatus.loading) {
            EasyLoading.show(status: 'saving'.tr());
          } else if (state.updateStatus == PatientProfileUpdateStatus.success) {
            EasyLoading.dismiss();
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'success'.tr(),
              message: AppStrings.profileUpdatedSuccess,
              contentType: ContentType.success,
              context: context,
            );
            context.pop(true);
          } else if (state.updateStatus == PatientProfileUpdateStatus.failure) {
            EasyLoading.dismiss();
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'error'.tr(),
              message: state.errorMessage ?? 'failedToUpdateProfile'.tr(),
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
              icon: const Icon(Iconsax.arrow_left_2),
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
              return EditProfileFormBody(
                formKey: _formKey,
                nameController: _nameController,
                selectedBirthdate: _selectedBirthdate,
                selectedCityId: _selectedCityId,
                selectedGender: _selectedGender,
                networkImageUrl: _networkImageUrl,
                localImageFile: _localImageFile,
                onBirthdateChanged: (date) =>
                    setState(() => _selectedBirthdate = date),
                onCityChanged: (id) => setState(() => _selectedCityId = id),
                onGenderChanged: (gender) =>
                    setState(() => _selectedGender = gender),
                onAvatarTap: _handleImageSelection,
                onSubmit: _submitForm,
              );
            },
          ),
        ),
      ),
    );
  }
}
