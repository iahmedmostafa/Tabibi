import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tabibi/features/doctor/profile/presentation/pages/settings_page.dart';
import 'package:tabibi/features/doctor/schedule/presentation/pages/my_schedule_page.dart';

class DoctorBottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const DoctorBottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<DoctorBottomNavScreen> createState() => _DoctorBottomNavScreenState();
}

class _DoctorBottomNavScreenState extends State<DoctorBottomNavScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailabilityCubit(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardPage(showBottomNav: false),
            MySchedulePage(showBottomNav: false),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1C2A3A),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
