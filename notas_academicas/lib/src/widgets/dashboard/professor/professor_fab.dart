import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

class TeachersFAB extends StatelessWidget {
  final VoidCallback onAdd;

  const TeachersFAB({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: onAdd,
        backgroundColor: AppStyles.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
