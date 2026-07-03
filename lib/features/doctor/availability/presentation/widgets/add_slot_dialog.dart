import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';

class AddSlotDialog extends StatefulWidget {
  const AddSlotDialog({super.key});

  @override
  State<AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<AddSlotDialog> {
  String selectedDay = 'Monday';
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Time Slot'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedDay,
            decoration: const InputDecoration(
              labelText: 'Select Day',
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
          child: const Text('Cancel'),
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
          child: const Text('Add'),
        ),
      ],
    );
  }
}
