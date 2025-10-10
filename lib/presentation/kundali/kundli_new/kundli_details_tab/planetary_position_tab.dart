import '../kundli_model.dart';
import 'package:flutter/material.dart';

class PlanetaryTableView extends StatefulWidget {
  final List<PlanetaryPosition> positions;

  const PlanetaryTableView({super.key, required this.positions});

  @override
  State<PlanetaryTableView> createState() => _PlanetaryTableViewState();
}

class _PlanetaryTableViewState extends State<PlanetaryTableView> {
  int selectedIndex = 0;

  final tabs = ['Sign View', 'Nakshatra View'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = selectedIndex == index;
              return ChoiceChip(
                label: Text(tabs[index]),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                selectedColor: Colors.red.shade300,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        selectedIndex == 0 ? _buildSignTable() : _buildNakshatraTable(),
      ],
    );
  }

  Table _buildSignTable() {
    return Table(
      border: TableBorder.all(color: Colors.black12),
      children: [
        _buildHeader(['Planet', 'Sign', 'Degree', 'House']),
        ...widget.positions.asMap().entries.map((entry) {
          final p = entry.value;
          final isEven = entry.key % 2 == 0;
          return _buildRow([
            p.name ?? '-',
            p.sign ?? '-',
            p.degree?.toStringAsFixed(2) ?? '-',
            p.house?.toString() ?? '-',
          ], isEven);
        })
      ],
    );
  }

  Table _buildNakshatraTable() {
    return Table(
      border: TableBorder.all(color: Colors.black12),
      children: [
        _buildHeader([
          'Planet',
          'House',
          'Nakshatra',
          'Nakshatra Lord',
        ]),
        ...widget.positions.asMap().entries.map((entry) {
          final p = entry.value;
          final isEven = entry.key % 2 == 0;
          return _buildRow([
            p.name ?? '-',
            p.house?.toString() ?? '-',
            p.nakshatra ?? '-',
            p.nakshatraLord ?? '-',
          ], isEven);
        })
      ],
    );
  }

  TableRow _buildHeader(List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.red[200]),
      children: cells
          .map((cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ))
          .toList(),
    );
  }

  TableRow _buildRow(List<String> cells, bool isEven) {
    return TableRow(
      decoration: BoxDecoration(color: isEven ? Colors.red[50] : Colors.white),
      children: cells
          .map((cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell),
              ))
          .toList(),
    );
  }
}
