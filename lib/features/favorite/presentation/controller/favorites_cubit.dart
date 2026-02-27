import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/favorite/domain/usecases/add_favorite_use_case.dart';
import 'package:tabibi/features/favorite/domain/usecases/get_favorites_use_case.dart';
import 'package:tabibi/features/favorite/domain/usecases/remove_favorite_use_case.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  FavoritesCubit(
    this.getFavoritesUseCase,
    this.addFavoriteUseCase,
    this.removeFavoriteUseCase,
  ) : super(FavoritesInitial());

  // ⚠️ IMPORTANT: This must be reassigned (not mutated) every change
  // so that old Equatable state references don't see the changes.
  Set<String> _favoritedIds = {};

  bool isFavorited(String doctorId) => _favoritedIds.contains(doctorId);

  Future<void> getFavorites() async {
    _emitLoading();
    final result = await getFavoritesUseCase(const NoParameters());
    result.fold((failure) => emit(FavoritesError(failure.message, _copy())), (
      doctors,
    ) {
      // Assign a brand-new Set from server data
      _favoritedIds = {for (final doc in doctors) doc.id};
      emit(FavoritesLoaded(doctors, _copy()));
    });
  }

  Future<void> toggleFavorite(DoctorModel doctor) async {
    final alreadyFav = _favoritedIds.contains(doctor.id);

    // ─── Optimistic update: new Set reference ───────────────────────
    if (alreadyFav) {
      _favoritedIds = _favoritedIds.where((id) => id != doctor.id).toSet();
    } else {
      _favoritedIds = {..._favoritedIds, doctor.id};
    }
    _emitUpdatedIds();

    // ─── API call ────────────────────────────────────────────────────
    if (alreadyFav) {
      final result = await removeFavoriteUseCase(doctor.id);
      result.fold(
        (failure) {
          // Revert – again create a new Set
          _favoritedIds = {..._favoritedIds, doctor.id};
          _emitUpdatedIds();
        },
        (_) {
          // If we have the full-list state, remove the doctor from it too
          if (state is FavoritesLoaded) {
            final updated = (state as FavoritesLoaded).favorites
                .where((d) => d.id != doctor.id)
                .toList();
            emit(FavoritesLoaded(updated, _copy()));
          }
        },
      );
    } else {
      final result = await addFavoriteUseCase(doctor.id);
      result.fold(
        (failure) {
          // Revert
          _favoritedIds = _favoritedIds.where((id) => id != doctor.id).toSet();
          _emitUpdatedIds();
        },
        (_) {
          // If we have the full-list state, add the doctor to it too
          if (state is FavoritesLoaded) {
            final updated = [...(state as FavoritesLoaded).favorites, doctor];
            emit(FavoritesLoaded(updated, _copy()));
          }
        },
      );
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Always returns a fresh copy so Equatable detects the change.
  Set<String> _copy() => Set.unmodifiable(_favoritedIds);

  void _emitLoading() => emit(FavoritesLoading(_copy()));

  void _emitUpdatedIds() {
    if (state is FavoritesLoaded) {
      emit(FavoritesLoaded((state as FavoritesLoaded).favorites, _copy()));
    } else {
      emit(FavoritesIdsChanged(_copy()));
    }
  }
}
