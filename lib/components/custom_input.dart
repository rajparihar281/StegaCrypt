// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isMultiline;
  final int maxLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isMultiline = false,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 83, 77, 77).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: isMultiline ? maxLines : 1,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(fontSize: 16),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          prefixIcon:
              prefixIcon != null
                  ? Container(
                    margin: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      prefixIcon,
                      color: Colors.blueAccent.shade200,
                      size: 22,
                    ),
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
          ),
          // These properties help center the hint text properly
          alignLabelWithHint: true,
          isCollapsed: false,
          isDense: false,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
