import 'package:flutter/material.dart';

class DoctorLocalizations {
  final Locale locale;

  DoctorLocalizations(this.locale);

  static DoctorLocalizations of(BuildContext context) {
    Locale currentLocale;
    try {
      currentLocale = Localizations.localeOf(context);
    } catch (_) {
      currentLocale = const Locale('en');
    }
    return DoctorLocalizations(currentLocale);
  }

  bool get isAr => locale.languageCode == 'ar';

  // Dashboard
  String get welcomeBack => isAr ? 'مرحبًا بعودتك،' : 'Welcome back,';
  String get today => isAr ? 'اليوم' : 'Today';
  String get done => isAr ? 'مكتمل' : 'Done';
  String get refunded => isAr ? 'مسترد' : 'Refunded';
  String get quickActions => isAr ? 'إجراءات سريعة' : 'Quick Actions';
  String get schedule => isAr ? 'الجدول' : 'Schedule';
  String get requests => isAr ? 'الطلبات' : 'Requests';
  String get availability => isAr ? 'التوفر' : 'Availability';
  String get earnings => isAr ? 'الأرباح' : 'Earnings';
  String get todayAppointments => isAr ? 'مواعيد اليوم' : "Today's Appointments";
  String get seeAll => isAr ? 'عرض الكل' : 'See All';
  String get noAppointmentsToday => isAr ? 'لا مواعيد اليوم' : 'No appointments today';
  String get appointmentRequests => isAr ? 'طلبات المواعيد' : 'Appointment Requests';
  String get viewAndManage => isAr ? 'عرض وإدارة' : 'View & manage';
  String get retry => isAr ? 'إعادة المحاولة' : 'Retry';

  // Schedule
  String get mySchedule => isAr ? 'جدولي' : 'My Schedule';
  String appointmentsCount(int count) =>
      isAr ? '$count مواعيد' : '$count Appointments';

  // Settings / Profile
  String get settings => isAr ? 'الإعدادات' : 'Settings';
  String get account => isAr ? 'الحساب' : 'Account';
  String get personalInfo => isAr ? 'المعلومات الشخصية' : 'Personal Information';
  String get editProfile => isAr ? 'تعديل الملف الشخصي' : 'Edit profile';
  String get clinicInfo => isAr ? 'معلومات العيادة' : 'Clinic Information';
  String get specialization => isAr ? 'التخصص' : 'Specialization';
  String get security => isAr ? 'الأمان' : 'Security';
  String get changePassword => isAr ? 'تغيير كلمة المرور' : 'Change Password';
  String get twoFactor => isAr ? 'المصادقة الثنائية' : 'Two-Factor Authentication';
  String get dangerZone => isAr ? 'منطقة الخطر' : 'Danger Zone';
  String get logOut => isAr ? 'تسجيل الخروج' : 'Log Out';
  String get deleteAccount => isAr ? 'حذف الحساب' : 'Delete Account';
  String get deleteAccountConfirm => isAr
      ? 'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.'
      : 'Are you sure you want to delete your account? This action cannot be undone.';
  String get cancel => isAr ? 'إلغاء' : 'Cancel';
  String get delete => isAr ? 'حذف' : 'Delete';
  String get rating => isAr ? 'التقييم' : 'Rating';
  String get reviews => isAr ? 'المراجعات' : 'Reviews';
  String get years => isAr ? 'سنوات' : 'Years';
  String get doctor => isAr ? 'طبيب' : 'Doctor';
  String get loadingProfile => isAr ? 'جاري تحميل الملف الشخصي...' : 'Loading profile...';
  String get errorLoadingProfile => isAr ? 'تعذر تحميل الملف الشخصي' : 'Could not load profile';

  // Bottom Nav
  String get dashboard => isAr ? 'الرئيسية' : 'Dashboard';
  String get chats => isAr ? 'المحادثات' : 'Chats';

  // Additional settings fields
  String get notifications => isAr ? 'الإشعارات' : 'Notifications';
  String get enabled => isAr ? 'مفعّل' : 'Enabled';
  String get workingHours => isAr ? 'ساعات العمل' : 'Working Hours';
  String get viewMyReviews => isAr ? 'عرض تقييماتي' : 'View My Reviews';
}

