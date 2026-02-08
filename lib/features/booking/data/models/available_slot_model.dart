import 'package:tabibi/features/booking/domain/entities/available_slot.dart';

class AvailableSlotModel extends AvailableSlot {
  const AvailableSlotModel({
    required super.startTime,
    required super.isAvailable,
  });

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      startTime: json['startTime'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'isAvailable': isAvailable};
  }
}
