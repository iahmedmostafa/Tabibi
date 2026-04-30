import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class BookingModel extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String? doctorAvatar;
  final String department;
  final String address;
  final String appointmentDate;
  final int type;
  final int? status;
  final bool? showReviewButton;
  final bool? showPrescriptionButton;

  const BookingModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorAvatar,
    required this.department,
    required this.address,
    required this.appointmentDate,
    required this.type,
    this.status,
    this.showReviewButton,
    this.showPrescriptionButton,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorAvatar: json['doctorAvatar'],
      department: json['department'],
      address: json['address'],
      appointmentDate: json['appointmentDate'],
      type: json['type'],
      status: json['status'] == null
          ? null
          : DoctorAppointmentStatus.fromJson(json['status']),
      showReviewButton: json['showReviewButton'],
      showPrescriptionButton: json['showPrescriptionButton'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    doctorId,
    doctorName,
    doctorAvatar,
    department,
    address,
    appointmentDate,
    type,
    status,
    showReviewButton,
    showPrescriptionButton,
  ];
}
