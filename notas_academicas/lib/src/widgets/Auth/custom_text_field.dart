import 'package:flutter/material.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint; 
  final bool isPassword;
  final bool isPasswordVisible;
  final String? errorText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // Add the validator parameter
  final VoidCallback? onTogglePasswordVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
    this.validator, // Initialize the validator parameter
    this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(LoginStyles.kBorderRadius),
            boxShadow: LoginStyles.softShadow,
            border: hasError 
                ? Border.all(color: LoginStyles.kErrorColor, width: 1.5)
                : null,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: LoginStyles.kInputTextSize,
              color: LoginStyles.kTextColor,
            ),
            onChanged: onChanged,
            validator: validator, // Use the validator parameter
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: TextStyle(
                color: hasError
                    ? LoginStyles.kErrorColor
                    : LoginStyles.kSoftPurple,
                fontSize: LoginStyles.kLabelTextSize,
              ),
              contentPadding: const EdgeInsets.all(LoginStyles.kInputPadding),
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: isPassword 
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: onTogglePasswordVisibility,
                    )
                  : suffixIcon,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0, 
              left: LoginStyles.kInputPadding / 2,
            ),
            child: Text(
              errorText!,
              style: TextStyle(
                color: LoginStyles.kErrorColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}