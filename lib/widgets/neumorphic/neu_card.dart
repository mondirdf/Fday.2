import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeuCard extends StatelessWidget {
  const NeuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightShadow,
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: AppColors.darkShadow,
            offset: Offset(6, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}
