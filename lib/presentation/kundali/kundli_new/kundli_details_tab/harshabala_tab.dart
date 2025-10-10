import 'package:flutter/material.dart';
import '../kundli_model.dart';

class HarshaBalaTab extends StatelessWidget {
  final KundliData data;

  const HarshaBalaTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final harshaBala = data.varshaphal?.harshaBala;

    if (harshaBala == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No Harsha Bala data available.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    final planets = [
      "Sun",
      "Moon",
      "Mars",
      "Mercury",
      "Jupiter",
      "Venus",
      "Saturn",
      "Rahu",
      "Ketu",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Harsha Bala", style: _headerStyle),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.red.shade200),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.5),
              5: FlexColumnWidth(1.5),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFFFFE5E5)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Planet",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Sthana",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Uccha",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Gender",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Din/Ratri",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Total",
                        style: _tableHeaderStyle, textAlign: TextAlign.center),
                  ),
                ],
              ),
              for (int i = 0; i < planets.length; i++)
                TableRow(
                  decoration: BoxDecoration(color: Colors.red.shade100),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Total", textAlign: TextAlign.center, style: _tableHeaderStyle),
                    ),
                    _totalCell(harshaBala.sthanaBala),
                    _totalCell(harshaBala.ucchaswachetriBala),
                    _totalCell(harshaBala.genderBala),
                    _totalCell(harshaBala.dinratriBala),
                    _totalCell(harshaBala.totalBala),
                  ],
                ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _totalCell(List<int>? list) {
    final total = (list ?? []).fold<int>(0, (sum, e) => sum + e);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text("$total", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

  const _headerStyle =
TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red);
const _tableHeaderStyle =
TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
