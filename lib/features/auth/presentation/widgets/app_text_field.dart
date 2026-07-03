import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final TextInputType type;
  final bool obscure;
  final bool isRequired;
  final Widget? suffix;
  final Widget? prefix;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.hint,
    required this.type,
    this.obscure = false,
    this.isRequired = true,
    this.suffix,
    this.prefix,
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    this.controller,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscure,
      keyboardType: widget.type,
      style: AppFonts.font(fontSize: 14, color: widget.textColor),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppFonts.font(fontSize: 14, color: Pallete.textHint),
        filled: true,
        fillColor: widget.fillColor.withAlpha(50),
        suffixIcon: widget.suffix,
        prefixIcon: widget.prefix,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Pallete.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Pallete.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Pallete.error,
            width: 1.5,
          ),
        ),
      ),
      validator: widget.validator ??
          (widget.isRequired
              ? (v) => (v == null || v.isEmpty) ? 'Required' : null
              : null),
    );
  }
}
