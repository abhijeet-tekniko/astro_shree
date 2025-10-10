import 'package:flutter/material.dart';
import '../kundli_model.dart';

class MonthChartTab extends StatelessWidget {
  final KundliData kundliData;

  const MonthChartTab({super.key, required this.kundliData});

  @override
  Widget build(BuildContext context) {
    final monthCharts = kundliData.varshaphal?.monthChart ?? [];

    if (monthCharts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No month charts available",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: monthCharts.length,
      itemBuilder: (context, index) {
        final month = monthCharts[index];
        final chart = month.chart ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Month ${month.monthId ?? index + 1}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: chart
                  .map((house) => ChartBox(chartDetails: house))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class ChartBox extends StatelessWidget {
  final ChartDetails chartDetails;

  const ChartBox({super.key, required this.chartDetails});

  @override
  Widget build(BuildContext context) {
    final planets = chartDetails.planet ?? [];
    final planetSmalls = chartDetails.planetSmall ?? [];
    final degrees = chartDetails.planetDegree ?? [];

    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign ${chartDetails.sign ?? '-'}: ${chartDetails.signName ?? '—'}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < planets.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(planets[i], style: const TextStyle(fontSize: 13))),
                    Text(
                      planetSmalls.length > i ? planetSmalls[i] : '',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      degrees.length > i ? ' (${degrees[i]}°)' : '',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
                const Divider(height: 8),
              ],
            ),
          if (planets.isEmpty)
            const Text("No planets", style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
