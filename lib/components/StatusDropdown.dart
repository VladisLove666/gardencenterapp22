import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final List<String> statuses;
  final String? selectedStatus;
  final Function(String?) onChanged;

  StatusDropdown({
    required this.statuses,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedStatus,
      hint: Text('Выберите статус'),
      onChanged: onChanged,
      items: statuses.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
    );
  }
}