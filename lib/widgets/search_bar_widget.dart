import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enabled;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // 🔹 IDENTIQUE HomeScreen
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade400,
          ),
          suffixIcon: controller.text.isNotEmpty && onClear != null
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey.shade400),
            onPressed: onClear,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, // 🔹 IDENTIQUE HomeScreen
            vertical: 16,   // 🔹 IDENTIQUE HomeScreen
          ),
        ),
      ),
    );
  }
}
