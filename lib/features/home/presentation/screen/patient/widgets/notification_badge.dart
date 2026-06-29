import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey900.withValues(alpha: .18): AppColors.white.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(50),
      ),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.notifications);
                },
                icon:  Icon(Iconsax.notification_bing5, size: 24,
                color: isDark ? AppColors.white : AppColors.black,),
              ),
              if (state.unreadCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      state.unreadCount > 9 ? '+9' : '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
