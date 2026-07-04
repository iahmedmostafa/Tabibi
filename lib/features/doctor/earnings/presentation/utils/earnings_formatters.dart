import 'package:intl/intl.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:easy_localization/easy_localization.dart';

class EarningsFormatters {
  const EarningsFormatters._();

  static String money(double amount) {
    return NumberFormat.currency(symbol: r'$', decimalDigits: 0).format(amount);
  }

  static String compactMoney(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  static String periodLabel(EarningsPeriod period) {
    switch (period) {
      case EarningsPeriod.week:
        return 'week'.tr();
      case EarningsPeriod.month:
        return 'month'.tr();
      case EarningsPeriod.year:
        return 'year'.tr();
    }
  }
}
