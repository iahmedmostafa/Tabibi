import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_state.dart';
import 'package:easy_localization/easy_localization.dart';

class EditDoctorProfilePage extends StatefulWidget {
  final DoctorProfile profile;

  const EditDoctorProfilePage({super.key, required this.profile});

  @override
  State<EditDoctorProfilePage> createState() => _EditDoctorProfilePageState();
}

class _EditDoctorProfilePageState extends State<EditDoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _consultationFeeController;
  late final TextEditingController _yearsOfExperienceController;
  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _clinicPhoneController;
  late final UploadImageCubit _uploadImageCubit;
  late final CredentialUploadImageCubit _credentialUploadImageCubit;
  File? _localImageFile;
  String? _networkImageUrl;
  String? _credentialNetworkImageUrl;
  bool _isUploading = false;
  bool _isCredentialUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadImageCubit = sl<UploadImageCubit>();
    _credentialUploadImageCubit = sl<CredentialUploadImageCubit>();
    final profile = widget.profile;
    _networkImageUrl = profile.avatarUrl;
    _credentialNetworkImageUrl = profile.credentialImageUrl.isNotEmpty
        ? profile.credentialImageUrl
        : null;
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio ?? '');
    _consultationFeeController = TextEditingController(
      text: profile.consultationFee.toStringAsFixed(0),
    );
    _yearsOfExperienceController = TextEditingController(
      text: profile.yearsOfExperience.toString(),
    );
    _clinicNameController = TextEditingController(text: profile.clinic.name);
    _clinicAddressController = TextEditingController(
      text: profile.clinic.address,
    );
    _clinicPhoneController = TextEditingController(
      text: profile.clinic.phoneNumber,
    );
  }

  @override
  void dispose() {
    _uploadImageCubit.close();
    _credentialUploadImageCubit.close();
    _nameController.dispose();
    _bioController.dispose();
    _consultationFeeController.dispose();
    _yearsOfExperienceController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadImageCubit>.value(value: _uploadImageCubit),
        BlocProvider<CredentialUploadImageCubit>.value(
          value: _credentialUploadImageCubit,
        ),
      ],
      child: BlocListener<UploadImageCubit, UploadImageState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          setState(
            () => _isUploading = state.status == UploadImageStatus.loading,
          );

          if (state.status == UploadImageStatus.success &&
              state.imageUrl != null) {
            setState(() => _networkImageUrl = state.imageUrl);
          } else if (state.status == UploadImageStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'imageUploadFailed'.tr()),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocListener<CredentialUploadImageCubit, UploadImageState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            setState(() {
              _isCredentialUploading =
                  state.status == UploadImageStatus.loading;
            });

            if (state.status == UploadImageStatus.success &&
                state.imageUrl != null) {
              setState(() => _credentialNetworkImageUrl = state.imageUrl);
            } else if (state.status == UploadImageStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'credentialImageUploadFailed'.tr(),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
            listenWhen: (previous, current) =>
                previous.updateStatus != current.updateStatus,
            listener: (context, state) {
              if (state.updateStatus == DoctorProfileUpdateStatus.success) {
                context.read<DoctorProfileCubit>().getDoctorProfile();
                Navigator.of(context).pop(true);
              }

              if (state.updateStatus == DoctorProfileUpdateStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'failedToUpdateProfile'.tr(),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isSaving =
                  state.updateStatus == DoctorProfileUpdateStatus.loading;

              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  title: Text('editDoctorProfile'.tr()),
                  centerTitle: true,
                  actions: [
                    TextButton(
                      onPressed:
                          (isSaving || _isUploading || _isCredentialUploading)
                          ? null
                          : _submit,
                      child: isSaving
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text('save'.tr()),
                    ),
                  ],
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50.w,
                              backgroundColor: isDark
                                  ? AppColors.grey800
                                  : AppColors.teal200,
                              backgroundImage: _localImageFile != null
                                  ? FileImage(_localImageFile!)
                                  : (_networkImageUrl != null &&
                                            _networkImageUrl!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                            _networkImageUrl!,
                                          )
                                        : null),
                              child:
                                  (_localImageFile == null &&
                                      (_networkImageUrl == null ||
                                          _networkImageUrl!.isEmpty))
                                  ? Text(
                                      widget.profile.initials,
                                      style: TextStyle(
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.midnightBlue,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _handleImageSelection,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.midnightBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _SectionCard(
                        title: 'credentialImage'.tr(),
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: _handleCredentialImageSelection,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 250.w,
                                    height: 168.h,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.grey800
                                          : AppColors.grey200,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.r),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.r),
                                      ),
                                      child: _buildCredentialImage(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.darkTeal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: _isCredentialUploading
                                          ? Padding(
                                              padding: EdgeInsets.all(10.w),
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                            )
                                          : const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SectionCard(
                        title: 'accountInformation'.tr(),
                        children: [
                          _TextField(
                            controller: _nameController,
                            label: 'name'.tr(),
                            validator: _requiredValidator,
                          ),
                          SizedBox(height: 12.h),
                          _TextField(
                            controller: _bioController,
                            label: 'bio'.tr(),
                            maxLines: 3,
                          ),
                          SizedBox(height: 12.h),
                          _TextField(
                            controller: _consultationFeeController,
                            label: 'consultationFee'.tr(),
                            keyboardType: TextInputType.number,
                            validator: _positiveNumberValidator,
                          ),
                          SizedBox(height: 12.h),
                          _TextField(
                            controller: _yearsOfExperienceController,
                            label: 'yearsOfExperience'.tr(),
                            keyboardType: TextInputType.number,
                            validator: _nonNegativeIntValidator,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SectionCard(
                        title: 'clinicInformation'.tr(),
                        children: [
                          _TextField(
                            controller: _clinicNameController,
                            label: 'clinicName'.tr(),
                            validator: _requiredValidator,
                          ),
                          SizedBox(height: 12.h),
                          _TextField(
                            controller: _clinicAddressController,
                            label: 'clinicAddress'.tr(),
                            validator: _requiredValidator,
                          ),
                          SizedBox(height: 12.h),
                          _TextField(
                            controller: _clinicPhoneController,
                            label: 'clinicPhone'.tr(),
                            keyboardType: TextInputType.phone,
                            validator: _requiredValidator,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final profile = widget.profile;
    final uploadedUrl = _uploadImageCubit.uploadedImageUrl;
    final avatarUrl = uploadedUrl ?? _networkImageUrl;
    final credentialUploadedUrl = _credentialUploadImageCubit.uploadedImageUrl;
    final credentialImageUrl =
        credentialUploadedUrl ?? _credentialNetworkImageUrl;

    final params = UpdateDoctorProfileParams.fromProfile(
      profile,
      name: _nameController.text.trim(),
      bio: _emptyToNull(_bioController.text),
      consultationFee: double.parse(_consultationFeeController.text.trim()),
      yearsOfExperience: int.parse(_yearsOfExperienceController.text.trim()),
      clinicName: _clinicNameController.text.trim(),
      clinicAddress: _clinicAddressController.text.trim(),
      clinicPhoneNumber: _clinicPhoneController.text.trim(),
      avatarUrl: avatarUrl,
      credentialImageUrl: credentialImageUrl,
    );

    context.read<DoctorProfileCubit>().updateDoctorProfile(params);
  }

  void _handleImageSelection() {
    selectImage((file) {
      setState(() => _localImageFile = file);
      _uploadImageCubit.uploadImage(file);
    }, context);
  }

  void _handleCredentialImageSelection() {
    selectImage((file) {
      _credentialUploadImageCubit.uploadImage(file);
    }, context);
  }

  Widget _buildCredentialImage() {
    if (_credentialNetworkImageUrl != null &&
        _credentialNetworkImageUrl!.isNotEmpty) {
      return Image.network(_credentialNetworkImageUrl!, fit: BoxFit.fill);
    }
    return const Icon(
      Icons.credit_card_rounded,
      size: 80,
      color: AppColors.grey400,
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'fieldRequired'.tr();
    return null;
  }

  String? _positiveNumberValidator(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) return 'validPositiveNumber'.tr();
    return null;
  }

  String? _nonNegativeIntValidator(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) return 'validNumber'.tr();
    return null;
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}
