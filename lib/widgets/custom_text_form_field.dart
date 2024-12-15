import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final Icon icon;
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  Color _iconColor = Colors.grey; // Warna default ikon

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Menambahkan listener untuk mendeteksi perubahan fokus
    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus
            ? const Color(0xFF0077B6)
            : Colors.grey; // Ubah warna ikon
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Pastikan untuk membuang FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode, // Menghubungkan FocusNode
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon.icon,
          color: _iconColor, // Menggunakan warna yang ditentukan
        ),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: const Color(0xFF0077B6),
          ),
        ),
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
    );
  }
}
