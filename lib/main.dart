import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/services/shared_prefs_service.dart';
import 'package:tabibi/core/utils/theme/theme.dart';

import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OnboardingServices.init();
  init();
  runApp(const TabibiApp());
}

class TabibiApp extends StatelessWidget {
  const TabibiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          themeMode: ThemeMode.system,
          darkTheme: AppTheme.darkTheme,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
