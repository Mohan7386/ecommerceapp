import 'package:flutter/material.dart';
import '../../utils/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      style: AppTextStyle.withColor(Colors.black, AppTextStyle.bodyMedium),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppTextStyle.withColor(
            Colors.black, AppTextStyle.bodyMedium),
        prefixIcon: Icon(
            widget.prefixIcon, color: Colors.grey.shade500),
        suffixIcon: widget.isPassword
            ? IconButton(onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        }, icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey.shade500,
        ),
          )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade500,
        ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade500,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
