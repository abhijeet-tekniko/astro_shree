import 'package:flutter/material.dart';
import '../kundli_model.dart';

class AstroDetailsTab extends StatelessWidget {
  final KundliData data;

  const AstroDetailsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final astro = data.astroDetails;

    if (astro == null) {
      return const Center(child: Text("No Astro Details available."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          buildRow("Sign", astro.sign),
          buildRow("Sign Lord", astro.signLord),
          buildRow("Ascendant", astro.ascendant),
          buildRow("Ascendant Lord", astro.ascendantLord),
          buildRow("Nakshatra", astro.naksahtra),
          buildRow("Nakshatra Lord", astro.naksahtraLord),
          buildRow("Charan", astro.charan?.toString()),
          buildRow("Yog", astro.yog),
          buildRow("Karan", astro.karan),
          buildRow("Tithi", astro.tithi),
          buildRow("Varna", astro.varna),
          buildRow("Vashya", astro.vashya),
          buildRow("Yoni", astro.yoni),
          buildRow("Yunja", astro.yunja),
          buildRow("Gan", astro.gan),
          buildRow("Nadi", astro.nadi),
          buildRow("Paya", astro.paya),
          buildRow("Tatva", astro.tatva),
          buildRow("Name Alphabet", astro.nameAlphabet),
        ],
      ),
    );
  }

  Widget buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700]),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
