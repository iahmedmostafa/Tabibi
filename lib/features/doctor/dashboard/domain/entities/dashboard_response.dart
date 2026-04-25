import 'package:equatable/equatable.dart';

class DashboardResponse extends Equatable {
  final String doctorName;
  final String? doctorAvatarUrl;
  final DashboardStats stats;
  final List<DashboardAppointment> todayAppointments;

  const DashboardResponse({
    required this.doctorName,
    this.doctorAvatarUrl,
    required this.stats,
    required this.todayAppointments,
  });

  @override
  List<Object?> get props => [
    doctorName,
    doctorAvatarUrl,
    stats,
    todayAppointments,
  ];
}

class DashboardStats extends Equatable {
  final int todayCount;
  final int completedCount;
  final int cancelledCount;

  const DashboardStats({
    required this.todayCount,
    required this.completedCount,
    required this.cancelledCount,
  });

  @override
  List<Object?> get props => [todayCount, completedCount, cancelledCount];
}

class DashboardAppointment extends Equatable {
  final String id;
  final String patientName;
  final String? patientAvatarUrl;
  final DateTime appointmentDate;
  final dynamic type;
  final dynamic status;

  const DashboardAppointment({
    required this.id,
    required this.patientName,
    this.patientAvatarUrl,
    required this.appointmentDate,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    patientName,
    patientAvatarUrl,
    appointmentDate,
    type,
    status,
  ];
}
