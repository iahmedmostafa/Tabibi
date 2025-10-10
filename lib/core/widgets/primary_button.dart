import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPress;
  const PrimaryButton({
    super.key,
    this.onPress,
    required this.height,
    required this.width,
    required this.title,
  });

  final double height;
  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          
          onPressed: onPress,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge
          ),
        ),
      ),
    );
  }
}
