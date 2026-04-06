import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeuInput extends StatelessWidget {
  const NeuInput({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.width,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final field = Container(
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightShadow,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: AppColors.darkShadow,
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.transparent,
        ),
      ),
    );

    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}
