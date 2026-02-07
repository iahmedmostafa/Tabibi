import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_patient_profile_params.dart';

abstract class BasePatientProfileDataSource {
  Future<PatientProfileModel> getPatientProfile();
  Future<String> updatePatientProfile(UpdatePatientProfileParams params);
}
