import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/datasources/upload_image_data_source.dart';

class UploadImageRepositary {
  UploadImageDataSource uploadImageDataSource;

  UploadImageRepositary(this.uploadImageDataSource);

  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final String imageUrl = await uploadImageDataSource.uploadImage(image);

      return Right(imageUrl);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
