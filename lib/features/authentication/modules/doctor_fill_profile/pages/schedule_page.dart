import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/home/data/models/work_schedule_dto.dart';

class SchedulePage extends StatefulWidget {
  final Function(List<WorkScheduleDto>) onScheduleChanged;

  const SchedulePage({super.key, required this.onScheduleChanged});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<WorkScheduleDto> _schedules = [];
  int? _selectedDay;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;

  final List<String> _daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<void> _selectTime(BuildContext context, bool isOpenTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  void _addSchedule() {
    if (_selectedDay != null && _openTime != null && _closeTime != null) {
      setState(() {
        _schedules.add(
          WorkScheduleDto(
            dayOfWeek: _selectedDay!,
            openTime: _formatTime(_openTime!),
            closeTime: _formatTime(_closeTime!),
          ),
        );
        _selectedDay = null;
        _openTime = null;
        _closeTime = null;
      });
      widget.onScheduleChanged(_schedules);
    }
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
    widget.onScheduleChanged(_schedules);
  }

  String _getDayName(int dayIndex) {
    if (dayIndex >= 0 && dayIndex < _daysOfWeek.length) {
      return _daysOfWeek[dayIndex];
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpace(height: AppHeight.h20),
        Text(
          'Set your working hours',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        VerticalSpace(height: AppHeight.h20),
        DropMenu(
          hint: 'Select Day',
          items: _daysOfWeek,
          onChanged: (value) {
            setState(() {
              _selectedDay = _daysOfWeek.indexOf(value!);
            });
          },
          value: _selectedDay != null ? _daysOfWeek[_selectedDay!] : null,
        ),
        VerticalSpace(height: AppHeight.h20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context, true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _openTime != null
                        ? _openTime!.format(context)
                        : 'Open Time',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const HorizentalSpace(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context, false),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _closeTime != null
                        ? _closeTime!.format(context)
                        : 'Close Time',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
        VerticalSpace(height: AppHeight.h20),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(onPress: _addSchedule, title: 'Add Schedule'),
        ),
        VerticalSpace(height: AppHeight.h20),
        Expanded(
          child: ListView.builder(
            itemCount: _schedules.length,
            itemBuilder: (context, index) {
              final schedule = _schedules[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(_getDayName(schedule.dayOfWeek)),
                  subtitle: Text(
                    '${schedule.openTime} - ${schedule.closeTime}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeSchedule(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
