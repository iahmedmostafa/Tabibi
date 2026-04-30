import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/presentation/utils/earnings_formatters.dart';

class EarningsTransactionCard extends StatelessWidget {
  final EarningsTransaction transaction;

  const EarningsTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final hasAvatar =
        transaction.patientAvatarUrl != null &&
        transaction.patientAvatarUrl!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              color: AppColors.grey100,
              child: hasAvatar
                  ? CachedNetworkImage(
                      imageUrl: transaction.patientAvatarUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.person),
                    )
                  : Icon(Icons.person, color: AppColors.grey500, size: 24.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${transaction.type} - ${DateFormat('MMM d, yyyy').format(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '+${EarningsFormatters.money(transaction.pricePaid)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
