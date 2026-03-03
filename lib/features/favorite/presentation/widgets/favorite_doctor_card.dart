import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/favorite/presentation/widgets/remove_favorite_dialog.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_doctor_cart.dart';

class FavoriteDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const FavoriteDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.doctorDetails, extra: doctor),
      child: DoctorCard(
        doctor: doctor,
        isFavorite: true,
        onFavoriteTap: () {
          showDialog(
            context: context,
            builder: (ctx) => RemoveFavoriteDialog(
              doctorName: doctor.name,
              onConfirm: () =>
                  context.read<FavoritesCubit>().toggleFavorite(doctor),
            ),
          );
        },
      ),
    );
  }
}
