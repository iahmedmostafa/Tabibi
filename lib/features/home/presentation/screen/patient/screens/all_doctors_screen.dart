import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';

import '../../../../../../core/style/spacing/vertical_space.dart';
import '../cubit/departments_cubit.dart';
import '../widgets/all_doctors_bloc_builder.dart';
import '../widgets/all_doctors_departments_list_view.dart';
import '../widgets/custom_text_field.dart';

class AllDoctorsScreen extends StatefulWidget {
  final String? initialDepartmentId;

  const AllDoctorsScreen({super.key, this.initialDepartmentId});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  static const double _scrollThreshold = 0.9;

  String? selectedDepartmentId;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDepartmentId = widget.initialDepartmentId;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DepartmentsCubit>()..getDepartments(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "All Doctors",
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.midnightBlue,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              GoRouter.of(context).go(AppRoutes.bottomNavScreen);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.map, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.doctorsMapScreen);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            VerticalSpace(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomTextField(
                controller: _searchController,
                isEnabled: true,
                onChanged: (query) {
                  context.read<DoctorsCubit>().getDoctors(
                    departmentId: selectedDepartmentId,
                    query: query,
                  );
                },
              ),
            ),
            const VerticalSpace(height: 16),
            AllDoctorsDepartmentsListView(
              selectedDepartmentId: selectedDepartmentId,
              onDepartmentSelected: (categoryId) {
                setState(() {
                  selectedDepartmentId = categoryId;
                });
              },
              searchQuery: _searchController.text,
            ),
            VerticalSpace(height: 16.h),
            // Doctors List
            AllDoctorsBlocBuilder(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }
}
