import 'package:tabibi/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';

class CreatePrescriptionRequestModel extends CreatePrescriptionRequest {
  const CreatePrescriptionRequestModel({
    required super.diagnosis,
    super.notes,
    required super.medicines,
  });

  factory CreatePrescriptionRequestModel.fromEntity(
    CreatePrescriptionRequest request,
  ) {
    return CreatePrescriptionRequestModel(
      diagnosis: request.diagnosis,
      notes: request.notes,
      medicines: request.medicines
          .map(PrescriptionMedicineModel.fromEntity)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'diagnosis': diagnosis,
      'medicines': medicines
          .map(
            (medicine) =>
                PrescriptionMedicineModel.fromEntity(medicine).toJson(),
          )
          .toList(),
    };

    if (notes != null && notes!.trim().isNotEmpty) {
      data['notes'] = notes!.trim();
    }

    return data;
  }
}
