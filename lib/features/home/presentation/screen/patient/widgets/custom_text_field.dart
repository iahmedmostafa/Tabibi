import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import '../../../../../../core/utils/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool? isEnabled;
 final void Function(String)? onChanged;
  const CustomTextField({
    required this.controller,
    super.key,
    this.isEnabled,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        height: 44.h,
        child: TextField(
          enabled: widget.isEnabled ?? false,
          controller: widget.controller,
          onChanged: widget.onChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search ... ',
            hintStyle: AppTextStyle.h3.copyWith(
              color: AppColors.grey400,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: AppColors.grey100,
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: AppColors.grey400,
              size: 22.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),
          ),
        ),
      ),
    );
  }
}
