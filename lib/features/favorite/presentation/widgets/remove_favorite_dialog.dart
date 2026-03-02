import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/confirmation_dialog.dart';

class RemoveFavoriteDialog extends StatelessWidget {
  final String doctorName;
  final VoidCallback onConfirm;

  const RemoveFavoriteDialog({
    super.key,
    required this.doctorName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: AppStrings.removeFromFavorites,
      message: '${AppStrings.areYouSureRemoveFavorite}\n$doctorName',
      confirmText: AppStrings.yesRemove,
      onConfirm: onConfirm,
    );
  }
}
