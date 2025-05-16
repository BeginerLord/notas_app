import 'package:flutter/material.dart';
import 'package:notas_academicas/src/styles.dart';


class FormHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const FormHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.titleStyle.copyWith(
            color: AppStyles.primaryColor, // Título en azul para destacar
          ),
        ),
        const SizedBox(height: AppStyles.paddingSmall),
        Text(
          subtitle,
          style: AppStyles.subtitleStyle.copyWith(
            color: AppStyles.hintColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: AppStyles.paddingLarge),
      ],
    );
  }
}
