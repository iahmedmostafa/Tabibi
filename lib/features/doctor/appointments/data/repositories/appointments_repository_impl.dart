import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/features/doctor/appointments/data/datasources/appointments_remote_data_source.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/appointments/domain/repositories/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<AppointmentDetailsEntity> getAppointmentDetails(String id) async {
    try {
      return await remoteDataSource.getAppointmentDetails(id);
    } on ServerException catch (e) {
      throw ServerException(errorMessageModel: e.errorMessageModel);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
