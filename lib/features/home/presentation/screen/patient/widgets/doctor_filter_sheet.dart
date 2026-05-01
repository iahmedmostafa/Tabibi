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

class DoctorsFilterSheet extends StatefulWidget {
  final DoctorsFilterParams initialFilters;

  const DoctorsFilterSheet({super.key, required this.initialFilters});

  @override
  State<DoctorsFilterSheet> createState() => _DoctorsFilterSheetState();
}

class _DoctorsFilterSheetState extends State<DoctorsFilterSheet> {
  late DoctorsFilterParams _draft;

  static const List<_SortOption> _sortOptions = [
    _SortOption('Default', null),
    _SortOption('Name A-Z', 'Name'),
    _SortOption('Name Z-A', 'Name desc'),
    _SortOption('Highest rating', 'Rating desc'),
    _SortOption('Lowest rating', 'Rating'),
    _SortOption('Most reviewed', 'ReviewCount desc'),
    _SortOption('Lowest fee', 'ConsultationFee'),
    _SortOption('Highest fee', 'ConsultationFee desc'),
    _SortOption('Most experienced', 'YearsOfExperience desc'),
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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          color: AppColors.midnightBlue,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _reset,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Color(0xFFC2185B)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                const _SectionLabel('Show Me'),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'Everyone',
                        _draft.gender == null,
                        () => setState(
                          () => _draft = _draft.copyWith(clearGender: true),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'Male',
                        _draft.gender == 1,
                        () =>
                            setState(() => _draft = _draft.copyWith(gender: 1)),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _choice(
                        'Female',
                        _draft.gender == 2,
                        () =>
                            setState(() => _draft = _draft.copyWith(gender: 2)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                const _SectionLabel('City'),
                SizedBox(height: 8.h),
                BlocBuilder<auth_city.CitiesCubit, dynamic>(
                  builder: (context, state) {
                    final cities = state.status == CitiesStatus.success
                        ? state.cities
                        : const [];
                    return _FilterDropdown<String?>(
                      value: _draft.cityId,
                      hint: state.status == CitiesStatus.loading
                          ? 'Loading cities...'
                          : 'All cities',
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All cities'),
                        ),
                        ...cities.map(
                          (city) => DropdownMenuItem<String?>(
                            value: city.id,
                            child: Text(city.name),
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
                const _SectionLabel('Department'),
                SizedBox(height: 8.h),
                BlocBuilder<DepartmentsCubit, DepartmentsState>(
                  builder: (context, state) {
                    final List<Department> departments = state.departments ?? [];
                    return _FilterDropdown<String?>(
                      value: _draft.departmentId,
                      hint: state.departmentsStatus == DepartmentsStatus.loading
                          ? 'Loading departments...'
                          : 'All departments',
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All departments'),
                        ),
                        ...departments.map(
                          (department) => DropdownMenuItem<String?>(
                            value: department.id,
                            child: Text(department.name),
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
                const _SectionLabel('Sort By'),
                SizedBox(height: 8.h),
                _FilterDropdown<String?>(
                  value: _draft.sort,
                  hint: 'Default',
                  items: _sortOptions
                      .map(
                        (option) => DropdownMenuItem<String?>(
                          value: option.value,
                          child: Text(option.label),
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
                Row(
                  children: [
                    const _SectionLabel('Page Size'),
                    const Spacer(),
                    Text(
                      '${_draft.pageSize}',
                      style: const TextStyle(
                        color: Color(0xFFC2185B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFE91E63),
                    inactiveTrackColor: AppColors.grey200,
                    thumbColor: const Color(0xFFE91E63),
                    overlayColor: const Color(
                      0xFFE91E63,
                    ).withValues(alpha: 0.12),
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFFFF6D1A)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(_draft),
                      child: Text(
                        'Apply Filters',
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

Widget _choice(String label, bool selected, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10.r),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 42.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFFF6D1A)],
              )
            : null,
        color: selected ? null : AppColors.grey100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.midnightBlue,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.midnightBlue,
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

  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint),
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
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
