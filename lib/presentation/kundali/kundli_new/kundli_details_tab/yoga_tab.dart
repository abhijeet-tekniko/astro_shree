import 'package:flutter/material.dart';
import '../kundli_model.dart';

class YogaTab extends StatelessWidget {
  final KundliData data;

  const YogaTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final yogaList = data.varshaphal?.yoga;

    if (yogaList == null || yogaList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No Yoga data available.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: yogaList.length,
      itemBuilder: (context, index) {
        final yoga = yogaList[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              yoga.yogName ?? 'Yoga ${index + 1}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: yoga.isYogHappening == true
                ? const Text("Yoga is active", style: TextStyle(color: Colors.green))
                : const Text("Yoga is not active", style: TextStyle(color: Colors.red)),
            children: [
              if (yoga.powerfullnessPercentage != null)
                _infoRow("Powerfulness", "${yoga.powerfullnessPercentage}%"),

              if (yoga.yogDescription != null)
                _infoRow("Description", yoga.yogDescription!),

              if (yoga.yogPrediction != null)
                _infoRow("Prediction", yoga.yogPrediction!),

              if (yoga.planets != null && yoga.planets!.isNotEmpty)
                _infoRow("Planets", _formatPlanets(yoga.planets!)),

              if (yoga.yogType != null && yoga.yogType!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text("Yoga Types:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                ...yoga.yogType!.map((type) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("- ${type.yogName ?? 'Unnamed'}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (type.planets != null && type.planets!.isNotEmpty)
                        Text("   Planets: ${type.planets!.join(', ')}"),
                    ],
                  ),
                )),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$title: ",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPlanets(List<dynamic> planets) {
    return planets.map((e) {
      if (e is String) return e;
      if (e is List) return e.whereType<String>().join(' + ');
      return e.toString();
    }).join(', ');
  }
}