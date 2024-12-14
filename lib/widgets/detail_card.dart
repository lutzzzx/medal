import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isBold;

  const DetailCard({
    required this.text,
    this.icon,
    this.isBold = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: const Color(0xFF03045E),
              size: 30.0,
            ),
          if (icon != null) const SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF03045E),
              fontSize: 16.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
