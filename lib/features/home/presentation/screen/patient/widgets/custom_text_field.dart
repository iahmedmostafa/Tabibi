import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import '../../../../../../core/utils/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool? isEnabled;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final bool isFilterActive;
  const CustomTextField({
    required this.controller,
    super.key,
    this.isEnabled,
    this.onChanged,
    this.onFilterTap,
    this.isFilterActive = false,
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
        height: 48.h,
        child: TextField(
          enabled: widget.isEnabled ?? true,
          controller: widget.controller,
          onChanged: widget.onChanged,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Search by name, profession...',
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
            suffixIcon: widget.onFilterTap == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: InkWell(
                      onTap: widget.onFilterTap,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFFFF6D1A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withValues(
                                alpha: widget.isFilterActive ? 0.28 : 0.18,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.grey100),
            ),
          ),
        ),
      ),
    );
  }
}
