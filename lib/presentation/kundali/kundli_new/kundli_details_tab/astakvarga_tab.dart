import 'package:flutter/material.dart';
import '../kundli_model.dart';

class AshtakvargaTab extends StatelessWidget {
  final Ashtakvarga data;

  const AshtakvargaTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final planetMap = {
      'Sun': data.planetAshtak?.sun,
      'Moon': data.planetAshtak?.moon,
      'Mars': data.planetAshtak?.mars,
      'Mercury': data.planetAshtak?.mercury,
      'Jupiter': data.planetAshtak?.jupiter,
      'Venus': data.planetAshtak?.venus,
      'Saturn': data.planetAshtak?.saturn,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Sarvashtak Points'),
          _buildSarvashtakTable(data.sarvashtak),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Planet-wise Ashtakvarga Points'),
          ...planetMap.entries.where((e) => e.value != null).map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text('${entry.key}',
                    style: Theme.of(context).textTheme.titleMedium),
                _buildSarvashtakTable(entry.value),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildSarvashtakTable(Sarvashtak? sarvashtak) {
    final points = sarvashtak?.ashtakPoints;
    if (points == null || points.isEmpty) {
      return const Text('No data available');
    }

    final headers = [
      'Sign',
      'Su',
      'Mo',
      'Ma',
      'Me',
      'Ju',
      'Ve',
      'Sa',
      'As',
      'Total'
    ];
    final rows = points.entries.map((entry) {
      final p = entry.value;
      return [
        entry.key, // usually the sign name (e.g., Aries)
        '${p.sun}',
        '${p.moon}',
        '${p.mars}',
        '${p.mercury}',
        '${p.jupiter}',
        '${p.venus}',
        '${p.saturn}',
        '${p.ascendant}',
        '${p.total}',
      ];
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.black12),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            _buildTableRow(headers,
                isHeader: true, backgroundColor: Colors.red[200]),
            ...rows.asMap().entries.map((entry) {
              final isEven = entry.key % 2 == 0;
              return _buildTableRow(entry.value,
                  backgroundColor: isEven ? Colors.red[50] : Colors.white);
            }),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, Color? backgroundColor}) {
    return TableRow(
      decoration: BoxDecoration(color: backgroundColor ?? Colors.transparent),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }
}
