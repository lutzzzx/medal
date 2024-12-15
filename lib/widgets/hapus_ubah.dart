import 'package:flutter/material.dart';

class HapusUbah extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback press1;
  final VoidCallback press2;

  const HapusUbah({
    super.key,
    required this.text1,
    required this.text2,
    required this.press1,
    required this.press2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: press1,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna merah untuk tombol Hapus
              ),
              child: Text(
                text1,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: ElevatedButton(
              onPressed: press2,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna biru untuk tombol Update
              ),
              child: Text(
                text2,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
