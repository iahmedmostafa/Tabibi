import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';

class AddSlotDialog extends StatefulWidget {
  const AddSlotDialog({super.key});

  @override
  State<AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<AddSlotDialog> {
  String selectedDay = 'monday'.tr();
  final List<String> days = [
    'monday'.tr(),
    'tuesday'.tr(),
    'wednesday'.tr(),
    'thursday'.tr(),
    'friday'.tr(),
    'saturday'.tr(),
    'sunday'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('addTimeSlot'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedDay,
            decoration: InputDecoration(
              labelText: 'selectDay'.tr(),
              border: OutlineInputBorder(),
            ),
            items: days.map((day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedDay = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AvailabilityCubit>().addTimeSlot(selectedDay);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text('add'.tr()),
        ),
      ],
    );
  }
}
