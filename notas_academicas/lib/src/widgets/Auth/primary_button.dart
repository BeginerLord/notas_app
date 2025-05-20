import 'package:flutter/material.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;  // Cambiado a VoidCallback? para aceptar null
  final bool isLoading;
  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.onPressed,  // Ya puede ser null
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LoginStyles.kButtonBorderRadius),
        boxShadow: isDisabled ? [] : LoginStyles.softShadow,
        gradient: LinearGradient(
          colors: isDisabled || onPressed == null
              ? [Colors.grey.shade300, Colors.grey.shade200]
              : [LoginStyles.kSoftBlue, LoginStyles.kSoftPink],
        ),
      ),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: LoginStyles.kButtonPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LoginStyles.kButtonBorderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: LoginStyles.kButtonTextSize,
                  fontWeight: FontWeight.w600,
                  color: isDisabled || onPressed == null ? Colors.grey.shade500 : Colors.white,
                ),
              ),
      ),
    );
  }
}