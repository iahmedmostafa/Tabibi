import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      indent: 62.w,
      endIndent: 16.w,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
    );
  }
}
