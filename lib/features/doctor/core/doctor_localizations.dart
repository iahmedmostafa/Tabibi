import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DoctorLocalizations {
  DoctorLocalizations._();

  static DoctorLocalizations of(BuildContext context) =>
      DoctorLocalizations._();

  String get welcomeBack => "${'welcomeBack'.tr()},";
  String get today => 'todayLabel'.tr();
  String get done => 'done'.tr();
  String get refunded => 'refunded'.tr();
  String get quickActions => 'quickActions'.tr();
  String get schedule => 'schedule'.tr();
  String get requests => 'requests'.tr();
  String get availability => 'availability'.tr();
  String get earnings => 'earnings'.tr();
  String get todayAppointments => 'todayAppointments'.tr();
  String get seeAll => 'seeAll'.tr();
  String get noAppointmentsToday => 'noAppointmentsToday'.tr();
  String get appointmentRequests => 'appointmentRequests'.tr();
  String get viewAndManage => 'viewAndManage'.tr();
  String get retry => 'retry'.tr();

  String get mySchedule => 'mySchedule'.tr();
  String appointmentsCount(int count) => '$count ${"appointmentsLabel".tr()}';

  String get settings => 'settings'.tr();
  String get account => 'account'.tr();
  String get personalInfo => 'personalInfo'.tr();
  String get editProfile => 'editDoctorProfile'.tr();
  String get clinicInfo => 'clinicInformation'.tr();
  String get specialization => 'specialization'.tr();
  String get security => 'security'.tr();
  String get changePassword => 'changePassword'.tr();
  String get twoFactor => 'twoFactor'.tr();
  String get dangerZone => 'dangerZone'.tr();
  String get logOut => 'logOut'.tr();
  String get deleteAccount => 'deleteAccount'.tr();
  String get deleteAccountConfirm => 'deleteAccountConfirm'.tr();
  String get cancel => 'cancel'.tr();
  String get delete => 'delete'.tr();
  String get rating => 'ratingStat'.tr();
  String get reviews => 'reviews'.tr();
  String get years => 'years'.tr();
  String get doctor => 'doctor'.tr();
  String get loadingProfile => 'loadingProfile'.tr();
  String get errorLoadingProfile => 'errorLoadingProfile'.tr();

  String get dashboard => 'dashboard'.tr();
  String get chats => 'chats'.tr();

  String get notifications => 'notifications'.tr();
  String get enabled => 'enabled'.tr();
  String get workingHours => 'workingHours'.tr();
  String get viewMyReviews => 'viewMyReviews'.tr();

  String get language => 'language'.tr();
  String get english => 'english'.tr();
  String get arabic => 'arabic'.tr();
}
