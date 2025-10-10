import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';

class ArrowBack extends StatelessWidget {
  final String nameRoute;
   const ArrowBack({
    super.key,
    required this.nameRoute
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.go(nameRoute);
          },
          icon: Image.asset(AppImages.back),
        ),
      ],
    );
  }
}
