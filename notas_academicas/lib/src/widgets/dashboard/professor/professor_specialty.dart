import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

class ProfessorSpecialtyDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String? initialValue;

  const ProfessorSpecialtyDropdown({
    super.key,
    required this.controller,
    this.initialValue,
  });

  // Lista de especialidades predefinidas
  static const List<String> specialties = [
    'MATEMATICAS',
    'LENGUA Y LITERATURA',
    'INGLES',
    'CIENCIAS NATURALES',
    'BIOLOGIA',
    'FISICA',
    'QUIMICA',
    'HISTORIA',
    'GEOGRAFIA',
    'CIENCIAS SOCIALES',
    'EDUCACIÓN FISICA',
    'ARTES',
    'MUSICA',
    'INFORMÁTICA',
    'TECNOLOGIA',
    'FILOSOFIA',
    'ETICA Y VALORES',
  ];

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador con el valor inicial si está definido
    if (initialValue != null &&
        initialValue!.isNotEmpty &&
        controller.text.isEmpty) {
      controller.text = initialValue!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        decoration: const InputDecoration(
          labelText: 'Especialidad',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: InputBorder.none,
        ),
        items:
            specialties.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona una especialidad';
          }
          return null;
        },
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: AppStyles.navyBlue),
        isExpanded: true,
      ),
    );
  }
}
