import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/services/shared_prefs_service.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/firebase_options.dart';

import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dot_env.dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await OnboardingServices.init();
  Stripe.publishableKey = ApiKeys.publishableKey;

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
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
