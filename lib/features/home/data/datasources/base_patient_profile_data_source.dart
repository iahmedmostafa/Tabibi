import 'package:tabibi/features/home/data/models/patient_profile_model.dart';
import 'package:tabibi/features/home/data/models/update_patient_profile_params.dart';

abstract class BasePatientProfileDataSource {
  Future<PatientProfileModel> getPatientProfile();
  Future<String> updatePatientProfile(UpdatePatientProfileParams params);
}
