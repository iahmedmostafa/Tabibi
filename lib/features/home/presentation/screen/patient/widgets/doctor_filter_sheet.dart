import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart'
    as auth_city;
import 'package:tabibi/features/home/data/models/doctors_filter_params.dart';
import 'package:tabibi/features/home/data/models/department_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorsFilterSheet extends StatefulWidget {
  final DoctorsFilterParams initialFilters;

  const DoctorsFilterSheet({super.key, required this.initialFilters});

  @override
  State<DoctorsFilterSheet> createState() => _DoctorsFilterSheetState();
}

class _DoctorsFilterSheetState extends State<DoctorsFilterSheet> {
  late DoctorsFilterParams _draft;

  static final List<_SortOption> _sortOptions = [
    _SortOption('defaultSort'.tr(), null),
    _SortOption('nameAZ'.tr(), 'Name'),
    _SortOption('nameZA'.tr(), 'Name desc'),
    _SortOption('lowestFee'.tr(), 'ConsultationFee'),
    _SortOption('highestFee'.tr(), 'ConsultationFee desc'),
    _SortOption('mostExperienced'.tr(), 'YearsOfExperience desc'),
  ];

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilters;
  }

  void _reset() {
    setState(() => _draft = const DoctorsFilterParams());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final dialogBg = isDark ? AppColors.grey900 : Colors.white;
    final textColor = isDark ? AppColors.white : AppColors.black;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 34.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.grey700 : AppColors.grey300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'filter'.tr(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _reset,
                      child: Text(
                        'reset'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'showMe'.tr(), isDark: isDark),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'everyone'.tr(),
                        _draft.gender == null,
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(clearGender: true),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'maleGender'.tr(),
                        _draft.gender == 1,
                        isDark,
                        () =>
                            setState(() => _draft = _draft.copyWith(gender: 1)),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'femaleGender'.tr(),
                        _draft.gender == 2,
                        isDark,
                        () =>
                            setState(() => _draft = _draft.copyWith(gender: 2)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'cityLabel'.tr(), isDark: isDark),
                SizedBox(height: 8.h),
                BlocBuilder<auth_city.CitiesCubit, dynamic>(
                  builder: (context, state) {
                    final cities = state.status == CitiesStatus.success
                        ? state.cities
                        : const [];
                    return _FilterDropdown<String?>(
                      value: _draft.cityId,
                      isDark: isDark,
                      hint: state.status == CitiesStatus.loading
                          ? 'loadingCities'.tr()
                          : 'allCities'.tr(),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'allCities'.tr(),
                            style: TextStyle(color: textColor),
                          ),
                        ),
                        ...cities.map(
                          (city) => DropdownMenuItem<String?>(
                            value: city.id,
                            child: Text(
                              city.name,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(
                        () => _draft = _draft.copyWith(
                          cityId: value,
                          clearCity: value == null,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'department'.tr(), isDark: isDark),
                SizedBox(height: 8.h),
                BlocBuilder<DepartmentsCubit, DepartmentsState>(
                  builder: (context, state) {
                    final List<Department> departments =
                        state.departments ?? [];
                    return _FilterDropdown<String?>(
                      value: _draft.departmentId,
                      isDark: isDark,
                      hint: state.departmentsStatus == DepartmentsStatus.loading
                          ? 'loadingDepartments'.tr()
                          : 'allDepartments'.tr(),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'allDepartments'.tr(),
                            style: TextStyle(color: textColor),
                          ),
                        ),
                        ...departments.map(
                          (department) => DropdownMenuItem<String?>(
                            value: department.id,
                            child: Text(
                              department.name,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(
                        () => _draft = _draft.copyWith(
                          departmentId: value,
                          clearDepartment: value == null,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'sortBy'.tr(), isDark: isDark),
                SizedBox(height: 8.h),
                _FilterDropdown<String?>(
                  value: _draft.sort,
                  isDark: isDark,
                  hint: 'defaultSort'.tr(),
                  items: _sortOptions
                      .map(
                        (option) => DropdownMenuItem<String?>(
                          value: option.value,
                          child: Text(
                            option.label,
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(
                    () => _draft = _draft.copyWith(
                      sort: value,
                      clearSort: value == null,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'ratingOrder'.tr(), isDark: isDark),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'none'.tr(),
                        _draft.sortByRating == null,
                        isDark,
                        () => setState(
                          () =>
                              _draft = _draft.copyWith(clearSortByRating: true),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'highest'.tr(),
                        _draft.sortByRating?.toLowerCase() == 'desc',
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(sortByRating: 'desc'),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'lowest'.tr(),
                        _draft.sortByRating?.toLowerCase() == 'asc',
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(sortByRating: 'asc'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionLabel(label: 'reviewCountOrder'.tr(), isDark: isDark),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'none'.tr(),
                        _draft.sortByReviewCount == null,
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(
                            clearSortByReviewCount: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'most'.tr(),
                        _draft.sortByReviewCount?.toLowerCase() == 'desc',
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(
                            sortByReviewCount: 'desc',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'least'.tr(),
                        _draft.sortByReviewCount?.toLowerCase() == 'asc',
                        isDark,
                        () => setState(
                          () => _draft = _draft.copyWith(
                            sortByReviewCount: 'asc',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    _SectionLabel(label: 'pageSize'.tr(), isDark: isDark),
                    const Spacer(),
                    Text(
                      '${_draft.pageSize}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: isDark
                        ? AppColors.grey800
                        : AppColors.grey200,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withOpacity(0.12),
                  ),
                  child: Slider(
                    min: 10,
                    max: 50,
                    divisions: 4,
                    value: _draft.pageSize.toDouble(),
                    onChanged: (value) => setState(
                      () => _draft = _draft.copyWith(pageSize: value.round()),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(_draft),
                      child: Text(
                        'applyFilters'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _choice(String label, bool selected, bool isDark, VoidCallback onTap) {
  final activeBg = AppColors.primary;
  final inactiveBg = isDark ? AppColors.grey800 : AppColors.grey100;
  final activeText = Colors.white;
  final inactiveText = isDark ? AppColors.grey400 : AppColors.grey700;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14.r),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 44.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? activeText : inactiveText,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isDark ? AppColors.grey300 : AppColors.grey800,
        fontSize: 13.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final T value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isDark;

  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownColor = isDark ? AppColors.grey800 : Colors.white;
    final hintColor = isDark ? AppColors.grey400 : AppColors.grey600;

    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint, style: TextStyle(color: hintColor)),
      items: items,
      onChanged: onChanged,
      dropdownColor: dropdownColor,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? AppColors.grey400 : AppColors.grey500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SortOption {
  final String label;
  final String? value;

  const _SortOption(this.label, this.value);
}
