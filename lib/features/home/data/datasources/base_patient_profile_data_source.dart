import 'package:tabibi/features/home/data/models/patient_profile_model.dart';

abstract class BasePatientProfileDataSource {
  Future<PatientProfileModel> getPatientProfile();
}
