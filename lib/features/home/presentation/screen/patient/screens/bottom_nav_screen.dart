import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    startServer();
    sl<FavoritesCubit>().getFavorites();
    // Show medical profile bottom sheet after register if not completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MedicalProfileBottomSheet.showIfNeeded(context);
    });
  }

  void startServer() async {
    accessToken = await CacheHelper.getData(key: ApiKeys.accessToken);
    ServerConnection().connect(accessToken: accessToken!);
    NotificationManager.instance.start(sl<FcmTokenDataSource>());
  }

  final List<Widget> _screens = [
    const PatientHomeScreen(),
    const DoctorsMapScreen(),
    const MyBookingsScreen(),
    const ConversationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            sl<MyBookingsCubit>().getBookings();
          }
        },
        selectedItemColor: isDark ? AppColors.white : AppColors.primary,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.location), label: 'Maps'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
