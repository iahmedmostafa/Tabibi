import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart'
    as auth_city;
import 'package:tabibi/features/home/data/models/doctors_filter_params.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/doctor_filter_sheet.dart';

import '../cubit/departments_cubit.dart';
import '../widgets/all_doctors_bloc_builder.dart';
import '../widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class AllDoctorsScreen extends StatefulWidget {
  final String? initialDepartmentId;

  const AllDoctorsScreen({super.key, this.initialDepartmentId});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  static const double _scrollThreshold = 0.9;

  String? selectedDepartmentId;
  DoctorsFilterParams _filters = const DoctorsFilterParams();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDepartmentId = widget.initialDepartmentId;
    _filters = _filters.copyWith(
      departmentId: widget.initialDepartmentId,
      clearDepartment: widget.initialDepartmentId == null,
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * _scrollThreshold) {
      context.read<DoctorsCubit>().loadMoreDoctors();
    }
  }

  Future<void> _showFilterDialog() async {
    final result = await showModalBottomSheet<DoctorsFilterParams>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<DepartmentsCubit>()),
          BlocProvider.value(value: context.read<auth_city.CitiesCubit>()),
        ],
        child: DoctorsFilterSheet(initialFilters: _filters),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _filters = result.copyWith(
        query: _searchController.text,
        clearQuery: _searchController.text.trim().isEmpty,
      );
      selectedDepartmentId = _filters.departmentId;
    });

    context.read<DoctorsCubit>().getDoctors(filters: _filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'allDoctors'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.map, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              GoRouter.of(context).push(AppRoutes.doctorsMapScreen);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomTextField(
              controller: _searchController,
              isFilterActive: _filters.hasActiveFilters,
              onFilterTap: _showFilterDialog,
              onChanged: (query) {
                _filters = _filters.copyWith(
                  query: query,
                  clearQuery: query.trim().isEmpty,
                );
                context.read<DoctorsCubit>().getDoctors(filters: _filters);
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AllDoctorsBlocBuilder(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }
}
