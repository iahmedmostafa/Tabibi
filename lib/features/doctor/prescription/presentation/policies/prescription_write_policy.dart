import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

enum PrescriptionWriteRestriction {
  none,
  appointmentInFuture,
  appointmentCompleted,
  appointmentCancelled,
  prescriptionExists,
}

class PrescriptionWritePolicy extends Equatable {
  final bool canWrite;
  final PrescriptionWriteRestriction restriction;
  final String? disabledMessage;

  const PrescriptionWritePolicy._({
    required this.canWrite,
    required this.restriction,
    this.disabledMessage,
  });

  const PrescriptionWritePolicy.allowed()
    : this._(canWrite: true, restriction: PrescriptionWriteRestriction.none);

  const PrescriptionWritePolicy.disabled({
    required PrescriptionWriteRestriction restriction,
    required String message,
  }) : this._(
         canWrite: false,
         restriction: restriction,
         disabledMessage: message,
       );

  factory PrescriptionWritePolicy.evaluate({
    required DateTime appointmentDate,
    required int appointmentStatus,
    required bool hasPrescription,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    if (appointmentStatus == 3) {
      return PrescriptionWritePolicy.disabled(
        restriction: PrescriptionWriteRestriction.appointmentCompleted,
        message: 'appointmentAlreadyCompleted'.tr(),
      );
    }
    if (appointmentStatus == 4) {
      return PrescriptionWritePolicy.disabled(
        restriction: PrescriptionWriteRestriction.appointmentCancelled,
        message: 'prescriptionCancelledAppointment'.tr(),
      );
    }
    if (hasPrescription) {
      return PrescriptionWritePolicy.disabled(
        restriction: PrescriptionWriteRestriction.prescriptionExists,
        message: 'prescriptionAlreadyExists'.tr(),
      );
    }
    if (appointmentDate.isAfter(currentTime)) {
      return PrescriptionWritePolicy.disabled(
        restriction: PrescriptionWriteRestriction.appointmentInFuture,
        message: 'prescriptionAfterVisit'.tr(),
      );
    }

    return const PrescriptionWritePolicy.allowed();
  }

  @override
  List<Object?> get props => [canWrite, restriction, disabledMessage];
}
