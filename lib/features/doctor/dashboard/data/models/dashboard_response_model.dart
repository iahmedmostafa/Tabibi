import 'package:tabibi/core/utils/backend_date_time.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';

class DashboardResponseModel extends DashboardResponse {
  const DashboardResponseModel({
    required super.doctorName,
    super.doctorAvatarUrl,
    required super.stats,
    required super.todayAppointments,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      doctorName: json['doctorName'] ?? '',
      doctorAvatarUrl: json['doctorAvatarUrl'],
      stats: DashboardStatsModel.fromJson(json['stats'] ?? {}),
      todayAppointments:
          (json['todayAppointments'] as List<dynamic>?)
              ?.map((e) => DashboardAppointmentModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.todayCount,
    required super.completedCount,
    required super.cancelledCount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      todayCount: json['todayCount'] ?? 0,
      completedCount: json['completedCount'] ?? 0,
      cancelledCount: json['cancelledCount'] ?? 0,
    );
  }
}

class DashboardAppointmentModel extends DashboardAppointment {
  const DashboardAppointmentModel({
    required super.id,
    required super.patientName,
    super.patientAvatarUrl,
    required super.appointmentDate,
    required super.type,
    required super.status,
  });

  factory DashboardAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DashboardAppointmentModel(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAvatarUrl: json['patientAvatarUrl'],
      appointmentDate: json['appointmentDate'] != null
          ? BackendDateTime.tryParseUtc(json['appointmentDate'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      type: json['type'],
      status: json['status'],
    );
  }
}
