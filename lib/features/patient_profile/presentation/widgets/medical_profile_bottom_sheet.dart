import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/medical_profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/medical_profile_state.dart';

class MedicalProfileBottomSheet extends StatefulWidget {
  /// Called when the user completes or skips the medical profile.
  final VoidCallback? onDone;

  const MedicalProfileBottomSheet({super.key, this.onDone});

  /// Shows the medical profile bottom sheet.
  /// First fetches the medical profile to check [isCompleted].
  /// If already completed, calls [onComplete] immediately.
  static Future<void> showIfNeeded(
    BuildContext context, {
    VoidCallback? onComplete,
  }) async {
    final cubit = sl<MedicalProfileCubit>();
    await cubit.getMedicalProfile();
    final profile = cubit.state.profile;

    if (profile != null && profile.isCompleted) {
      onComplete?.call();
      return;
    }

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: MedicalProfileBottomSheet(onDone: onComplete),
      ),
    );
  }

  /// Always shows the bottom sheet with existing data pre-filled for editing.
  static Future<void> showForEdit(BuildContext context) async {
    final cubit = sl<MedicalProfileCubit>();
    await cubit.getMedicalProfile();

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const MedicalProfileBottomSheet(),
      ),
    );
  }

  @override
  State<MedicalProfileBottomSheet> createState() =>
      _MedicalProfileBottomSheetState();
}

class _MedicalProfileBottomSheetState extends State<MedicalProfileBottomSheet> {
  final _medicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _surgeriesController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  final Set<String> _selectedDiseases = {};

  // Validation error messages
  String? _diseasesError;
  String? _medicationsError;
  String? _allergiesError;
  String? _surgeriesError;
  String? _weightError;
  String? _heightError;

