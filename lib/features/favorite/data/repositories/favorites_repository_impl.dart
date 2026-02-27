import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:tabibi/features/favorite/domain/repositories/favorites_repository.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorModel>>> getFavorites() async {
    try {
      final result = await remoteDataSource.getFavorites();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String doctorId) async {
    try {
      await remoteDataSource.removeFavorite(doctorId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(String doctorId) async {
    try {
      await remoteDataSource.addFavorite(doctorId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
