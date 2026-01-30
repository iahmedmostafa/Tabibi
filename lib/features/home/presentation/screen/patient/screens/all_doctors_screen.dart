import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_state.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_text_field.dart';
import '../cubit/departments_cubit.dart';
import '../widgets/custom_doctor_cart.dart';
import '../../../../../../core/style/spacing/vertical_space.dart';
import '../../../../data/models/department_model.dart';

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
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: Text(
            "All Doctors",
            style: TextStyle(
              color: AppColors.midnightBlue,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.midnightBlue),
            onPressed: () {
              GoRouter.of(context).go(AppRoutes.bottomNavScreen);
            },
          ),
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
            SizedBox(
              height: 48.h,
              child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
                builder: (context, state) {
                  if (state.departmentsStatus == DepartmentsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final departments = state.departments ?? [];
                  // Create a list of "All" + actual departments
                  final List<Department?> categories = [null, ...departments];

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        HorizentalSpace(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryName = category?.name ?? "All";
                      final categoryId = category?.id; // null for All

                      final isSelected = selectedDepartmentId == categoryId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDepartmentId = categoryId;
                          });
                          context.read<DoctorsCubit>().getDoctors(
                            departmentId: categoryId,
                            query: _searchController.text,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.midnightBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.midnightBlue.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.midnightBlue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            VerticalSpace(height: 16.h),
            // Doctors List
            Expanded(
              child: BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  if (state.status == DoctorsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == DoctorsStatus.failure) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? "Error loading doctors",
                      ),
                    );
                  }

                  final doctors = state.doctors; // using new getter

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${doctors.length} Doctors found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.midnightBlue,
                              ),
                            ),
                            // Keeps the "Default" sort UI but it's not functional yet
                            Row(
                              children: [
                                Text(
                                  "Default",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.unfold_more,
                                  size: 16.sp,
                                  color: AppColors.grey500,
                                ),
                              ],
                            ),
                          ],
                        ),
                        VerticalSpace(height: 16.h),
                        Expanded(
                          child: doctors.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    VerticalSpace(height: 16.h),
                                    Text(
                                      "No doctors found",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  itemCount: state.hasReachedMax
                                      ? doctors.length
                                      : doctors.length + 1,
                                  separatorBuilder: (context, index) =>
                                      VerticalSpace(height: 16.h),
                                  itemBuilder: (context, index) {
                                    if (index >= doctors.length) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    return DoctorCard(doctor: doctors[index]);
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
