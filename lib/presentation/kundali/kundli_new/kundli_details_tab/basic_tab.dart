import 'package:flutter/material.dart';
import '../kundli_model.dart';

class BasicDetailsTab extends StatelessWidget {
  final KundliData data;

  const BasicDetailsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final basic = data.basicDetails;
    final astro = data.astroDetails;

    if (basic == null) {
      return const Center(child: Text("No Basic Details available."));
    }
    if (astro == null) {
      return const Center(child: Text("No Astro Details available."));
    }

    final basicDetails = [
      ["Name", basic.name],
      ["Gender", basic.gender],
      ["Date of Birth", basic.dob],
      ["Time of Birth", basic.tob],
      ["Place of Birth", basic.place],
      ["Ayanamsha", basic.ayanamsha],
      ["Sun Rise", basic.sunrise],
      ["Sunset", basic.sunset],
      ["Sun Sign", basic.sunSign],
      ["Moon Sign", basic.moonSign],
    ];

    final panchangDetails = [
      ["Tithi", astro.tithi],
      ["Karan", astro.karan],
      ["Yog", astro.varna],
      ["Nakshatra", astro.vashya],
      ["Sun Rise", astro.yoni],
      ["Sun Set", astro.yunja],
    ];

    final avakhadaDetails = [
      ["Varna", astro.varna],
      ["Vashya", astro.vashya],
      ["Gan", astro.gan],
      ["Yoni", astro.yoni],
      ["Nadi", astro.nadi],
      ["Paya", astro.paya],
      ["Tatva", astro.tatva],
      ["Yunja", astro.yunja],
      ["Name Alphabet", astro.nameAlphabet],
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listWithHeader("Basic Details", basicDetails),
            listWithHeader("Panchang Details", panchangDetails),
            listWithHeader("Avakhada Details", avakhadaDetails),
          ],
        ),
      ),
    );
  }

  Widget listWithHeader(String title, List itemsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              Divider(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              Divider(),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ListView.builder(
              itemCount: itemsList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final label = itemsList[index][0];
                final value = itemsList[index][1] ?? 'N/A';
                final isEven = index % 2 == 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: isEven
                        ? Colors.red[50]?.withOpacity(0.8)
                        : Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$label: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
