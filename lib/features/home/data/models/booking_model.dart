import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.date,
    required super.time,
    required super.doctorName,
    required super.doctorImage,
    required super.speciality,
    required super.location,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorImage: json['doctorImage'] ?? '',
      speciality: json['speciality'] ?? '',
      location: json['location'] ?? '',
      status: _mapStringToStatus(json['status']),
    );
  }

  static BookingStatus _mapStringToStatus(String? status) {
    switch (status) {
      case 'upcoming':
        return BookingStatus.upcoming;
      case 'completed':
        return BookingStatus.completed;
      case 'canceled':
        return BookingStatus.canceled;
      default:
        return BookingStatus.upcoming;
    }
  }
}
