import 'package:flutter/material.dart';

class AppStyles {
  // Colores globales
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color skyBlue = Color(0xFF64B5F6);
  static const Color navyBlue = Color(0xFF0D47A1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16.0,
    color: black,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: white,
  );

  // Decoración para los campos de texto
  static InputDecoration textFieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primaryBlue),
      prefixIcon: Icon(icon, color: primaryBlue),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: skyBlue, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: white,
    );
  }

  // Estilo para los botones
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: white,
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: skyBlue,
    foregroundColor: white,
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
