import 'package:flutter/material.dart';

class ChatLocalizations {
  final Locale locale;

  ChatLocalizations(this.locale);

  static ChatLocalizations of(BuildContext context) {
    // Falls back to English if no locale is found
    Locale currentLocale;
    try {
      currentLocale = Localizations.localeOf(context);
    } catch (_) {
      currentLocale = const Locale('en');
    }
    return ChatLocalizations(currentLocale);
  }

  bool get isAr => locale.languageCode == 'ar';

  String get chats => isAr ? 'المحادثات' : 'Chats';
  String get patientChats => isAr ? 'محادثات المرضى' : 'Patient Chats';
  String get search => isAr ? 'بحث...' : 'Search...';
  String get noChats => isAr ? 'لا توجد محادثات بعد' : 'No patient chats yet';
  String get noChatsDesc => isAr ? 'الرسائل من المرضى ستظهر هنا' : 'Messages from patients will appear here';
  String get failedLoad => isAr ? 'فشل تحميل المحادثات' : 'Failed to load chats';
  String get retry => isAr ? 'إعادة المحاولة' : 'Retry';
  String get today => isAr ? 'اليوم' : 'Today';
  String get yesterday => isAr ? 'أمس' : 'Yesterday';
  String get expiredBanner => isAr ? 'الدردشة متاحة فقط لمدة 7 أيام بعد موعدك.' : 'Chat is only available for 7 days after your appointment.';
  String get expiredBar => isAr ? 'انتهت صلاحية هذه الدردشة.' : 'This chat has expired.';
  String get typeMessage => isAr ? 'اكتب رسالة...' : 'Type a message...';
  String get noMessages => isAr ? 'لا توجد رسائل بعد' : 'No messages yet';
  String get startConversation => isAr ? 'ابدأ المحادثة!' : 'Start the conversation!';
  String get couldNotLoadMessages => isAr ? 'تعذر تحميل الرسائل' : 'Could not load messages';
  String get patient => isAr ? 'مريض' : 'Patient';
  String get unknownPatient => isAr ? 'مريض غير معروف' : 'Unknown Patient';
}
