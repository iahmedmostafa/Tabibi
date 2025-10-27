import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPress;
  const PrimaryButton({
    super.key,
    this.onPress,
  
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: AppHeight.h50,
            width: AppWidth.w342,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style,
        onPressed: onPress,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge
        ),
      ),
    );
  }
}
