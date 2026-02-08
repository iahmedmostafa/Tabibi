import 'package:equatable/equatable.dart';

class AvailableSlot extends Equatable {
  final String startTime;
  final bool isAvailable;

  const AvailableSlot({required this.startTime, required this.isAvailable});

  @override
  List<Object?> get props => [startTime, isAvailable];
}