  final List<String> _diseaseOptions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing profile data if available
    final profile = context.read<MedicalProfileCubit>().state.profile;
    if (profile != null) {
      _selectedDiseases.addAll(profile.chronicDiseases);
      _medicationsController.text = profile.medications ?? '';
      _allergiesController.text = profile.allergies ?? '';
      _surgeriesController.text = profile.surgeries.join(', ');
      _weightController.text = profile.weight ?? '';
      _heightController.text = profile.height ?? '';
    }
  }

  @override
  void dispose() {
    _medicationsController.dispose();
    _allergiesController.dispose();
    _surgeriesController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _toggleDisease(String disease) {
    setState(() {
      _diseasesError = null;
      if (disease == 'None') {
        _selectedDiseases.clear();
        _selectedDiseases.add('None');
      } else {
        _selectedDiseases.remove('None');
        if (_selectedDiseases.contains(disease)) {
          _selectedDiseases.remove(disease);
        } else {
          _selectedDiseases.add(disease);
        }
      }
    });
  }

  bool _validate() {
    bool isValid = true;

    setState(() {
      // Chronic diseases
      if (_selectedDiseases.isEmpty) {
        _diseasesError = 'Please select at least one option';
        isValid = false;
      } else {
        _diseasesError = null;
      }

      // Medications
      if (_medicationsController.text.trim().isEmpty) {
        _medicationsError = 'Please enter your medications or write "None"';
        isValid = false;
      } else {
        _medicationsError = null;
      }

      // Allergies
      if (_allergiesController.text.trim().isEmpty) {
        _allergiesError = 'Please enter your allergies or write "None"';
        isValid = false;
      } else {
        _allergiesError = null;
      }

      // Surgeries
      if (_surgeriesController.text.trim().isEmpty) {
        _surgeriesError = 'Please enter your surgeries or write "None"';
        isValid = false;
      } else {
        _surgeriesError = null;
      }

      // Weight
      if (_weightController.text.trim().isEmpty) {
        _weightError = 'Required';
        isValid = false;
      } else if (double.tryParse(_weightController.text.trim()) == null) {
        _weightError = 'Invalid number';
        isValid = false;
      } else {
        _weightError = null;
      }

      // Height
      if (_heightController.text.trim().isEmpty) {
        _heightError = 'Required';
        isValid = false;
      } else if (double.tryParse(_heightController.text.trim()) == null) {
        _heightError = 'Invalid number';
        isValid = false;
      } else {
        _heightError = null;
      }
    });

    return isValid;
  }

  void _submit() {
    if (!_validate()) return;

    final surgeries = _surgeriesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final diseases = _selectedDiseases.where((d) => d != 'None').toList();

    final params = UpdateMedicalProfileParams(
      chronicDiseases: diseases,
      medications: _medicationsController.text.trim(),
      allergies: _allergiesController.text.trim(),
      surgeries: surgeries,
      weight: _weightController.text.trim(),
      height: _heightController.text.trim(),
    );

    context.read<MedicalProfileCubit>().updateMedicalProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<MedicalProfileCubit, MedicalProfileState>(
      listener: (context, state) {
        if (state.updateStatus == MedicalProfileUpdateStatus.success) {
          Navigator.of(context).pop();
          widget.onDone?.call();
        } else if (state.updateStatus == MedicalProfileUpdateStatus.failure) {
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'Error',
            message: state.errorMessage ?? 'Something went wrong',
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w, top: 8.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onDone?.call();
                      },
                      child: Icon(
                        Icons.close,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: AppColors.paleBlueLight,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Iconsax.clipboard_text,
                                color: AppColors.blue,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complete your medical profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Help doctors understand your condition better',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textGrey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Chronic Diseases
                        _buildSectionLabel(context, 'Chronic Diseases'),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _diseaseOptions.map((disease) {
                            final isSelected =
                                _selectedDiseases.contains(disease);
                            return GestureDetector(
                              onTap: () => _toggleDisease(disease),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.blue.withValues(alpha: 0.1)
                                      : isDark
                                          ? AppColors.grey800
                                          : AppColors.grey50,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.blue
                                        : _diseasesError != null
                                            ? AppColors.red
                                            : isDark
                                                ? AppColors.grey700
                                                : AppColors.grey200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      Icon(
                                        Icons.check_circle,
                                        size: 16.sp,
                                        color: AppColors.blue,
                                      ),
                                      SizedBox(width: 6.w),
                                    ],
                                    Text(
                                      disease,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppColors.blue
                                                : isDark
                                                    ? AppColors.grey300
                                                    : AppColors.grey700,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_diseasesError != null) ...[
                          SizedBox(height: 6.h),
                          Text(
                            _diseasesError!,
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                        SizedBox(height: 20.h),

                        // Current Medications
                        _buildSectionLabel(context, 'Current Medications'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _medicationsController,
                          hint: 'Enter medications (e.g. Panadol, Metformin...)',
                          icon: Iconsax.edit,
                          isDark: isDark,
                          errorText: _medicationsError,
                          onChanged: (_) {
                            if (_medicationsError != null) {
                              setState(() => _medicationsError = null);
                            }
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Allergies
                        _buildSectionLabel(context, 'Allergies'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _allergiesController,
                          hint: 'Any allergies? (e.g. Penicillin, Pollen...)',
                          icon: Iconsax.shield_cross,
                          isDark: isDark,
                          errorText: _allergiesError,
                          onChanged: (_) {
                            if (_allergiesError != null) {
                              setState(() => _allergiesError = null);
                            }
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Previous Surgeries
                        _buildSectionLabel(context, 'Previous Surgeries'),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: _surgeriesController,
                          hint: 'Any previous surgeries?',
                          icon: Iconsax.scissor,
                          isDark: isDark,
                          errorText: _surgeriesError,
                          onChanged: (_) {
                            if (_surgeriesError != null) {
                              setState(() => _surgeriesError = null);
                            }
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Weight & Height
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel(context, 'Weight (kg)'),
                                  SizedBox(height: 8.h),
                                  _buildTextField(
                                    controller: _weightController,
                                    hint: 'e.g. 70',
                                    icon: Iconsax.weight,
                                    isDark: isDark,
                                    keyboardType: TextInputType.number,
                                    errorText: _weightError,
                                    onChanged: (_) {
                                      if (_weightError != null) {
                                        setState(() => _weightError = null);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel(context, 'Height (cm)'),
                                  SizedBox(height: 8.h),
                                  _buildTextField(
                                    controller: _heightController,
                                    hint: 'e.g. 175',
                                    icon: Iconsax.ruler,
                                    isDark: isDark,
                                    keyboardType: TextInputType.number,
                                    errorText: _heightError,
                                    onChanged: (_) {
                                      if (_heightError != null) {
                                        setState(() => _heightError = null);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // Buttons
                        BlocBuilder<MedicalProfileCubit, MedicalProfileState>(
                          builder: (context, state) {
                            final isLoading = state.updateStatus ==
                                MedicalProfileUpdateStatus.loading;
                            return Row(
                              children: [
                                // Skip button
                                Expanded(
                                  child: SizedBox(
                                    height: 50.h,
                                    child: OutlinedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              Navigator.of(context).pop();
                                              widget.onDone?.call();
                                            },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: isDark
                                              ? AppColors.grey600
                                              : AppColors.grey300,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        'Skip',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Continue button
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 50.h,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              width: 24.w,
                                              height: 24.h,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Continue',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14.sp),
            prefixIcon: Icon(icon, size: 20.sp, color: AppColors.grey400),
            filled: true,
            fillColor: isDark ? AppColors.grey800 : AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null
                    ? AppColors.red
                    : isDark
                        ? AppColors.grey700
                        : AppColors.grey200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.red : AppColors.blue,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText,
            style: TextStyle(color: AppColors.red, fontSize: 12.sp),
          ),
        ],
      ],
    );
  }
}
