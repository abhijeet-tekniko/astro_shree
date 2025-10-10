import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/all_charts_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/planetary_position_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../kundli_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KundliChartTab extends StatelessWidget {
  final KundliData data;

  const KundliChartTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final charts = data.charts;

    if (charts == null) {
      return const Center(
        child: Text("No Charts Data Found"),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'Lagna'),
              Tab(text: 'Navamsa'),
              Tab(text: 'Divisional'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child:
                      D1ChartPage(d1Data: charts.d1, data: data, chart: charts),
                ),
                SingleChildScrollView(
                  child:
                      D9ChartPage(d9Data: charts.d9, data: data, chart: charts),
                ),
                AllChartsTab(charts: data.charts!)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class D1ChartPage extends StatelessWidget {
  final Charts chart;
  final KundliData data;
  final List<Chalit> d1Data;

  const D1ChartPage(
      {super.key,
      required this.d1Data,
      required this.data,
      required this.chart});

  @override
  Widget build(BuildContext context) {
    if (d1Data.isEmpty) {
      return const Center(child: Text("No D1 Chart Data Found"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'D1 Chart (Lagna Kundli)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SvgPicture.string(
          chart.d1Image.svg,
          height: 300,
          width: 300,
          color: Colors.red.shade500,
        ),
        const SizedBox(height: 16),
        if (data.planetaryPositions != null &&
            data.planetaryPositions!.isNotEmpty)
          PlanetaryTableView(positions: data.planetaryPositions!)
        else
          const Text("No planetary data available."),
      ]),
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

class D9ChartPage extends StatelessWidget {
  final Charts chart;
  final KundliData data;
  final List<Chalit> d9Data;

  const D9ChartPage(
      {super.key,
      required this.d9Data,
      required this.data,
      required this.chart});

  @override
  Widget build(BuildContext context) {
    if (d9Data.isEmpty) {
      return const Center(child: Text("No D9 Chart Data Found"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'D9 Chart (Navamsa)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SvgPicture.string(
            chart.d9Image.svg,
            height: 300,
            width: 300,
            color: Colors.red.shade500,
          ),
          const SizedBox(height: 16),
            PlanetaryTableView(positions: data.planetaryPositions!)
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
