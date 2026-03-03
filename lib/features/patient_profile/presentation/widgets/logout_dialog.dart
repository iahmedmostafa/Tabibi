import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/confirmation_dialog.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: AppStrings.logout,
      message: AppStrings.areYouSureLogout,
      confirmText: AppStrings.yesLogout,
      onConfirm: onLogout,
    );
  }
}
