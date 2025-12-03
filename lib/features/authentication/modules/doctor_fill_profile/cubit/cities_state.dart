import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/data/models/city_model.dart';

class CitiesState extends Equatable {
  final CitiesStatus status;
  final List<CityModel> cities;
  final String? errorMessage;

  const CitiesState({
    this.status = CitiesStatus.initial,
    this.cities = const [],
    this.errorMessage,
  });

  CitiesState copyWith({
    CitiesStatus? status,
    List<CityModel>? cities,
    String? errorMessage,
  }) {
    return CitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cities, errorMessage];
}
