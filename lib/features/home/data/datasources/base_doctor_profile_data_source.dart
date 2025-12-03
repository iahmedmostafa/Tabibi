import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/data/models/doctor_profile_model.dart';

abstract class BaseDoctorProfileDataSource {
  Future<DoctorProfileModel> getDoctorProfile();
  Future<String> updateDoctorProfile(UpdateDoctorProfileParams params);
}
