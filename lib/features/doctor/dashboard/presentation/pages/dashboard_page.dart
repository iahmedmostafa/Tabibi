import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/quick_action_item.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  final bool showBottomNav;

  const DashboardPage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final appointments = [
      Appointment(
        patientName: 'Sarah Johnson',
        time: '10:00 AM',
        date: 'Today',
        type: 'Regular checkup and blood pressure...',
      ),
      Appointment(
        patientName: 'Michael Chen',
        time: '11:30 AM',
        date: 'Today',
        type: 'Follow-up consultation for diabete...',
      ),
      Appointment(
        patientName: 'Emily Parker',
        time: '2:00 PM',
        date: 'Today',
        type: 'Prescription review and medication...',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dr. David Miller',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green[300],
                    child: const Text(
                      'DM',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stat Cards
              const Row(
                children: [
                  StatCard(
                    label: 'Today',
                    value: '8',
                    icon: Icons.calendar_today,
                    iconColor: AppTheme.blueIcon,
                    backgroundColor: AppTheme.bluePastel,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    label: 'Completed',
                    value: '124',
                    icon: Icons.check_circle_outline,
                    iconColor: AppTheme.greenIcon,
                    backgroundColor: AppTheme.greenPastel,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    label: 'Cancelled',
                    value: '5',
                    icon: Icons.cancel_outlined,
                    iconColor: AppTheme.redIcon,
                    backgroundColor: AppTheme.redPastel,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  QuickActionItem(
                    label: 'Schedule',
                    icon: Icons.calendar_month,
                    iconColor: AppTheme.greenIcon,
                    backgroundColor: AppTheme.greenPastel,
                    onTap: () => context.push(AppRoutes.doctorSchedule),
                  ),
                  const SizedBox(width: 12),
                  QuickActionItem(
                    label: 'Availability',
                    icon: Icons.event_available,
                    iconColor: AppTheme.redIcon,
                    backgroundColor: AppTheme.redPastel,
                    onTap: () => context.push(AppRoutes.doctorAvailability),
                  ),
                  const SizedBox(width: 12),
                  QuickActionItem(
                    label: 'Patients',
                    icon: Icons.people_outline,
                    iconColor: AppTheme.orangeIcon,
                    backgroundColor: AppTheme.orangePastel,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  QuickActionItem(
                    label: 'Earnings',
                    icon: Icons.attach_money,
                    iconColor: AppTheme.purpleIcon,
                    backgroundColor: AppTheme.purplePastel,
                    onTap: () => context.push(AppRoutes.doctorEarnings),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Today's Appointments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Appointments",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
              const SizedBox(height: 8),
              ...appointments.map((apt) => AppointmentCard(appointment: apt)),

              const SizedBox(height: 16),
              // Pending Requests Banner
              GestureDetector(
                onTap: () => context.push(AppRoutes.doctorRequests),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.tealDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Requests',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3 new',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? null // Will be handled by MainLayout
          : null,
    );
  }
}
