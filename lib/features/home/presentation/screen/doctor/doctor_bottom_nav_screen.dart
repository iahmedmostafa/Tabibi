import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/chat/presentation/pages/doctor_conversations_screen.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    final tabs = [
      _NavItem(
        activeIcon: Icons.dashboard,
        inactiveIcon: Icons.dashboard_outlined,
        label: loc.dashboard,
      ),
      _NavItem(
        activeIcon: Icons.calendar_month,
        inactiveIcon: Icons.calendar_month_outlined,
        label: loc.schedule,
      ),
      _NavItem(
        activeIcon: Icons.chat_bubble,
        inactiveIcon: Icons.chat_bubble_outline,
        label: loc.chats,
      ),
      _NavItem(
        activeIcon: Icons.settings,
        inactiveIcon: Icons.settings_outlined,
        label: loc.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardPage(showBottomNav: false),
          MySchedulePage(showBottomNav: false),
          DoctorConversationsScreen(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: _DoctorNavBar(
        items: tabs,
        currentIndex: _currentIndex,
        isDark: isDark,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _DoctorNavBar extends StatelessWidget {
  const _DoctorNavBar({
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
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: indicatorLeft,
                  top: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 0.5,
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
