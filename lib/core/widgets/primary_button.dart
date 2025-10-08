import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPress;
  const PrimaryButton({super.key, this.onPress, required this.height, required this.width, required this.title});

  final double height ;
  final double width ;
  final String title ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.primary,
            ),
          ),

          onPressed: onPress,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
