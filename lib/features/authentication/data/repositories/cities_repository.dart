import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/datasources/cities_data_source.dart';
import 'package:tabibi/features/authentication/data/models/city_model.dart';

class CitiesRepository {
  final CitiesDataSource citiesDataSource;

  CitiesRepository(this.citiesDataSource);

  Future<Either<Failure, List<CityModel>>> getCities() async {
    try {
      final List<CityModel> cities = await citiesDataSource.getCities();

      return Right(cities);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
