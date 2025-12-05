import 'package:flutter/material.dart';

class ProfilePageHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onBackPressed;

  const ProfilePageHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onBackPressed,
  });

  String _getPageTitle() {
    switch (currentPage) {
      case 0:
        return "Fill Your Profile";
      case 1:
        return "Upload Credentials";
      case 2:
        return "complete your clinic profile";
      case 3:
        return "Set Work Schedule";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          _getPageTitle(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
