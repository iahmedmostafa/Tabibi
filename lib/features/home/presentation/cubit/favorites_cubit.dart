import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/domain/usecases/get_favorites_use_case.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoritesCubit(this.getFavoritesUseCase) : super(FavoritesInitial());

  Future<void> getFavorites() async {
    emit(FavoritesLoading());
    final result = await getFavoritesUseCase(const NoParameters());
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (doctors) => emit(FavoritesLoaded(doctors)),
    );
  }

  // Minimal implementation for remove (ideally would have RemoveFavoriteUseCase)
  void removeFavoriteLocally(String doctorId) {
    if (state is FavoritesLoaded) {
      final currentList = (state as FavoritesLoaded).favorites;
      final newList = currentList.where((doc) => doc.id != doctorId).toList();
      emit(FavoritesLoaded(newList));
    }
  }
}
