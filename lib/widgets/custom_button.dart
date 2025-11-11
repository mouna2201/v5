import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool outlined;

  const CustomButton({super.key, required this.text, required this.onTap, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : Colors.green.shade700,
          border: outlined ? Border.all(color: Colors.green.shade700, width: 2) : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: outlined
              ? []
              : [BoxShadow(color: Colors.green.shade200, blurRadius: 6, offset: const Offset(0, 3))],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: outlined ? Colors.green.shade700 : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
