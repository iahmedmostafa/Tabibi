import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_cubit.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_state.dart';
import 'package:tabibi/features/doctor/requests/presentation/widgets/request_card.dart';

class AppointmentRequestsPage extends StatelessWidget {
  const AppointmentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestsCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Appointment Requests',
            style: TextStyle(fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                children: [
                  const _SearchBar(),
                  SizedBox(height: 16.h),
                  const _FilterChips(),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  if (state.filteredRequests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64.sp,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No requests found',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = state.filteredRequests[index];
                      return RequestCard(
                        request: request,
                        onApprove: () {
                          context.read<RequestsCubit>().approveRequest(
                            request.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Request approved for ${request.patientName}',
                              ),
                            ),
                          );
                        },
                        onReject: () {
                          context.read<RequestsCubit>().rejectRequest(
                            request.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Request rejected for ${request.patientName}',
                              ),
                            ),
                          );
                        },
                      );
                    },
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) => context.read<RequestsCubit>().search(query),
      decoration: InputDecoration(
        hintText: 'Search patients...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20.sp),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        return Row(
          children: [
            _buildChip(
              context,
              label: 'All (${state.allRequests.length})',
              isSelected: state.selectedFilter == RequestFilter.all,
              onTap: () =>
                  context.read<RequestsCubit>().setFilter(RequestFilter.all),
            ),
            SizedBox(width: 8.w),
            _buildChip(
              context,
              label: 'Today',
              isSelected: state.selectedFilter == RequestFilter.today,
              onTap: () =>
                  context.read<RequestsCubit>().setFilter(RequestFilter.today),
            ),
            SizedBox(width: 8.w),
            _buildChip(
              context,
              label: 'Upcoming',
              isSelected: state.selectedFilter == RequestFilter.upcoming,
              onTap: () => context.read<RequestsCubit>().setFilter(
                RequestFilter.upcoming,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
