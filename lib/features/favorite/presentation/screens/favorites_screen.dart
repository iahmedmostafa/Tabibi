import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/favorite/presentation/widgets/favorite_doctor_card.dart';
import 'package:tabibi/features/favorite/presentation/widgets/favorites_empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FavoritesCubit>()..getFavorites(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppStrings.favorites,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.midnightBlue),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesError) {
              return Center(child: Text(state.message));
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) return const FavoritesEmptyState();

              return ListView.separated(
                padding: EdgeInsets.all(AppWidth.w20),
                itemCount: state.favorites.length,
                separatorBuilder: (_, __) => SizedBox(height: AppHeight.h16),
                itemBuilder: (context, index) =>
                    FavoriteDoctorCard(doctor: state.favorites[index]),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
