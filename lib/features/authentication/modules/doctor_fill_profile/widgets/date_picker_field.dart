import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class DatePickerField extends StatelessWidget {
  final String? selectedDate;
  final String hintText;
  final String pickerTitle;
  final Function(String) onDateSelected;
  final DateTime? initialDateTime;
  final DateTime? maxDateTime;
  final DateTime? minDateTime;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.hintText,
    required this.pickerTitle,
    required this.onDateSelected,
    this.initialDateTime,
    this.maxDateTime,
    this.minDateTime,
  });

  void _openDatePicker(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    BottomPicker.date(
      headerBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            pickerTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      },
      onSubmit: (date) {
        onDateSelected(DateFormat('yyyy-MM-dd').format(date));
      },
      bottomPickerTheme: isDark
          ? BottomPickerTheme.morningSalad
          : BottomPickerTheme.blue,
      initialDateTime:  initialDateTime ?? DateTime(2000, 1, 1),
      maxDateTime: maxDateTime ?? DateTime.now(),
      minDateTime: minDateTime ?? DateTime(1900),
      pickerTextStyle: Theme.of(context).textTheme.bodyLarge!,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      buttonSingleColor: AppColors.primary,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => _openDatePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.w16,
          vertical: AppHeight.h12,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.grey100,
          borderRadius: AppBorderRadius.r8,
          border: Border.all(
            color: isDark ? AppColors.grey700 : AppColors.grey300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.calendar,
              color: isDark ? AppColors.grey400 : AppColors.grey,
            ),
            HorizentalSpace(width: AppWidth.w12),
            Text(
              selectedDate != null
                  ? selectedDate!
                  : hintText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedDate != null
                    ? (isDark ? AppColors.white : AppColors.black)
                    : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
