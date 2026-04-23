import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_cubit.dart';
import 'package:tabibi/features/doctor/requests/presentation/cubit/requests_state.dart';
import 'package:tabibi/features/doctor/requests/presentation/widgets/request_card.dart';

class AppointmentRequestsPage extends StatelessWidget {
  const AppointmentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RequestsCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Appointment Requests',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<RequestsCubit, RequestsState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Column(
                    children: [
                      const _SearchBar(),
                      SizedBox(height: 16.h),
                      const _FilterChips(),
                    ],
                  ),
                ),
                // Loading bar indicator on top of content
                if (state.isActionLoading)
                  LinearProgressIndicator(
                    color: AppTheme.primaryColor,
                    backgroundColor: AppTheme.primaryColor.withAlpha(40),
                  ),
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RequestsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.allRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context.read<RequestsCubit>().getRequests(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.filteredRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              'No requests found',
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RequestsCubit>().getRequests(),
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
                      content: Text(
                        '✓ Appointment approved for ${request.patientName}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed: $error'),
                      backgroundColor: Colors.red,
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
                      content: Text(
                        '✗ Appointment cancelled for ${request.patientName}',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed: $error'),
                      backgroundColor: Colors.red,
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
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) => context.read<RequestsCubit>().search(query),
      decoration: InputDecoration(
        hintText: 'Search patients...',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14.sp),
        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20.sp),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
      buildWhen: (prev, curr) =>
          prev.selectedFilter != curr.selectedFilter ||
          prev.allRequests.length != curr.allRequests.length,
      builder: (context, state) {
        final todayCount = state.allRequests.where((r) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final rDate = DateTime(r.dateTime.year, r.dateTime.month, r.dateTime.day);
          return rDate.isAtSameMomentAs(today);
        }).length;

        final upcomingCount = state.allRequests.where((r) {
          return r.dateTime.isAfter(DateTime.now());
        }).length;

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
