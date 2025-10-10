import 'package:flutter/material.dart';
import '../kundli_model.dart';

class SahamTab extends StatelessWidget {
  final KundliData data;

  const SahamTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sahamPoints = data.varshaphal?.sahamPoints;

    if (sahamPoints == null || sahamPoints.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No Saham Points available.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Saham Points", style: _headerStyle),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.red.shade200),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFFFFE5E5)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Name", style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Degree", style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                ],
              ),
              for (final saham in sahamPoints)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(saham.sahamName ?? '-', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        saham.sahamDegree?.toStringAsFixed(2) ?? '-',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red);
const _tableHeaderStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
