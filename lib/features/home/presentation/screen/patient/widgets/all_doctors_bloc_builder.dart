import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_state.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_doctor_cart.dart';

class AllDoctorsBlocBuilder extends StatelessWidget {
  const AllDoctorsBlocBuilder({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        buildWhen: (previous, current) => previous.doctors != current.doctors,
        builder: (context, state) {
          if (state.status == DoctorsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DoctorsStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? "Error loading doctors"),
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
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRoutes.doctorDetails,
                                  extra: doctors[index],
                                );
                              },
                              child: DoctorCard(doctor: doctors[index]),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
