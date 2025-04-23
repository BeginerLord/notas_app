import 'package:flutter/material.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_styles.dart';



class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final String? errorText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged, this.suffixIcon,
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
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: LoginStyles.kInputTextSize,
              color: LoginStyles.kTextColor,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: hasError
                    ? LoginStyles.kErrorColor
                    : LoginStyles.kSoftPurple,
                fontSize: LoginStyles.kLabelTextSize,
              ),
              contentPadding: const EdgeInsets.all(LoginStyles.kInputPadding),
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: suffixIcon, // Usa el ícono personalizado si se proporciona
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
