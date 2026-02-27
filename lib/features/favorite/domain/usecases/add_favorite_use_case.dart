import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/favorite/domain/repositories/favorites_repository.dart';

class AddFavoriteUseCase implements BaseUseCase<void, String> {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String doctorId) async {
    return await repository.addFavorite(doctorId);
  }
}
