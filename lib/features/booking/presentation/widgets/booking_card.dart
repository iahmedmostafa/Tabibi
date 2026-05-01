import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/core/widgets/confirmation_dialog.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';
import 'package:tabibi/features/booking/presentation/controller/add_review_cubit.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';
import 'package:tabibi/features/booking/presentation/controller/my_bookings_cubit.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final BookingStatus status;

  const BookingCard({super.key, required this.booking, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatter.formatIsoToDateTime(booking.appointmentDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      AppColors.midnightBlue,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.chat,
                    extra: {
                      'doctorId': booking.doctorId,
                      'doctorName': booking.doctorName,
                      'doctorImage': booking.doctorAvatar,
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.midnightBlue,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.message, size: 14.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        "Chat",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.grey100,
                  image: DecorationImage(
                    image: booking.doctorAvatar != null
                        ? CachedNetworkImageProvider(booking.doctorAvatar!)
                        : const AssetImage(AppImages.onboarding3)
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.doctorName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.midnightBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      booking.department,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 14.sp,
                          color: AppColors.grey500,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            booking.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grey500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 16.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (status == BookingStatus.upcoming) {
      final canCancel = booking.status == 1;
      return Row(
        children: [
          if (canCancel) ...[
            Expanded(
              child: _buildButton(
                context,
                "Cancel",
                AppColors.grey100,
                AppColors.midnightBlue,
                () => _showCancelBookingDialog(context),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: booking.type == 0
                ? _buildButton(
                    context,
                    "Go to Clinic",
                    AppColors.grey100,
                    AppColors.midnightBlue,
                    () {},
                  )
                : _buildButton(
                    context,
                    "Start Call",
                    AppColors.primary,
                    AppColors.white,
                    () {
                      context.pushNamed(
                        AppRoutes.callPage,
                        extra: {'bookingId': booking.id},
                      );
                    },
                  ),
          ),
        ],
      );
    } else if (status == BookingStatus.completed) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  context,
                  "Re-Book",
                  AppColors.grey100,
                  AppColors.midnightBlue,
                  () {
                    context.pushNamed(
                      AppRoutes.doctorDetails,
                      extra: DoctorModel(
                        id: booking.doctorId,
                        name: booking.doctorName,
                        avatarUrl: booking.doctorAvatar,
                        address: booking.address,
                        department: booking.department,
                        consultationFee:
                            200, //don't carry this not affect in doctor details
                        yearsOfExperience:
                            0, 
                          rating: 0,
                          reviewCount: 0

                            //,//don't carry this not affect in doctor details
                      ),
                    );
                  },
                ),
              ),
              if (booking.showPrescriptionButton == true) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildButton(
                    context,
                    AppStrings.prescription,
                    AppColors.midnightBlue,
                    Colors.white,
                    () {
                      context.pushNamed(
                        AppRoutes.prescription,
                        pathParameters: {'bookingId': booking.id},
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          if (booking.showReviewButton != false) ...[
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: _buildButton(
                context,
                "Add Review",
                AppColors.midnightBlue,
                Colors.white,
                () => _showAddReviewDialog(context),
              ),
            ),
          ],
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              context,
              "Re-Book",
              AppColors.grey100,
              AppColors.midnightBlue,
              () {
                context.pushNamed(
                  AppRoutes.doctorDetails,
                  extra: DoctorModel(
                    id: booking.doctorId,
                    name: booking.doctorName,
                    avatarUrl: booking.doctorAvatar,
                    address: booking.address,
                    department: booking.department,
                    consultationFee: 200,
                    yearsOfExperience: 0,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  void _showCancelBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => sl<AppointmentCubit>(),
          child: _CancelBookingDialog(
            bookingId: booking.id,
            doctorName: booking.doctorName,
            onCancelled: () {
              context.read<MyBookingsCubit>().getBookings(
                status: BookingStatus.upcoming,
              );
            },
          ),
        );
      },
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => sl<AddReviewCubit>(),
          child: _AddReviewDialog(
            booking: booking,
            onSubmitted: () {
              context.read<MyBookingsCubit>().getBookings(
                status: BookingStatus.completed,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddReviewDialog extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback onSubmitted;

  const _AddReviewDialog({required this.booking, required this.onSubmitted});

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddReviewCubit, AddReviewState>(
      listener: (context, state) {
        if (state.status == AddReviewStatus.success) {
          final messenger = ScaffoldMessenger.of(context);
          Navigator.of(context).pop();
          widget.onSubmitted();
          messenger.showSnackBar(
            const SnackBar(content: Text('Review added successfully')),
          );
        } else if (state.status == AddReviewStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add review'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AddReviewStatus.loading;
        return AlertDialog(
          title: Text('Review ${widget.booking.doctorName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFB74D),
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _commentController,
                minLines: 3,
                maxLines: 5,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'Write your review',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context.read<AddReviewCubit>().submit(
                      bookingId: widget.booking.id,
                      rating: _rating,
                      comment: _commentController.text,
                    ),
              child: isLoading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class _CancelBookingDialog extends StatelessWidget {
  final String bookingId;
  final String doctorName;
  final VoidCallback onCancelled;

  const _CancelBookingDialog({
    required this.bookingId,
    required this.doctorName,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentCancelSuccess) {
          final messenger = ScaffoldMessenger.of(context);
          Navigator.of(context).pop();
          onCancelled();
          messenger.showSnackBar(
            const SnackBar(content: Text('Booking cancelled successfully')),
          );
        } else if (state is AppointmentFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AppointmentBookingLoading;
        return ConfirmationDialog(
          title: 'Cancel booking',
          message: 'Cancel your appointment with Dr $doctorName?',
          cancelText: 'Keep',
          confirmText: 'Cancel Booking',
          icon: Icons.event_busy_outlined,
          closeOnConfirm: false,
          isLoading: isLoading,
          onConfirm: () => context.read<AppointmentCubit>().cancelBooking(
            bookingId: bookingId,
          ),
        );
      },
    );
  }
}
