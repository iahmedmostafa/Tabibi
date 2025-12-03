import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';

class UploadImageState extends Equatable {
  final UploadImageStatus status;
  final String? imageUrl;
  final String? errorMessage;

  const UploadImageState({
    this.status = UploadImageStatus.initial,
    this.imageUrl,
    this.errorMessage,
  });

  UploadImageState copyWith({
    UploadImageStatus? status,
    String? imageUrl,
    String? errorMessage,
  }) {
    return UploadImageState(
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, imageUrl, errorMessage];
}
