import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/doctor/chat/presentation/pages/doctor_conversations_screen.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tabibi/features/doctor/profile/presentation/pages/settings_page.dart';
import 'package:tabibi/features/doctor/schedule/presentation/pages/my_schedule_page.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';

class DoctorBottomNavScreen extends StatefulWidget {
  final int initialIndex;
  const DoctorBottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<DoctorBottomNavScreen> createState() => _DoctorBottomNavScreenState();
}

class _DoctorBottomNavScreenState extends State<DoctorBottomNavScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    DashboardPage(showBottomNav: false),
    MySchedulePage(showBottomNav: false),
    DoctorConversationsScreen(),
    SettingsPage(),
  ];

  static const _items = [
    _NavItem(icon: Iconsax.home_2,      activeIcon: Iconsax.home_25,      label: 'Home'),
    _NavItem(icon: Iconsax.calendar_1,  activeIcon: Iconsax.calendar_15,  label: 'Schedule'),
    _NavItem(icon: Iconsax.message,     activeIcon: Iconsax.message5,     label: 'Chats'),
    _NavItem(icon: Iconsax.setting_2,   activeIcon: Iconsax.setting_25,   label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTap(int i) {
    if (i == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: _DoctorNavBar(
          currentIndex: _currentIndex,
          items: _items,
          onTap: _onTap,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

// ─────────────────────────────────────────────
// Bar widget
// ─────────────────────────────────────────────
class _DoctorNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _DoctorNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: List.generate(
              items.length,
              (i) => Expanded(
                child: _NavTile(
                  item: items[i],
                  isSelected: i == currentIndex,
                  primary: primary,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single tile
// ─────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final Color primary;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unselected = Theme.of(context)
        .colorScheme
        .onSurfaceVariant
        .withValues(alpha: 0.5);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pill background + icon
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        key: ValueKey(isSelected),
                        size: 22.sp,
                        color: isSelected ? primary : unselected,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          // Dot indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: isSelected ? 18.w : 0,
            height: 3.h,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
