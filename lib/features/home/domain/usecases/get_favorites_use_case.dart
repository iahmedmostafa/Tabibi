import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase extends BaseUseCase<List<DoctorModel>, NoParameters> {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorModel>>> call(
    NoParameters parameters,
  ) async {
    return await repository.getFavorites();
  }
}
