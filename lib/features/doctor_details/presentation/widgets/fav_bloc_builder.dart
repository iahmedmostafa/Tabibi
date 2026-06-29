import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class FavouriteBlocBuilder extends StatelessWidget {
  const FavouriteBlocBuilder({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: sl<FavoritesCubit>(),
      builder: (context, favState) {
        final isFav = favState.favoritedIds.contains(doctor.id);
        return Container(
          height: 40.h,
          width: 40.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.grey800 : AppColors.borderLight,
            ),
            color: isDark ? AppColors.darkSurface : Colors.white,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFav ? Iconsax.heart5 : Iconsax.heart,
                key: ValueKey(isFav),
                color: isFav
                    ? AppColors.red
                    : (isDark ? Colors.white : AppColors.black),
                size: 20.sp,
              ),
            ),
            onPressed: () {
              sl<FavoritesCubit>().toggleFavorite(doctor);
            },
          ),
        );
      },
    );
  }
}
