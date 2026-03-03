import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';

class AddBreakDialog extends StatefulWidget {
  const AddBreakDialog({super.key});

  @override
  State<AddBreakDialog> createState() => _AddBreakDialogState();
}

class _AddBreakDialogState extends State<AddBreakDialog> {
  final TextEditingController _labelController = TextEditingController(
    text: 'Break',
  );

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Break Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Break Label',
              border: OutlineInputBorder(),
              hintText: 'e.g., Lunch Break',
            ),
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
            final cubit = context.read<AvailabilityCubit>();
            cubit.addBreakTime();

            // Update the label if provided
            if (_labelController.text.isNotEmpty &&
                cubit.state.breakTimes.isNotEmpty) {
              final lastBreak = cubit.state.breakTimes.last;
              cubit.updateBreakTime(lastBreak.id, label: _labelController.text);
            }

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
