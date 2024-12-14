import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final String text1;
  final VoidCallback press1;

  const ExpandedButton({
    super.key,
    required this.text1,
    required this.press1,
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
                backgroundColor: Colors.blue, // Warna merah untuk tombol Hapus
              ),
              child: Text(
                text1,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
