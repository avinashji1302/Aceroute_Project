import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controller/fontSizeController.dart';

class DatePickerDialog extends StatefulWidget {
  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  int? _selectedYear;
  int? _selectedMonth;
  DateTime? _selectedDate;
  final fontSizeController = Get.find<FontSizeController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Date'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Year Picker
          if (_selectedYear == null)
            Expanded(
              child: ListView.builder(
                itemCount: 101,
                itemBuilder: (context, index) {
                  final year = DateTime.now().year - 50 + index;
                  return ListTile(
                    title: Text('$year'),
                    onTap: () {
                      setState(() {
                        _selectedYear = year;
                        _selectedMonth = null;
                        _selectedDate = null;
                      });
                    },
                  );
                },
              ),
            ),
          // Month Picker
          if (_selectedYear != null && _selectedMonth == null)
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  return ListTile(
                    title: Text(DateFormat('MMMM').format(DateTime(_selectedYear!, month))),
                    onTap: () {
                      setState(() {
                        _selectedMonth = month;
                        _selectedDate = null;
                      });
                    },
                  );
                },
              ),
            ),
          // Day Picker
          if (_selectedYear != null && _selectedMonth != null)
            Expanded(
              child: CalendarDatePicker(
                initialDate: _selectedDate ?? DateTime(_selectedYear!, _selectedMonth!),
                firstDate: DateTime(_selectedYear!, _selectedMonth!),
                lastDate: DateTime(_selectedYear!, _selectedMonth! + 1, 0),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_selectedDate != null) {
              Navigator.of(context).pop(_selectedDate);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
