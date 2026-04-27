import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/booking/presentation/controller/my_bookings_cubit.dart';
import 'package:tabibi/features/booking/presentation/widgets/booking_card.dart';
import 'package:tabibi/features/booking/presentation/widgets/booking_tab_filter.dart';

class MyBookingsScreen extends StatefulWidget {
  final BookingStatus initialStatus;

  const MyBookingsScreen({
    super.key,
    this.initialStatus = BookingStatus.upcoming,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  // ignore: unused_field
  late MyBookingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MyBookingsCubit>()..getBookings(status: widget.initialStatus);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppStrings.myBookings,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          buildWhen: (previous, current) {
            return previous.selectedTab != current.selectedTab ||
                previous.status != current.status ||
                previous.allBookings != current.allBookings;
          },
          builder: (context, state) {
            if (state.status == MyBookingsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                SizedBox(height: 16.h),
                BookingTabFilter(
                  selectedTab: state.selectedTab,
                  onTabSelected: (status) {
                    _cubit.getBookings(status: status);
                  },
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: state.allBookings.isEmpty
                      ? Center(
                          child: Text(
                            AppStrings.noBookingsFound,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.grey500,
                                  fontSize: 16.sp,
                                ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          itemCount: state.allBookings.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            return BookingCard(
                              booking: state.allBookings[index],
                              status: state.selectedTab,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
