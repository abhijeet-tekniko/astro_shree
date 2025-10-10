import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../kundli_model.dart';

class AllChartsTab extends StatefulWidget {
  final Charts charts;

  const AllChartsTab({super.key, required this.charts});

  @override
  State<AllChartsTab> createState() => _AllChartsTabState();
}

class _AllChartsTabState extends State<AllChartsTab> {
  late final List<_ChartEntry> _chartEntries;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _chartEntries = [
      // _ChartEntry('Chalit 1', widget.charts.chalitImage),
      // _ChartEntry('Chalit 2', widget.charts.chalitImage),
      _ChartEntry('Sun', widget.charts.imageSun),
      _ChartEntry('Sun', widget.charts.sunImage),
      _ChartEntry('Moon', widget.charts.imageMoon),
      _ChartEntry('Moon', widget.charts.moonImage),
      _ChartEntry('Hora (D2)', widget.charts.imageD2),
      _ChartEntry('Hora (D2)', widget.charts.d2Image),
      _ChartEntry('Drekkana (D3)', widget.charts.imageD3),
      _ChartEntry('Drekkana (D3)', widget.charts.d3Image),
      _ChartEntry('Chaturthamasa (D4)', widget.charts.imageD4),
      _ChartEntry('Chaturthamasa (D4)', widget.charts.d4Image),
      _ChartEntry('Saptamasa (D7)', widget.charts.imageD7),
      _ChartEntry('Saptamasa (D7)', widget.charts.d7Image),
      _ChartEntry('Dasama (D10)', widget.charts.imageD10),
      _ChartEntry('Dasama (D10)', widget.charts.d10Image),
      _ChartEntry('Dwadasama (D12)', widget.charts.imageD12),
      _ChartEntry('Dwadasama (D12)', widget.charts.d12Image),
      _ChartEntry('Shodasamsa (D16)', widget.charts.imageD16),
      _ChartEntry('Shodasamsa (D16)', widget.charts.d16Image),
      _ChartEntry('Vimsamsa (D20)', widget.charts.imageD20),
      _ChartEntry('Vimsamsa (D20)', widget.charts.d20Image),
      _ChartEntry('Trimamsa (D30)', widget.charts.imageD30),
      _ChartEntry('Trimamsa (D30)', widget.charts.d30Image),
      _ChartEntry('Khavedamsa (D40)', widget.charts.imageD40),
      _ChartEntry('Khavedamsa (D40)', widget.charts.d40Image),
      _ChartEntry('Akshavedamsa (D45)', widget.charts.imageD45),
      _ChartEntry('Akshavedamsa (D45)', widget.charts.d45Image),
      _ChartEntry('Shastiamsa (D60)', widget.charts.imageD60),
      _ChartEntry('Shastiamsa (D60)', widget.charts.d60Image),
    ].where((e) => e.image.svg.isNotEmpty).toList(); // Filter out empty images
  }

  @override
  Widget build(BuildContext context) {
    final selectedChart = _chartEntries[_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Horizontal Chips Scroll
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _chartEntries.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return ChoiceChip(
                  label: Text(_chartEntries[index].label),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selectedColor: Colors.red.shade300,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Chart Viewer
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      selectedChart.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SvgPicture.string(
                      selectedChart.image.svg,
                      placeholderBuilder: (context) =>
                          const CircularProgressIndicator(),
                      color: Colors.red.shade500,
                      height: 300,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartEntry {
  final String label;
  final D10Image image;

  _ChartEntry(this.label, this.image);
}
