import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/data/repositories/upload_image_repositary.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';

class ClinicUploadImageCubit extends Cubit<UploadImageState> {
  ClinicUploadImageCubit(this.uploadImageRepository)
    : super(const UploadImageState());

  final UploadImageRepositary uploadImageRepository;

  Future<void> uploadImage(File image) async {
    emit(state.copyWith(status: UploadImageStatus.loading));

    final result = await uploadImageRepository.uploadImage(image);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UploadImageStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (imageUrl) => emit(
        state.copyWith(status: UploadImageStatus.success, imageUrl: imageUrl),
      ),
    );
  }

  void resetState() {
    emit(const UploadImageState());
  }

  // Getter to access the uploaded image URL
  String? get uploadedImageUrl => state.imageUrl;
}
