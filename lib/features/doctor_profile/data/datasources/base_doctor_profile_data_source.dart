import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:tabibi/features/doctor_profile/data/models/update_doctor_profile_params.dart';

abstract class BaseDoctorProfileDataSource {
  Future<DoctorProfileModel> getDoctorProfile();
  Future<String> updateDoctorProfile(UpdateDoctorProfileParams params);
  Future<DoctorStatus> doctorStatus();
}
