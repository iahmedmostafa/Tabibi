import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/core/utils/helper/backend_date_time.dart';
import 'package:tabibi/features/booking/presentation/controller/upcoming_booking_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/empty_upcoming_card.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_feedback_panel.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/upcoming_appointment_card.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/upcoming_appointment_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';

class UpcomingAppointmentSection extends StatelessWidget {
  const UpcomingAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingBookingCubit, UpcomingBookingState>(
      builder: (context, state) {
        if (state.status == UpcomingBookingStatus.loading) {
          return const UpcomingAppointmentSkeleton();
        }

        if (state.status == UpcomingBookingStatus.failure) {
          return ErrorPanel(
            message: state.errorMessage ?? 'failedToLoadDoctors'.tr(),
          );
        }

        final summary = state.summary;
        final booking = summary?.nextBooking;
        if (summary == null || booking == null) {
          return EmptyUpcomingCard(
            onTap: () => context.pushNamed(
              AppRoutes.myBookings,
              extra: BookingStatus.upcoming,
            ),
          );
        }

        final appointmentDate = BackendDateTime.parseUtc(
          booking.appointmentDate,
        );
        final formattedDate = Formatter.formatTimeForDoctor(appointmentDate);
        final formattedTime = Formatter.formatDateForDoctor(appointmentDate);

        return UpcomingAppointmentCard(
          booking: booking,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          countText: '${summary.totalUpcomingCount} ${'upcoming'.tr()}',
          onTap: () => context.pushNamed(
            AppRoutes.myBookings,
            extra: BookingStatus.upcoming,
          ),
        );
      },
    );
  }
}
