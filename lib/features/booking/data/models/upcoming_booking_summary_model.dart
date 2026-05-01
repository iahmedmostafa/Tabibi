import 'package:tabibi/features/booking/data/models/booking_model.dart';

class UpcomingBookingSummaryModel {
  final int totalUpcomingCount;
  final BookingModel? nextBooking;

  const UpcomingBookingSummaryModel({
    required this.totalUpcomingCount,
    this.nextBooking,
  });

  factory UpcomingBookingSummaryModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return UpcomingBookingSummaryModel(
      totalUpcomingCount: parseInt(json['totalUpcomingCount']),
      nextBooking: json['nextBooking'] is Map<String, dynamic>
          ? BookingModel.fromJson(json['nextBooking'] as Map<String, dynamic>)
          : null,
    );
  }
}
