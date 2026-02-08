import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget widget;
  final bool isSelected;

  const CustomContainer({
    super.key,
    required this.widget,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue.withOpacity(.15)
            : Colors.grey.withOpacity(.25),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isSelected ? Colors.blue : Colors.black26),
      ),
      child: Center(child: widget),
    );
  }
}
