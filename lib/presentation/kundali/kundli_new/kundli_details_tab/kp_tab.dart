import 'package:flutter/material.dart';

import '../kundli_model.dart';

class KpSystemTab extends StatelessWidget {
  final KpSystem kpSystem;

  const KpSystemTab({super.key, required this.kpSystem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'KP Planets'),
          _buildKpPlanetsTable(kpSystem.planets),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'House Cusps'),
          _buildHouseCuspsTable(kpSystem.houseCusps),
          // const SizedBox(height: 24),
          // _buildSectionTitle(context, 'House Significators'),
          // _buildHouseSignificatorTable(kpSystem.houseSignificator),
          // const SizedBox(height: 24),
          // _buildSectionTitle(context, 'Planet Significators'),
          // _buildPlanetSignificatorTable(kpSystem.planetSignificator),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  String shorten(String? input) {
    if (input == null || input.isEmpty) return '-';
    return input.length > 7 ? '${input.substring(0, 3)}.' : input;
  }

  Widget _buildKpPlanetsTable(List<KpSystemPlanet> planets) {
    return _buildTable(
      header: [
        'Planet',
        'House',
        'Sign',
        'Sign Lord',
        'Sub',
      ],
      rows: planets
          .map((p) => [
        shorten(p.planetName),
        shorten(p.house?.toString()),
        shorten(p.sign?.name),
        shorten(p.signLord),
        shorten(p.subLord),
      ])
          .toList(),
      // rows: planets
      //     .map((p) => [
      //           p.planetName ?? '-',
      //           p.house?.toString() ?? '-',
      //           p.sign?.name ?? '-',
      //           p.signLord ?? '-',
      //           p.subLord ?? '-',
      //         ])
      //     .toList(),
    );
  }

  Widget _buildHouseCuspsTable(List<HouseCusp> cusps) {
    return _buildTable(
      header: [
        'Cusps',
        'Degree',
        'Sign',
        'Sign Lord',
        'Sub',
      ],
      rows: cusps
          .map((c) => [
                c.houseId?.toString() ?? '-',
                c.formattedDegree ?? '-',
                c.sign?.name ?? '-',
                c.signLord ?? '-',
                c.subLord ?? '-',
              ])
          .toList(),
    );
  }

  Widget _buildHouseSignificatorTable(List<HouseSignificator> items) {
    return _buildTable(
      header: ['House', 'Significators'],
      rows: items
          .map((i) => [
                i.houseId?.toString() ?? '-',
                i.significators?.join(', ') ?? '-',
              ])
          .toList(),
    );
  }

  Widget _buildPlanetSignificatorTable(List<PlanetSignificator> items) {
    return _buildTable(
      header: ['Planet', 'Significator Houses'],
      rows: items
          .map((p) => [
                p.planetName ?? '-',
                p.significators?.join(', ') ?? '-',
              ])
          .toList(),
    );
  }

  Widget _buildTable({
    required List<String> header,
    required List<List<String>> rows,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.black12),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            _buildTableRow(header,
                isHeader: true, backgroundColor: Colors.red[200]),
            ...rows.asMap().entries.map((entry) {
              final row = entry.value;
              final isEven = entry.key % 2 == 0;
              return _buildTableRow(row,
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
