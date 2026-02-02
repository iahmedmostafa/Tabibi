import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/doctors_map_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/patient_home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PatientHomeScreen(),
    BlocProvider(
      create: (_) => sl<DoctorsCubit>()..getDoctors(),
      child: const DoctorsMapScreen(),
    ),
    const Scaffold(body: Center(child: Text("Calendar"))),
    const Scaffold(body: Center(child: Text("Profile"))),
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
