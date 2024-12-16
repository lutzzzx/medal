import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final Icon icon;
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool isEdit;
  final List<String>? dropdownItems;
  final String? initialDropdownValue; // Properti baru untuk nilai awal dropdown

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.isEdit = false,
    this.dropdownItems,
    this.initialDropdownValue,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  Color _iconColor = Colors.grey;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus ? const Color(0xFF0077B6) : Colors.grey;
      });
    });

    // Set nilai awal dropdown jika disediakan
    _selectedValue = widget.initialDropdownValue;
    if (widget.initialDropdownValue != null) {
      widget.controller.text = widget.initialDropdownValue!;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: widget.dropdownItems != null
          ? DropdownButtonFormField<String>(
        value: _selectedValue,
        items: widget.dropdownItems!
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
            widget.controller.text = value ?? '';
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value ?? '');
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon.icon,
            color: widget.isEdit ? const Color(0xFF0077B6) : _iconColor,
          ),
          labelText: widget.labelText,
          filled: true,
          fillColor: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
                color: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
                color: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFF0077B6)),
          ),
        ),
        validator: widget.validator,
      )
          : TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon.icon,
            color: widget.isEdit ? const Color(0xFF0077B6) : _iconColor,
          ),
          labelText: widget.labelText,
          filled: true,
          fillColor: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
                color: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
                color: widget.isEdit ? const Color(0xFFCAF0F8) : Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFF0077B6)),
          ),
        ),
        keyboardType: widget.keyboardType,
        validator: widget.validator,
      ),
    );
  }
}
