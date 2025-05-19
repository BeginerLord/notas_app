import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use a more compact layout
    return Container(
      decoration: AppStyles.cardDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Minimize vertical space
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.dashboardSubtitleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5), // Smaller padding
                decoration: BoxDecoration(
                  color: color.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20, // Smaller icon
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Reduced spacing
          Text(
            value,
            style: AppStyles.titleStyle.copyWith(
              fontSize: 24, // Smaller font
            ),
          ),
          const SizedBox(height: 4), // Reduced spacing
          // Wrap this row in a FittedBox to handle long text
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                  size: 14, // Smaller icon
                ),
                const SizedBox(width: 4),
                Text(
                  '5.27%',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13, // Smaller font
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'desde el mes pasado',
                  style: TextStyle(
                    color: AppStyles.darkGrey,
                    fontSize: 11, // Smaller font
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}