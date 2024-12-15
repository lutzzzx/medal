import 'package:flutter/material.dart';

class ReminderFormField extends StatefulWidget {
  final Icon icon;
  final TextEditingController controller;
  final String labelHint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; // Optional onChanged callback

  const ReminderFormField({
    super.key,
    required this.icon,
    required this.controller,
    required this.labelHint,
    required this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  _ReminderFormFieldState createState() => _ReminderFormFieldState();
}

class _ReminderFormFieldState extends State<ReminderFormField> {
  // late FocusNode _focusNode;
  // Color _iconColor = Colors.blue[900]; // Warna default ikon

  @override
  void initState() {
    super.initState();
    // _focusNode = FocusNode();

    // // Menambahkan listener untuk mendeteksi perubahan fokus
    // _focusNode.addListener(() {
    //   setState(() {
    //     _iconColor = _focusNode.hasFocus ? const Color(0xFF0077B6) : Colors.grey; // Ubah warna ikon
    //   });
    // });
  }

  @override
  void dispose() {
    // _focusNode.dispose(); // Pastikan untuk membuang FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Container(
      margin: const EdgeInsets.symmetric( vertical: 8.0), // Apply the margin
      child: TextFormField(
        controller: widget.controller,
        // focusNode: _focusNode, // Menghubungkan FocusNode
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon.icon,
            color: const Color.fromARGB(255, 3, 4, 94), // Menggunakan warna yang ditentukanrgba(3, 4, 94, 1)
          ),
          hintText: widget.labelHint,
          hintStyle: TextStyle(
            color: const Color.fromARGB(255, 3, 4, 94), // Change the label text color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 202, 240, 248),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 202, 240, 248),
            ),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(16.0),
          //   borderSide: const BorderSide(
          //     color: const Color(0xFF0077B6),
          //   ),
          // ),
          fillColor: const Color.fromARGB(255, 202, 240, 248), // Set fill color to light blue
          filled: true,
        ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      ),
    );
  }
}