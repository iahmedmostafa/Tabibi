import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/services/cache_helper.dart';
import 'package:tabibi/core/services/notification_manager.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/booking/presentation/controller/my_bookings_cubit.dart';
import 'package:tabibi/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:tabibi/features/chat_patient/presentation/pages/conversations_screen.dart';
import 'package:tabibi/features/doctors_map/presentation/screens/doctors_map_screen.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/patient_home_screen.dart';
import 'package:tabibi/features/notifications/data/datasources/fcm_token_data_source.dart';
import 'package:tabibi/features/patient_profile/presentation/screens/profile_screen.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/medical_profile_bottom_sheet.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  String? accessToken;

  static const _tabs = [
    _NavItem(
      activeIcon: Iconsax.home_15,
      inactiveIcon: Iconsax.home4,
      label: 'Home',
    ),
    _NavItem(
      activeIcon: Iconsax.location5,
      inactiveIcon: Iconsax.location4,
      label: 'Explore',
    ),
    _NavItem(
      activeIcon: Iconsax.calendar5,
      inactiveIcon: Iconsax.calendar_1,
      label: 'Bookings',
    ),
    _NavItem(
      activeIcon: Iconsax.message5,
      inactiveIcon: Iconsax.message4,
      label: 'Chat',
    ),
    _NavItem(
      activeIcon: Iconsax.user,
      inactiveIcon: Iconsax.user,
      label: 'Profile',
    ),
  ];

  static const _screens = [
    PatientHomeScreen(),
    DoctorsMapScreen(),
    MyBookingsScreen(),
    ConversationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _startServer();
    sl<FavoritesCubit>().getFavorites();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MedicalProfileBottomSheet.showIfNeeded(context);
    });
  }

  void _startServer() async {
    accessToken = await CacheHelper.getData(key: ApiKeys.accessToken);
    ServerConnection().connect(accessToken: accessToken!);
    NotificationManager.instance.start(sl<FcmTokenDataSource>());
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 2) sl<MyBookingsCubit>().getBookings();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _NavBar(
        items: _tabs,
        currentIndex: _currentIndex,
        isDark: isDark,
        onTap: _onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nav bar
// ---------------------------------------------------------------------------

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.items,
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey900 : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / items.length;
            final indicatorW = 16.w;
            final indicatorLeft =
                (currentIndex + 0.5) * tabWidth - (indicatorW / 2);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Tabs
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  child: Row(
                    children: List.generate(items.length, (i) {
                      final isActive = currentIndex == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onTap(i),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: Icon(
                                  isActive
                                      ? items[i].activeIcon
                                      : items[i].inactiveIcon,
                                  size: 24.sp,
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.grey500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                items[i].label,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Sliding half-circle indicator at the top edge
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: indicatorLeft,
                  top: 0, // Half above the bar edge
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 0.5, // Show only the bottom half
                      child: Container(
                        width: indicatorW,
                        height: indicatorW,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class _NavItem {
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });

  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
}
