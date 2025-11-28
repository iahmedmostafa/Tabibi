import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/data/repositories/cities_repository.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  CitiesCubit(this.citiesRepository) : super(const CitiesState());

  final CitiesRepository citiesRepository;

  Future<void> getCities() async {
    emit(state.copyWith(status: CitiesStatus.loading));

    final result = await citiesRepository.getCities();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CitiesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cities) =>
          emit(state.copyWith(status: CitiesStatus.success, cities: cities)),
    );
  }

  void resetState() {
    emit(const CitiesState());
  }
}
