import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

class DataTableWidget extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>)? onRowTap;

  const DataTableWidget({
    super.key,
    required this.title,
    required this.columns,
    required this.data,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyles.dashboardTitleStyle,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implementar acción de agregar
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryBlue,
                  foregroundColor: AppStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppStyles.lightGrey),
              dataRowColor: WidgetStateProperty.all(AppStyles.white),
              columns: columns
                  .map(
                    (column) => DataColumn(
                      label: Text(
                        column,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: data
                  .map(
                    (row) => DataRow(
                      cells: columns
                          .map(
                            (column) => DataCell(
                              Text(row[column]?.toString() ?? ''),
                            ),
                          )
                          .toList(),
                      onSelectChanged: (selected) {
                        if (selected == true && onRowTap != null) {
                          onRowTap!(row);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Implementar paginación
                },
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    color: AppStyles.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
