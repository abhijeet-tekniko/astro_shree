import 'package:flutter/material.dart';
import '../kundli_model.dart';

class ReportsTab extends StatelessWidget {
  final Reports? reports;
  final Remedies? remedies;
  final Dosha? dosha;

  const ReportsTab({super.key, this.reports, this.remedies, this.dosha});

  @override
  Widget build(BuildContext context) {
    if (reports == null || remedies == null || dosha == null) {
      return const Center(child: Text("No Data Found"));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 0,
          leading: SizedBox(
            height: 0,
            width: 0,
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 30,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            tabs: [
              Tab(text: "Reports"),
              Tab(text: "Remedies"),
              Tab(text: "Dosha"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportTab(reports!),
            _buildRemediesTab(remedies!),
            _buildDoshaTab(dosha!),
          ],
        ),
      ),
    );
  }

  // Reports Tab Content
  Widget _buildReportTab(Reports reports) {
    final house = reports.house;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (reports.ascendant != null)
            _buildAscendantCard(reports.ascendant!),
          if (house != null) ..._buildHouseCards(house),
          if (reports.planet != null)
            const Card(
                child:
                    ListTile(title: Text("Planet report present (not shown)"))),
          if (reports.natalChartInterpretation != null)
            const Card(
                child: ListTile(
                    title: Text(
                        "Natal chart interpretation present (not shown)"))),
        ],
      ),
    );
  }

  Widget _buildAscendantCard(AscendantClass ascendant) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: const Text(
          'Ascendant',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign: ${ascendant.sign?.name ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Characteristics: ${ascendant.characteristics}'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHouseCards(ReportsHouse house) {
    final planets = {
      'Sun': house.sun,
      'Moon': house.moon,
      'Mars': house.mars,
      'Mercury': house.mercury,
      'Jupiter': house.jupiter,
      'Venus': house.venus,
      'Saturn': house.saturn,
    };

    return planets.entries
        .where((entry) => entry.value != null)
        .map((entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  '${entry.key} House',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                ),
                subtitle: Text(entry.value!.houseReport),
              ),
            ))
        .toList();
  }

  // Remedies Tab Content
  Widget _buildRemediesTab(Remedies remedies) {
    final allRemedies = {
      'Sun': remedies.sun,
      'Moon': remedies.moon,
      'Mars': remedies.mars,
      'Mercury': remedies.mercury,
      'Jupiter': remedies.jupiter,
      'Venus': remedies.venus,
      'Saturn': remedies.saturn,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: allRemedies.entries
            .where((entry) => entry.value != null)
            .map((entry) {
          final remedy = entry.value!;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                entry.key,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('House: ${remedy.house ?? 'N/A'}'),
                  const SizedBox(height: 4),
                  Text(
                      'Description: ${remedy.lalKitabDesc ?? 'No description'}'),
                  const SizedBox(height: 8),
                  if (remedy.lalKitabRemedies != null)
                    ...remedy.lalKitabRemedies!
                        .map((r) => Text('• $r'))
                        .toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Dosha Tab Content
  Widget _buildDoshaTab(Dosha dosha) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dosha.kalsarpa != null)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text(
                  "Kalsarpa Dosha",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${dosha.kalsarpa!.name}'),
                    Text('Type: ${dosha.kalsarpa!.type}'),
                    Text('Present: ${dosha.kalsarpa!.present ? "Yes" : "No"}'),
                    const SizedBox(height: 4),
                    Text('Summary: ${dosha.kalsarpa!.oneLine}'),
                    const SizedBox(height: 4),
                    if (dosha.kalsarpa!.report != null)
                      Text('Report: ${dosha.kalsarpa!.report!.report}'),
                  ],
                ),
              ),
            ),
          if (dosha.manglik != null)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text(
                  "Manglik Dosha",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${dosha.manglik!.manglikStatus}'),
                    Text(
                        'Is Present: ${dosha.manglik!.isPresent ? "Yes" : "No"}'),
                    Text('Report: ${dosha.manglik!.manglikReport}'),
                  ],
                ),
              ),
            ),
          if (dosha.pitraDosha != null)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text(
                  "Pitra Dosha",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Present: ${dosha.pitraDosha!.isPitriDoshaPresent ? "Yes" : "No"}'),
                    Text('Details: ${dosha.pitraDosha!.whatIsPitriDosha}'),
                    Text('Conclusion: ${dosha.pitraDosha!.conclusion}'),
                  ],
                ),
              ),
            ),
          if (dosha.sadhesati != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sade Sati Periods',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Table(
                    defaultColumnWidth: const FlexColumnWidth(),
                    border: TableBorder.all(color: Colors.black12),
                    children: [
                      _buildTableRow(
                        [
                          'Date',
                          'Type',
                          'Moon Sign',
                          'Saturn Sign',
                        ],
                        isHeader: true,
                        backgroundColor: Colors.red[100],
                      ),
                      ...dosha.sadhesati!.lifeDetails
                          .asMap()
                          .entries
                          .map((entry) {
                        final item = entry.value;
                        final isEven = entry.key % 2 == 0;
                        return _buildTableRow([
                          item.date,
                          "${item.type?.name.split("_").first} ${item.type?.name.split("_").last}" ??
                              '-',
                          item.moonSign?.name ?? '-',
                          item.saturnSign?.name ?? '-',
                        ],
                            backgroundColor:
                                isEven ? Colors.red[50] : Colors.white);
                      }),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells,
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
}
