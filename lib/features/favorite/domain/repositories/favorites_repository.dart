import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<DoctorModel>>> getFavorites();
  Future<Either<Failure, void>> removeFavorite(String doctorId);
  Future<Either<Failure, void>> addFavorite(String doctorId);
}
