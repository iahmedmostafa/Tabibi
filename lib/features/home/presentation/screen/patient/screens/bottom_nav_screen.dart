import 'package:flutter/material.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/profile_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/patient_home_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/my_bookings_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PatientHomeScreen(),
    Scaffold(body: Center(child: Text("Maps"))),
    MyBookingsScreen(),
    ProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
