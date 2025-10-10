import 'package:flutter/material.dart';
import '../kundli_model.dart';

class DashaTablesTab extends StatelessWidget {
  final Dasha dasha;

  const DashaTablesTab({super.key, required this.dasha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vimshottari',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            VimshottariTable(vimshottari: dasha.vimshottari),
            const SizedBox(height: 10),
            const Text('Char Dasha',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            CharTable(char: dasha.char),
            const SizedBox(height: 10),
            const Text('Yogini Dasha',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            YoginiTable(yogini: dasha.yogini),
          ],
        ),
      ),
    );
  }
}

class VimshottariTable extends StatelessWidget {
  final Vimshottari? vimshottari;

  const VimshottariTable({Key? key, this.vimshottari}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = vimshottari?.current;
    if (current == null) return const Text('No Vimshottari data');

    final data = [
      ['Major', current.major],
      ['Minor', current.minor],
      ['Sub Minor', current.subMinor],
      ['Sub Sub Minor', current.subSubMinor],
      ['Sub Sub Sub Minor', current.subSubSubMinor],
    ].where((e) => e[1] != null).toList();

    return _buildTableCard(
      title: 'Vimshottari Dasha',
      headers: ['Planet', 'Start', 'End'],
      rows: data.map((e) {
        final major = e[1] as Major;
        return [
          major.planet,
          major.start.split(" ").first,
          major.end.split(" ").first,
        ];
      }).toList(),
    );
  }
}

class CharTable extends StatelessWidget {
  final Char? char;

  const CharTable({Key? key, this.char}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = char?.current;
    if (current == null) return const Text('No Char dasha data');

    final data = [
      ['Major Dasha', current.majorDasha],
      ['Sub Dasha', current.subDasha],
      ['Sub-Sub Dasha', current.subSubDasha],
    ].where((e) => e[1] != null).toList();

    return _buildTableCard(
      title: 'Char Dasha',
      headers: [/*'Type',*/ 'Sign', /*'Duration',*/ 'Start', 'End'],
      rows: data.map((e) {
        final d = e[1] as PurpleDasha;
        return [
          // e[0] as String,
          d.signName?.name ?? '',
          // d.duration ?? '',
          d.startDate,
          d.endDate,
        ];
      }).toList(),
    );
  }
}

class YoginiTable extends StatelessWidget {
  final Yogini? yogini;

  const YoginiTable({Key? key, this.yogini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = yogini?.current;
    if (current == null) return const Text('No Yogini dasha data');

    final data = [
      ['Major Dasha', current.majorDasha],
      ['Sub Dasha', current.subDasha],
      ['Sub-Sub Dasha', current.subSubDasha],
    ].where((e) => e[1] != null).toList();

    return _buildTableCard(
      title: 'Yogini Dasha',
      headers: [/*'Type', */ 'Planet', /*'Duration',*/ 'Start', 'End'],
      rows: data.map((e) {
        final d = e[1] as FluffyDasha;
        return [
          // e[0] as String,
          d.dashaName,
          // d.duration ?? '',
          d.startDate.split(" ").first,
          d.endDate.split(" ").first,
        ];
      }).toList(),
    );
  }
}

Widget _buildTableCard({
  required String title,
  required List<String> headers,
  required List<List<String>> rows,
}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Table(
          defaultColumnWidth: const FlexColumnWidth(),
          border: TableBorder.all(color: Colors.black12),
          children: [
            _buildCustomTableRow(
              headers,
              isHeader: true,
              backgroundColor: Colors.red[100],
            ),
            ...rows.asMap().entries.map((entry) {
              final isEven = entry.key % 2 == 0;
              return _buildCustomTableRow(
                entry.value,
                backgroundColor: isEven ? Colors.red[50] : Colors.white,
              );
            }),
          ],
        ),
      ],
    ),
  );
}

TableRow _buildCustomTableRow(List<String> cells,
    {bool isHeader = false, Color? backgroundColor}) {
  return TableRow(
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
    ),
    children: cells.map((cell) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cell,
          style: isHeader
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              : const TextStyle(color: Colors.black87),
        ),
      );
    }).toList(),
  );
}
