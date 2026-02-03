import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/home/presentation/cubit/favorites_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_doctor_cart.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/remove_favorite_dialog.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoritesCubit>()..getFavorites(),
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
            icon: Icon(Icons.arrow_back, color: AppColors.midnightBlue),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FavoritesError) {
                    return Center(child: Text(state.message));
                  } else if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return const Center(child: Text("No favorites yet."));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.all(AppWidth.w20),
                      itemCount: state.favorites.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppHeight.h16),
                      itemBuilder: (context, index) {
                        final doctor = state.favorites[index];
                        return DoctorCard(
                          doctor: doctor,
                          isFavorite: true,
                          onFavoriteTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => RemoveFavoriteDialog(
                                doctorName: doctor.name,
                                onConfirm: () {
                                  context
                                      .read<FavoritesCubit>()
                                      .removeFavoriteLocally(doctor.id);
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
