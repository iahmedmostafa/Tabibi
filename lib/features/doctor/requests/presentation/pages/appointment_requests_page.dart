import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_empty_state.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_cubit.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_state.dart';
import 'package:tabibi/features/doctor/requests/presentation/widgets/request_card.dart';

class AppointmentRequestsPage extends StatelessWidget {
  const AppointmentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<RequestsCubit>(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Appointment Requests', style: theme.textTheme.titleLarge),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<RequestsCubit, RequestsState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Column(
                    children: [
                      _SearchBar(),
                      SizedBox(height: 16.h),
                      _FilterChips(),
                    ],
                  ),
                ),
                if (state.isActionLoading)
                  LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withAlpha(40),
                  ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RequestsState state) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return const DoctorLoadingState();
    }

    if (state.errorMessage != null && state.allRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: isDark ? AppColors.grey500 : Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.grey500,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => context.read<RequestsCubit>().getRequests(),
                child: Text('Retry', style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ),
      );
    }

    if (state.filteredRequests.isEmpty) {
      return DoctorEmptyState(
        icon: Icons.search_off,
        message: 'No requests found',
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RequestsCubit>().getRequests(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: state.filteredRequests.length,
        itemBuilder: (context, index) {
          final request = state.filteredRequests[index];
          return RequestCard(
            request: request,
            onApprove: () {
              context.read<RequestsCubit>().approveRequest(
                request.id,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appointment approved for ${request.patientName}'),
                      backgroundColor: AppColors.actionGreen,
                    ),
                  );
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed: $error'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
              );
            },
            onReject: () {
              context.read<RequestsCubit>().rejectRequest(
                request.id,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appointment cancelled for ${request.patientName}'),
                      backgroundColor: AppColors.actionAmber,
                    ),
                  );
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed: $error'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey200,
        ),
      ),
      child: TextField(
        onChanged: (query) => context.read<RequestsCubit>().search(query),
        decoration: InputDecoration(
          hintText: 'Search patients...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.grey400 : AppColors.grey500,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      buildWhen: (prev, curr) =>
          prev.selectedFilter != curr.selectedFilter ||
          prev.allRequests.length != curr.allRequests.length,
      builder: (context, state) {
        final todayCount = state.allRequests.where((r) {
          if (!r.isUpcoming) return false;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final localDate = r.dateTime.toLocal();
          final rDate = DateTime(localDate.year, localDate.month, localDate.day);
          return rDate.isAtSameMomentAs(today);
        }).length;

        final upcomingCount = state.allRequests.where((r) => r.isUpcoming).length;

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
              label: 'Today ($todayCount)',
              isSelected: state.selectedFilter == RequestFilter.today,
              onTap: () =>
                  context.read<RequestsCubit>().setFilter(RequestFilter.today),
            ),
            SizedBox(width: 8.w),
            _buildChip(
              context,
              label: 'Upcoming ($upcomingCount)',
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
