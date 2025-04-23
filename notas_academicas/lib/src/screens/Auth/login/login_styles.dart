import 'package:flutter/material.dart';

/// Constantes de estilo para la pantalla de login
class LoginStyles {
  // Colores
  static const Color kSoftBlue = Color(0xFFB3D8FF);
  static const Color kSoftPink = Color(0xFFFFC8DD);
  static const Color kSoftPurple = Color(0xFFCDB4DB);
  static const Color kSoftGreen = Color(0xFFBDE0FE);
  static const Color kTextColor = Color(0xFF4A4A4A);
  static const Color kErrorColor = Color(0xFFFF758F);
  
  
  // Tamaños de texto
  static const double kHeadingSize = 28.0;
  static const double kSubheadingSize = 16.0;
  static const double kButtonTextSize = 16.0;
  static const double kInputTextSize = 16.0;
  static const double kLabelTextSize = 14.0;
  
  // Paddings
  static const double kScreenPaddingLarge = 32.0;
  static const double kScreenPaddingMedium = 24.0;
  static const double kScreenPaddingSmall = 16.0;
  static const double kInputPadding = 16.0;
  static const double kButtonPadding = 16.0;
  static const double kSpacingLarge = 32.0;
  static const double kSpacingMedium = 20.0;
  static const double kSpacingSmall = 12.0;
  
  // Bordes
  static const double kBorderRadius = 12.0;
  static const double kButtonBorderRadius = 30.0;
  
  // Sombras
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
