import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/pages/create_new_password.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_location_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/approved_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/clinic_location_screen.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/doctor_fill_profile.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/new_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/pending_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/rejected_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/doctor_status_handler.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/pages/fill_profile.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/pages/forgot_password.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/pages/login.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/pages/signup.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/pages/verify_code.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';
import 'package:tabibi/features/booking/presentation/controller/prescription_cubit.dart';
import 'package:tabibi/features/booking/presentation/screens/book_appointment_screen.dart';
import 'package:tabibi/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:tabibi/features/booking/presentation/screens/prescription_screen.dart';
import 'package:tabibi/features/chat_patient/presentation/pages/chat_screen.dart';
import 'package:tabibi/features/doctor/chat/presentation/pages/doctor_chat_screen.dart';
import 'package:tabibi/features/doctor/chat/presentation/pages/doctor_conversations_screen.dart';
// Doctor feature imports
import 'package:tabibi/features/doctor/appointments/presentation/pages/appointment_details_page.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';
import 'package:tabibi/features/doctor/availability/presentation/pages/edit_availability_page.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart'
    as doctor_entities;
import 'package:tabibi/features/doctor/earnings/presentation/pages/earnings_page.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/patients/presentation/pages/patient_profile_page.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_page.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';
import 'package:tabibi/features/doctor/profile/presentation/pages/settings_page.dart';
import 'package:tabibi/features/doctor/requests/presentation/pages/appointment_requests_page.dart';
import 'package:tabibi/features/doctor/reviews/presentation/pages/reviews_page.dart';
import 'package:tabibi/features/doctor/schedule/presentation/pages/my_schedule_page.dart';
import 'package:tabibi/features/doctor_details/data/models/doctor_details_model.dart';
import 'package:tabibi/features/doctor_details/presentation/screens/doctor_details_screen.dart';
import 'package:tabibi/features/doctor_details/presentation/screens/doctor_reviews_screen.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctors_map/presentation/screens/doctors_map_screen.dart';
import 'package:tabibi/features/favorite/presentation/screens/favorites_screen.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/presentation/screen/doctor/home_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/all_doctors_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/bottom_nav_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/screens/patient_home_screen.dart';
import 'package:tabibi/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:tabibi/features/onboarding/presentation/screens/onboarding.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/screens/edit_profile_screen.dart';
import 'package:tabibi/features/video_call/presentation/cubit/video_call_cubit.dart';
import 'package:tabibi/features/video_call/presentation/screen/video_call_screen.dart';
import 'package:tabibi/core/utils/enums/enums.dart';

