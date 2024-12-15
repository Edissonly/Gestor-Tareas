import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskChart extends StatelessWidget {
  final int completed;
  final int deleted;
  final int total;

  const TaskChart({
    super.key,
    required this.completed,
    required this.deleted,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Total de Tareas: $total',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: completed.toDouble(),
                  title: '$completed Completadas',
                  color: Colors.green,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  value: deleted.toDouble(),
                  title: '$deleted Eliminadas',
                  color: Colors.red,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  value: (total - completed - deleted).toDouble(),
                  title: '${total - completed - deleted} Pendientes',
                  color: Colors.blue,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              centerSpaceRadius: 50,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }
}
