import 'package:flutter/material.dart';

class AppStyles {
  // Colores actualizados
  static const Color primaryColor = Color(0xFF1E88E5); // Azul brillante y accesible
  static const Color secondaryColor = Color(0xFF64B5F6); // Azul más claro para acentos
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color backgroundColor = Colors.white; // Blanco para fondos
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Color(0xFF9E9E9E);
  static const Color lightBlue = Color(0xFFE3F2FD); // Azul muy claro para fondos secundarios

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryColor, // Etiquetas en azul para destacar
  );

  static const TextStyle hintStyle = TextStyle(
    fontSize: 14,
    color: hintColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Decoraciones
  static InputDecoration inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Espaciado
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Bordes
  static BorderRadius borderRadius = BorderRadius.circular(8);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(16);

  // Sombras
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha((0.1 * 255).toInt()),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Botones
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius,
    ),
    elevation: 2,
  );
}
