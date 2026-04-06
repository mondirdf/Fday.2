import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeuButton extends StatefulWidget {
  const NeuButton({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: AppColors.base,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _pressed
              ? const [
                  BoxShadow(
                    color: AppColors.darkShadow,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ]
              : const [
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
        child: DefaultTextStyle(
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
