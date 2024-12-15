import 'package:flutter/material.dart';

class CalculatorListContainer extends StatelessWidget {
  final String text1;
  final VoidCallback tap1;

  const CalculatorListContainer({
    super.key,
    required this.text1,
    required this.tap1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFCAF0F8),
          ),
          width: double.infinity,
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text1,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF03045E)),
            ),
          ),
        ),
      ),
    );
  }
}
