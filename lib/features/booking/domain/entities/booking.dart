import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';

class Booking extends Equatable {
  final String id;
  final String date;
  final String time;
  final String doctorName;
  final String doctorImage;
  final String speciality;
  final String location;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.doctorImage,
    required this.speciality,
    required this.location,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    time,
    doctorName,
    doctorImage,
    speciality,
    location,
    status,
  ];
}
