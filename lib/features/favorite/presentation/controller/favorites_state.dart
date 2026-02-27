part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  final Set<String> favoritedIds;
  const FavoritesState(this.favoritedIds);

  @override
  List<Object> get props => [favoritedIds.toList()..sort()];
}

class FavoritesInitial extends FavoritesState {
  FavoritesInitial() : super({});
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading(super.favoritedIds);
}

class FavoritesLoaded extends FavoritesState {
  final List<DoctorModel> favorites;

  const FavoritesLoaded(this.favorites, super.favoritedIds);

  @override
  List<Object> get props => [favorites, favoritedIds.toList()..sort()];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message, super.favoritedIds);

  @override
  List<Object> get props => [message, favoritedIds.toList()..sort()];
}

/// Emitted when only the set of favorited IDs changes (e.g., toggle from another screen)
class FavoritesIdsChanged extends FavoritesState {
  const FavoritesIdsChanged(super.favoritedIds);
}
