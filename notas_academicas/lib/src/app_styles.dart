import 'package:flutter/material.dart';

class AppStyles {
  // Colores globales
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color skyBlue = Color(0xFF64B5F6);
  static const Color navyBlue = Color(0xFF0D47A1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF757575);
  static const Color darkBlue = Color(0xFF003366);


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
static const TextStyle dashboardTitleStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static const TextStyle dashboardSubtitleStyle = TextStyle(
    fontSize: 14.0,
    color: darkGrey,
  );

  static const TextStyle sidebarItemStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: black,
  );

  static const TextStyle sidebarSelectedItemStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
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
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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

  // Decoración para tarjetas del dashboard
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withAlpha((0.2 * 255).toInt()),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );

}
