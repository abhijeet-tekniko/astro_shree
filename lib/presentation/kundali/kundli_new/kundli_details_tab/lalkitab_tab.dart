import 'package:flutter/material.dart';
import '../kundli_model.dart';

class LalkitabTab extends StatelessWidget {
  final KundliData data;

  const LalkitabTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lalkitab = data.lalkitab;
    final horoscopeList = lalkitab?.horoscope;
    final debtList = lalkitab?.debts;
    final houseList = lalkitab?.houses;
    final planetList = lalkitab?.planets;
    final remedies = lalkitab?.remedies;

    if ((horoscopeList == null || horoscopeList.isEmpty) &&
        (debtList == null || debtList.isEmpty) &&
        (houseList == null || houseList.isEmpty) &&
        (planetList == null || planetList.isEmpty) &&
        remedies == null) {
      return const Center(
        child: Text("No Lalkitab data available."),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Horoscope
          /// Horoscope
          if (horoscopeList != null && horoscopeList.isNotEmpty)
            _buildSection(
              title: "Horoscope",
              children: horoscopeList.map((item) {
                final hasPlanets =
                    item.planet != null && item.planet!.isNotEmpty;
                final hasDegrees =
                    item.planetDegree != null && item.planetDegree!.isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign: ${item.signName ?? 'Unknown'}",
                          style:
                              _subHeaderStyle.copyWith(color: Colors.red[700]),
                        ),
                        const SizedBox(height: 8),
                        if (hasPlanets)
                          _buildKeyValueRow("Planets", item.planet!.join(', ')),
                        if (hasDegrees)
                          _buildKeyValueRow(
                              "Degrees", item.planetDegree!.join(', ')),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          /// Debts
          if (debtList != null && debtList.isNotEmpty)
            _buildSection(
              title: "Debts",
              children: debtList
                  .map((debt) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: _boxDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${debt.debtName ?? '-'}",
                                style: _subHeaderStyle),
                            if (debt.indications != null)
                              _buildBullet("Indications: ${debt.indications!}"),
                            if (debt.events != null)
                              _buildBullet("Events: ${debt.events!}"),
                          ],
                        ),
                      ))
                  .toList(),
            ),

          /// Lalkitab Houses - as a Table
          if (houseList != null && houseList.isNotEmpty)
            _buildSection(
              title: "Lalkitab Houses",
              children: [
                _buildTable(
                  context,
                  columns: [
                    'House',
                    'Maalik',
                    'Pakka Ghar',
                    'Kismat',
                    'Soya',
                    'Exalt',
                    'Debilitated'
                  ],
                  rows: houseList.map((house) {
                    return [
                      house.khanaNumber?.toString() ?? '-',
                      house.maalik ?? '-',
                      house.pakkaGhar ?? '-',
                      house.kismat ?? '-',
                      house.soya == true ? 'Yes' : 'No',
                      (house.exalt?.isEmpty ?? true)
                          ? '-'
                          : house.exalt!.join(', '),
                      (house.debilitated?.isEmpty ?? true)
                          ? '-'
                          : house.debilitated!.join(', '),
                    ];
                  }).toList(),
                ),
              ],
            ),

          /// Lalkitab Planets - as a Table
          if (planetList != null && planetList.isNotEmpty)
            _buildSection(
              title: "Lalkitab Planets",
              children: [
                _buildTable(
                  context,
                  columns: ['Planet', 'Rashi', 'Soya', 'Position', 'Nature'],
                  rows: planetList.map((planet) {
                    return [
                      planet.planet ?? '-',
                      planet.rashi ?? '-',
                      planet.soya == true ? 'Yes' : 'No',
                      planet.position ?? '-',
                      planet.nature ?? '-',
                    ];
                  }).toList(),
                ),
              ],
            ),

          /// Remedies
          if (remedies != null)
            _buildSection(
              title: "Remedies",
              children: _planetRemedyMap(remedies).entries.map((entry) {
                final remedy = entry.value;
                if (remedy == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: _boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: _subHeaderStyle),
                      const SizedBox(height: 4),
                      _buildBullet(
                          "Remedy: ${remedy.lalKitabDesc ?? 'No description'}"),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Table Builder
  Widget _buildTable(BuildContext context,
      {required List<String> columns, required List<List<String>> rows}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(color: Colors.black12),
          children: [
            _buildTableRow(columns,
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

  /// Table Row Builder
  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, Color? backgroundColor}) {
    return TableRow(
      decoration: BoxDecoration(color: backgroundColor ?? Colors.transparent),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: isHeader
                ? const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)
                : const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
    );
  }

  /// Section Wrapper
  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: _headerStyle),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// Convert Remedies object to map
  Map<String, LalKitabRemedy?> _planetRemedyMap(Remedies r) {
    return {
      'Sun': r.sun,
      'Moon': r.moon,
      'Mars': r.mars,
      'Mercury': r.mercury,
      'Jupiter': r.jupiter,
      'Venus': r.venus,
      'Saturn': r.saturn,
    };
  }

  /// Bullet Builder
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          Expanded(
              child: Text(text, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$key: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const _subHeaderStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
final _boxDecoration = BoxDecoration(
  color: Colors.red.shade50,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.red.shade100),
);
