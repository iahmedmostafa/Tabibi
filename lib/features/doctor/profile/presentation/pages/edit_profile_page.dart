import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/data/models/update_doctor_profile_request.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/edit_profile_state.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/profile_form_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final DoctorProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Personal
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _feeController;
  late final TextEditingController _experienceController;
  late int _selectedGender;

  // Clinic
  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _clinicPhoneController;
  late final TextEditingController _clinicDescController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _bioController = TextEditingController(text: p.bio ?? '');
    _feeController = TextEditingController(text: p.consultationFee);
    _experienceController = TextEditingController(text: p.yearsOfExperience);
    _selectedGender = p.gender;

    _clinicNameController = TextEditingController(text: p.clinic?.name ?? '');
    _clinicAddressController = TextEditingController(text: p.clinic?.address ?? '');
    _clinicPhoneController = TextEditingController(text: p.clinic?.phoneNumber ?? '');
    _clinicDescController = TextEditingController(text: p.clinic?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _feeController.dispose();
    _experienceController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    _clinicDescController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final p = widget.profile;
    final uploadState = context.read<UploadImageCubit>().state;
    final String? avatarToSave = uploadState.status == UploadImageStatus.success 
        ? uploadState.imageUrl 
        : p.avatarUrl;

    final request = UpdateDoctorProfileRequest(
      name: _nameController.text.trim(),
      avatarUrl: avatarToSave,
      gender: _selectedGender,
      dateOfBirth: p.dateOfBirth != null 
          ? "${p.dateOfBirth!.year}-${p.dateOfBirth!.month.toString().padLeft(2, '0')}-${p.dateOfBirth!.day.toString().padLeft(2, '0')}" 
          : null,
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      consultationFee: _feeController.text.trim(),
      credentialImageUrl: p.credentialImageUrl ?? 'https://tabibi.runasp.net/placeholder.png',
      yearsOfExperience: _experienceController.text.trim(),
      departmentId: p.department?.id ?? '',
      clinic: UpdateClinicRequest(
        name: _clinicNameController.text.trim(),
        description: _clinicDescController.text.trim().isEmpty
            ? null
            : _clinicDescController.text.trim(),
        address: _clinicAddressController.text.trim(),
        imageUrl: p.clinic?.imageUrl,
        latitude: 0.0,
        longitude: 0.0,
        phoneNumber: _clinicPhoneController.text.trim(),
        cityId: p.clinic?.city?.id ?? '',
      ),
      schedule: p.schedule
          .map((s) => UpdateScheduleRequest(
                dayOfWeek: s.dayOfWeek,
                openTime: s.openTime,
                closeTime: s.closeTime,
              ))
          .toList(),
    );

    context.read<EditProfileCubit>().updateProfile(request);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully!'),
              backgroundColor: AppTheme.greenIcon,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is EditProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.redIcon,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Edit Profile', style: TextStyle(fontSize: 18.sp)),
          centerTitle: true,
          elevation: 0,
          actions: [
            BlocBuilder<EditProfileCubit, EditProfileState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: TextButton(
                    onPressed: state is EditProfileLoading ? null : _onSave,
                    child: state is EditProfileLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──
                Center(
                  child: BlocBuilder<UploadImageCubit, UploadImageState>(
                    builder: (context, state) {
                      final hasNewImage = state.status == UploadImageStatus.success;
                      final imageUrl = hasNewImage ? state.imageUrl : widget.profile.avatarUrl;
                      
                      return Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surfaceContainerHighest,
                              image: imageUrl != null && imageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageUrl == null || imageUrl.isEmpty
                                ? Icon(Icons.person, size: 50.sp, color: theme.colorScheme.onSurfaceVariant)
                                : null,
                          ),
                          if (state.status == UploadImageStatus.loading)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                selectImage((file) {
                                  context.read<UploadImageCubit>().uploadImage(file);
                                }, context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                                ),
                                child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16.sp),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 32.h),

                // ── Personal Information ──
                _buildSectionHeader(context, 'Personal Information', Icons.person_outline_rounded),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                SizedBox(height: 16.h),
                _buildGenderSelector(context),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Bio',
                  hint: 'Write a short bio about yourself...',
                  controller: _bioController,
                  maxLines: 3,
                  prefixIcon: Icons.edit_note_rounded,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ProfileFormField(
                        label: 'Consultation Fee',
                        hint: '0',
                        controller: _feeController,
                        prefixIcon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ProfileFormField(
                        label: 'Years of Experience',
                        hint: '0',
                        controller: _experienceController,
                        prefixIcon: Icons.work_history_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // ── Clinic Information ──
                _buildSectionHeader(context, 'Clinic Information', Icons.local_hospital_outlined),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Clinic Name',
                  hint: 'Enter clinic name',
                  controller: _clinicNameController,
                  prefixIcon: Icons.business_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Description',
                  hint: 'Clinic description (optional)',
                  controller: _clinicDescController,
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Address',
                  hint: 'Enter clinic address',
                  controller: _clinicAddressController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16.h),
                ProfileFormField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  controller: _clinicPhoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.bluePastel,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppTheme.blueIcon),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _genderChip(context, 'Male', 1)),
            SizedBox(width: 12.w),
            Expanded(child: _genderChip(context, 'Female', 2)),
          ],
        ),
      ],
    );
  }

  Widget _genderChip(BuildContext context, String label, int value) {
    final theme = Theme.of(context);
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
