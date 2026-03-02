import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_input_decoration.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class EditProfileDateField extends StatelessWidget {
  final String label;
  final String? selectedDate;
  final Function(String) onDateSelected;

  const EditProfileDateField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  void _openDatePicker(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    BottomPicker.date(
      headerBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        );
      },
      onSubmit: (date) {
        onDateSelected(DateFormat('yyyy-MM-dd').format(date));
      },
      bottomPickerTheme: isDark
          ? BottomPickerTheme.morningSalad
          : BottomPickerTheme.blue,
      initialDateTime: _parsedDate ?? DateTime(2000, 1, 1),
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(1900),
      pickerTextStyle: Theme.of(context).textTheme.bodyLarge!,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      buttonSingleColor: AppColors.primary,
    ).show(context);
  }

  DateTime? get _parsedDate {
    if (selectedDate == null) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(selectedDate!);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final hasDate = selectedDate != null && selectedDate!.isNotEmpty;
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey300;
    final iconColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppInputDecoration.labelStyle(context)),
        SizedBox(height: AppHeight.h8),
        GestureDetector(
          onTap: () => _openDatePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.w16,
              vertical: AppHeight.h16,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.grey800 : AppColors.grey100,
              borderRadius: AppBorderRadius.r12,
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Iconsax.calendar, color: iconColor, size: 20),
                SizedBox(width: AppWidth.w12),
                Expanded(
                  child: Text(
                    hasDate ? selectedDate! : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: hasDate
                          ? (isDark ? AppColors.white : AppColors.black)
                          : (isDark ? AppColors.grey500 : AppColors.grey400),
                    ),
                  ),
                ),
                Icon(Iconsax.arrow_down_1, color: iconColor, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
