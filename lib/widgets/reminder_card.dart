import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String medicineName;
  final String time;
  final String medicineType;
  final bool isDue;
  final bool isChecked;
  final Function(bool?) onChanged;

  const ReminderCard({
    Key? key,
    required this.medicineName,
    required this.time,
    required this.medicineType,
    required this.isDue,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFCAF0F8),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Medicine icon or placeholder circle
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication, // Replace icon
                  color: const Color(0xFF03045E),
                ),
              ),
              const SizedBox(width: 12.0),
              // Medicine details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF03045E),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                  ),
                ],
              ),
            ],
          ),
          // Checkbox
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}