import '../../features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import '../../features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import '../services/shared_prefs_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,

  initialLocation: OnboardingServices.isFirstTime()
      ? AppRoutes.onboarding
      : (OnboardingServices.isLoggedIn()
            ? (OnboardingServices.getRole() == '2'
                  ? AppRoutes.homeDoctorScreen
                  : (OnboardingServices.isProfileFilled()
                        ? AppRoutes.bottomNavScreen
                        : AppRoutes.fillProfile))
            : AppRoutes.login),

  routes: [
    GoRoute(
      path: AppRoutes.onboarding,

      name: AppRoutes.onboarding,

      builder: (context, state) => const OnBoardingScreen(),
    ),

    GoRoute(
      path: AppRoutes.login,

      name: AppRoutes.login,

      builder: (context, state) {
        return BlocProvider(
          create: (context) => sl<LogInCubit>(),

          child: const LoginScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,

      name: AppRoutes.forgotPassword,

      builder: (context, state) => BlocProvider(
        create: (context) => sl<ForgotPasswordCubit>(),

        child: const ForgotPasswordScreen(),
      ),
    ),

    GoRoute(
      path: '${AppRoutes.verifyCode}/:email',

      name: AppRoutes.verifyCode,

      builder: (context, state) {
        final email = state.pathParameters['email'] ?? '';

        final extra = state.extra;

        final originStr = (extra is Map && extra['origin'] != null)
            ? extra['origin'] as String
            : '';

        var originEnum = VerifyOrigin.unknown;

        if (originStr == 'signup') originEnum = VerifyOrigin.signup;

        if (originStr == 'forgot') originEnum = VerifyOrigin.forgot;

        return BlocProvider(
          create: (context) {
            final cubit = sl<VerifyCodeCubit>();

            cubit.setTargetEmail(email);

            if (originStr.isNotEmpty) cubit.setOrigin(originEnum);

            return cubit;
          },

          child: const VerifyCodeScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createNewPassword,

      name: AppRoutes.createNewPassword,

      builder: (context, state) {
        final email = state.extra as String? ?? '';

        return BlocProvider(
          create: (context) {
            final cubit = sl<CreateNewPasswordCubit>();

            cubit.setTargetEmail(email);

            return cubit;
          },

          child: const CreateNewPassword(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.signUp,

      name: AppRoutes.signUp,

      builder: (context, state) => BlocProvider(
        create: (context) => sl<SignUpCubit>(),

        child: const SignupScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.home,

      name: AppRoutes.home,

      builder: (context, state) => const BottomNavScreen(),
    ),

    GoRoute(
      path: AppRoutes.homeDoctorScreen,

      name: AppRoutes.homeDoctorScreen,

      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.fillProfile,

      name: AppRoutes.fillProfile,

      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<UploadImageCubit>()),

          BlocProvider(create: (context) => sl<CitiesCubit>()..getCities()),

          BlocProvider(
            create: (context) => sl<PatientProfileCubit>()..getPatientProfile(),
          ),
        ],

        child: const FillProfile(),
      ),
    ),

    GoRoute(
      path: AppRoutes.doctorFillProfile,

      name: AppRoutes.doctorFillProfile,

      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<DoctorFillProfileFormCubit>()),

          BlocProvider(create: (context) => sl<UploadImageCubit>()),

          BlocProvider(create: (context) => sl<CitiesCubit>()..getCities()),

          BlocProvider(
            create: (context) => sl<DepartmentsCubit>()..getDepartments(),
          ),

          BlocProvider(create: (context) => sl<CredentialUploadImageCubit>()),

          BlocProvider(create: (context) => sl<ClinicUploadImageCubit>()),

          BlocProvider(
            create: (context) => sl<DoctorProfileCubit>()..getDoctorProfile(),
          ),
        ],

        child: const DoctorFillProfile(),
      ),
    ),

    GoRoute(
      path: AppRoutes.patientHome,

      name: AppRoutes.patientHome,

      builder: (context, state) => const PatientHomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.pending,

      name: AppRoutes.pending,

      builder: (context, state) => const PendingPage(),
    ),

    GoRoute(
      path: AppRoutes.approved,

      name: AppRoutes.approved,

      builder: (context, state) => const ApprovedPage(),
    ),

    GoRoute(
      path: AppRoutes.newpage,

      name: AppRoutes.newpage,

      builder: (context, state) => const NewPage(),
    ),

    GoRoute(
      path: AppRoutes.rejected,

      name: AppRoutes.rejected,

      builder: (context, state) => const RejectedPage(),
    ),

    GoRoute(
      path: AppRoutes.clinicLocation,

      name: AppRoutes.clinicLocation,

      builder: (context, state) => BlocProvider(
        create: (_) => sl<ClinicLocationCubit>()..initialize(),

        child: const ClinicLocationScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.doctorStatusHandler,

      name: AppRoutes.doctorStatusHandler,

      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorProfileCubit>()..getDoctorStatus(),

        child: const DoctorStatusHandler(),
      ),
    ),

    GoRoute(
      path: AppRoutes.bottomNavScreen,

      name: AppRoutes.bottomNavScreen,

      builder: (context, state) {
        final initialIndex = state.extra as int? ?? 0;

        return BottomNavScreen(initialIndex: initialIndex);
      },
    ),

    GoRoute(
      path: AppRoutes.allDoctors,

      name: AppRoutes.allDoctors,

      builder: (context, state) {
        final departmentId = state.extra as String?;

        return BlocProvider(
          create: (context) =>
              sl<DoctorsCubit>()..getDoctors(departmentId: departmentId),

          child: AllDoctorsScreen(initialDepartmentId: departmentId),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.doctorDetails,

      name: AppRoutes.doctorDetails,

      builder: (context, state) {
        final doctor = state.extra as DoctorModel;

        return DoctorDetailsScreen(doctor: doctor);
      },
    ),

    GoRoute(
      path: AppRoutes.bookAppointment,

      name: AppRoutes.bookAppointment,

      builder: (context, state) {
        final doctor = state.extra as DoctorDetailsModel;

        return BlocProvider(
          create: (context) => sl<AppointmentCubit>(),

          child: BookAppointmentScreen(doctor: doctor),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.myBookings,

      name: AppRoutes.myBookings,

      builder: (context, state) {
        final initialStatus = state.extra is BookingStatus
            ? state.extra as BookingStatus
            : BookingStatus.upcoming;

        return MyBookingsScreen(initialStatus: initialStatus);
      },
    ),

    GoRoute(
      path: AppRoutes.notifications,

      name: AppRoutes.notifications,

      builder: (context, state) => const NotificationsScreen(),
    ),

    GoRoute(
      path: AppRoutes.favorites,

      name: AppRoutes.favorites,

      builder: (context, state) => const FavoritesScreen(),
    ),

    GoRoute(
      path: AppRoutes.doctorsMapScreen,

      name: AppRoutes.doctorsMapScreen,

      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorsCubit>(),

        child: const DoctorsMapScreen(),
      ),
    ),

    GoRoute(
      path: '${AppRoutes.doctorReviews}/:doctorId',

      name: AppRoutes.doctorReviews,

      builder: (context, state) {
        final doctorId = state.pathParameters['doctorId'] ?? '';

        return DoctorReviewsScreen(doctorId: doctorId);
      },
    ),

    GoRoute(
      path: '${AppRoutes.prescription}/:bookingId',

      name: AppRoutes.prescription,

      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? '';

        return BlocProvider(
          create: (context) =>
              sl<PrescriptionCubit>()..getPrescription(bookingId: bookingId),

          child: const PrescriptionScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chat,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChatScreen(
          doctorId: extra['doctorId'] as String? ?? '',
          doctorName: extra['doctorName'] as String? ?? '',
          doctorImage: extra['doctorImage'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.callPage,
      name: AppRoutes.callPage,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BlocProvider(
          create: (context) => sl<VideoCallCubit>(),
          child: CallPage(bookingId: extra['bookingId'] as String? ?? ''),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRoutes.editProfile,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<CitiesCubit>()..getCities()),
          BlocProvider(create: (context) => sl<UploadImageCubit>()),
          BlocProvider(
            create: (context) => sl<PatientProfileCubit>()..getPatientProfile(),
          ),
        ],
        child: const EditProfileScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.doctorSchedule,
      name: AppRoutes.doctorSchedule,
      builder: (context, state) => BlocProvider(
        create: (_) => AvailabilityCubit(),
        child: const MySchedulePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.doctorAvailability,
      name: AppRoutes.doctorAvailability,
      builder: (context, state) => BlocProvider(
        create: (_) => AvailabilityCubit(),
        child: const EditAvailabilityPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.doctorRequests,
      name: AppRoutes.doctorRequests,
      builder: (context, state) => const AppointmentRequestsPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorEarnings,
      name: AppRoutes.doctorEarnings,
      builder: (context, state) => const EarningsPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorSettings,
      name: AppRoutes.doctorSettings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorAppointmentDetails,
      name: AppRoutes.doctorAppointmentDetails,
      builder: (context, state) {
        final appointment = state.extra as doctor_entities.Appointment;
        return AppointmentDetailsPage(appointment: appointment);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorPatientProfile,
      name: AppRoutes.doctorPatientProfile,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          return PatientProfilePage(
            patient: extra['patient'] as Patient,
            appointmentId: extra['appointmentId'] as String?,
            appointmentDate: extra['appointmentDate'] as DateTime?,
            prescriptionWritePolicy:
                extra['prescriptionWritePolicy'] as PrescriptionWritePolicy? ??
                    const PrescriptionWritePolicy.allowed(),
          );
        }
        return PatientProfilePage(patient: extra as Patient);
      },
    ),
    GoRoute(
      path: AppRoutes.doctorCreatePrescription,
      name: AppRoutes.doctorCreatePrescription,
      builder: (context, state) {
        final args = state.extra as CreatePrescriptionArgs;
        return BlocProvider(
          create: (context) =>
              sl<CreatePrescriptionCubit>()..initialize(
                appointmentId: args.appointmentId,
                appointmentDate: args.appointmentDate,
              ),
          child: CreatePrescriptionPage(args: args),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.doctorReviewsPage,
      name: AppRoutes.doctorReviewsPage,
      builder: (context, state) => const ReviewsPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorConversations,
      name: AppRoutes.doctorConversations,
      builder: (context, state) => const DoctorConversationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.doctorChat,
      name: AppRoutes.doctorChat,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return DoctorChatScreen(
          patientId: extra['patientId'] as String? ?? '',
          patientName: extra['patientName'] as String? ?? '',
          patientImage: extra['patientImage'] as String?,
        );
      },
    ),
  ],
);
