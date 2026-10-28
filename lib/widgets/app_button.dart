import 'package:flutter/material.dart';


const _coral = Color(0xFFE5533D);
const _teal = Color(0xFF0F7A7C);
const _outline = Color(0xFFC43E2A);

enum AppButtonStyle { coral, teal, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonStyle style;
  final bool expand; 
  final bool compact; 
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = AppButtonStyle.coral,
    this.expand = false,
    this.compact = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        Text(
          text,
          style: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(28));
    final minSize = Size(0, compact ? 44 : 56);
    final padding = EdgeInsets.symmetric(horizontal: compact ? 16 : 24);

    final Widget button;
    if (style == AppButtonStyle.outline) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _outline,
          side: const BorderSide(color: _outline, width: 2),
          shape: shape,
          minimumSize: minSize,
          padding: padding,
        ),
        child: label,
      );
    } else {
      button = FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: style == AppButtonStyle.coral ? _coral : _teal,
          foregroundColor: Colors.white,
          shape: shape,
          minimumSize: minSize,
          padding: padding,
        ),
        child: label,
      );
    }
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}