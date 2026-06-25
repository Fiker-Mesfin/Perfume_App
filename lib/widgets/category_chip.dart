import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 14),

      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: selected
            ? Colors.transparent
            : Colors.transparent,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: selected
              ? const Color(0xFF8D6B63)
              : Colors.transparent,

          width: 1.5,
        ),
      ),

      child: Text(
        title,
        style: TextStyle(
          color: selected
              ? const Color(0xFF5A1F2D)
              : const Color(0xFFB7A7A2),

          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}