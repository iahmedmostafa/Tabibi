import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class FavouriteBlocBuilder extends StatelessWidget {
  const FavouriteBlocBuilder({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: sl<FavoritesCubit>(),
      builder: (context, favState) {
        final isFav = favState.favoritedIds.contains(doctor.id);
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFav),
              color: isFav ? AppColors.error : null,
            ),
          ),
          onPressed: () {
            sl<FavoritesCubit>().toggleFavorite(doctor);
          },
        );
      },
    );
  }
}
