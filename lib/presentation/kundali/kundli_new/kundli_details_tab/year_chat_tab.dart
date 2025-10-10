import 'package:flutter/material.dart';
import '../kundli_model.dart';

class YearChartTab extends StatelessWidget {
  final KundliData data;

  const YearChartTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final yearChart = data.varshaphal?.yearChart;

    if (yearChart == null || yearChart.chart == null || yearChart.chart!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No Year Chart data available.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    final chartData = yearChart.chart!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (yearChart.yearLord != null)
            Text("Year Lord: ${yearChart.yearLord!}",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (yearChart.varshaphalDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 4),
              child: Text("Varshaphal Date: ${yearChart.varshaphalDate!}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final detail = index < chartData.length ? chartData[index] : null;
                final signName = detail?.signName ?? "—";
                final planets = detail?.planetSmall ?? detail?.planet ?? [];
                final degrees = detail?.planetDegree ?? [];

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("House ${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(height: 4),
                      Text("Sign: $signName",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      if (planets.isNotEmpty)
                        ...List.generate(planets.length, (i) {
                          final planet = planets[i];
                          final degree = i < degrees.length ? degrees[i]?.toString() : null;
                          return Text(
                            degree != null ? "$planet ($degree°)" : planet,
                            style: const TextStyle(fontSize: 12),
                          );
                        })
                      else
                        const Text("No planets", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
