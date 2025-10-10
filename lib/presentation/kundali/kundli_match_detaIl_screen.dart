
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/kundali_matching_controller.dart';
import '../../data/model/kundali_matching_model.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

class KundaliMatchingHome extends StatefulWidget {
  const KundaliMatchingHome({super.key});

  @override
  State<KundaliMatchingHome> createState() => _KundaliMatchingHomeState();
}

class _KundaliMatchingHomeState extends State<KundaliMatchingHome> {
  final kundaliMatchController = Get.put(KundaliMatchingController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      if (kundaliMatchController.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.red));
      }
      if (kundaliMatchController.kundliMatching.value?.data == null) {
        return const Center(child: Text("No Data"));
      }
      final data = kundaliMatchController.kundliMatching.value?.data;
      return DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: CustomNavigationButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
            title: AppbarTitle(
              text: 'Kundli Matching',
              margin: EdgeInsets.only(left: 5),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: Colors.red,
                indicatorWeight: 5,
                dividerColor: Colors.red,
                tabAlignment: TabAlignment.center,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.red),
                      )),
                  Tab(
                      child: Text(
                        'Guna Milan',
                        style: TextStyle(color: Colors.red),
                      )),
                  Tab(
                      child: Text(
                        'Dosha Analysis',
                        style: TextStyle(color: Colors.red),
                      )),
                  Tab(
                      child: Text(
                        'Charts',
                        style: TextStyle(color: Colors.red),
                      )),
                  // Tab(text: 'Charts'),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.8,
                child: TabBarView(
                  children: [
                    DetailsTab(data: data!),
                    GunaMilanTab(
                        gunaData: data.matchResult.gunaMilan,
                        data: data.matchResult.compatibility,
                        remedies: data.matchResult.remedies),
                    DoshaAnalysisTab(data: data.matchResult.doshaAnalysis),
                    ChartsTab(data: data)
                    // ChartsTab(data: kundaliData['matchResult']['charts']),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class DetailsTab extends StatelessWidget {
  final KundliData data;

  const DetailsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Details',
          ),
          SizedBox(height: 16),
          _buildDetailCard(context, 'Male Details', data.maleDetails),
          SizedBox(height: 16),
          _buildDetailCard(context, 'Female Details', data.femaleDetails),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context, String title, PersonDetails details) {
    final List<List<String>> rows = [
      ['Name', details.name],
      ['Date of Birth', '${details.day}/${details.month}/${details.year}'],
      [
        'Time of Birth',
        '${details.hour}:${details.min.toString().padLeft(2, '0')}'
      ],
      ['Location', 'Lat ${details.lat}, Lon ${details.lon}'],
      ['Timezone', details.tzone.toString()],
      ['Rashi', details.rashi],
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              border: TableBorder.all(color: Colors.black12),
              children: List.generate(rows.length, (index) {
                final List<String> row = rows[index];
                final isEven = index % 2 == 0;
                return TableRow(
                  decoration: BoxDecoration(
                    color: isEven ? Colors.red[100] : Colors.white,
                  ),
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cell,
                        style: row.indexOf(cell) == 0
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GunaMilanTab extends StatelessWidget {
  final GunaMilan gunaData;
  final Compatibility data;
  final List<String> remedies;
  const GunaMilanTab(
      {super.key,
        required this.gunaData,
        required this.remedies,
        required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guna Milan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: gunaData.score / gunaData.maxScore,
            center: Text('${gunaData.score}/${gunaData.maxScore}'),
            progressColor: Colors.deepPurple,
            backgroundColor: Colors.grey[300]!,
            footer: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                gunaData.score >= gunaData.minimumRequired
                    ? 'Score meets minimum requirement'
                    : 'Score below minimum requirement (${gunaData.minimumRequired})',
                style: TextStyle(
                  color: gunaData.score >= gunaData.minimumRequired
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildSectionTitle('Compatibility'),
          const SizedBox(height: 12),
          _buildCompatibilityCard(Icons.psychology, 'Mental', data.mental),
          _buildCompatibilityCard(Icons.favorite, 'Emotional', data.emotional),
          _buildCompatibilityCard(
              Icons.attach_money, 'Financial', data.financial),
          _buildCompatibilityCard(
              Icons.fitness_center, 'Physical', data.physical),
          _buildCompatibilityCard(Icons.all_inclusive, 'Overall', data.overall),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conclusion:  ',
                style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                gunaData.conclusion,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildGunaDetailCard(context, 'Varna', gunaData.details.varna),
          _buildGunaDetailCard(context, 'Vashya', gunaData.details.vashya),
          _buildGunaDetailCard(context, 'Tara', gunaData.details.tara),
          _buildGunaDetailCard(context, 'Yoni', gunaData.details.yoni),
          _buildGunaDetailCard(context, 'Maitri', gunaData.details.maitri),
          _buildGunaDetailCard(context, 'Gan', gunaData.details.gan),
          _buildGunaDetailCard(context, 'Bhakut', gunaData.details.bhakut),
          _buildGunaDetailCard(context, 'Nadi', gunaData.details.nadi),
          const SizedBox(height: 15),
          _buildSectionTitle('Remedies'),
          const SizedBox(height: 8),
          remedies.isEmpty
              ? const Text('No remedies provided.')
              : Column(
            children: remedies.map((remedy) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.red),
                  title: Text(remedy),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGunaDetailCard(
      BuildContext context, String title, GunaAttribute detail) {
    Color getColor(double points, int max) {
      double percent = points / max;
      if (percent >= 0.75) return Colors.green;
      if (percent >= 0.4) return Colors.orange;
      return Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 10,
            percent: detail.points / detail.max,
            center: Text('${detail.points}/${detail.max}'),
            progressColor: getColor(detail.points, detail.max),
            backgroundColor: Colors.grey[300]!,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.description,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityCard(
      IconData icon, String title, String description) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.red),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class DoshaAnalysisTab extends StatelessWidget {
  final DoshaAnalysis data;

  const DoshaAnalysisTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dosha Analysis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildManglikCard(context, data.manglik),
          _buildGenericDoshaCard(context, 'Nadi', data.nadi),
          _buildGenericDoshaCard(context, 'Bhakut', data.bhakut),
          _buildGenericDoshaCard(context, 'Rajju', data.rajju),
          _buildGenericDoshaCard(context, 'Vedha', data.vedha),
        ],
      ),
    );
  }

  Widget _buildManglikCard(BuildContext context, Manglik manglik) {
    final List<List<String>> rows = [
      ['Male', '${manglik.malePercentage}%'],
      ['Female', '${manglik.femalePercentage}%'],
      ['Compatibility', manglik.compatibility],
    ];

    return _buildTableCard(context, 'Manglik', rows);
  }

  Widget _buildGenericDoshaCard(
      BuildContext context, String title, Dosha dosha) {
    final List<List<String>> rows = [
      ['Present', dosha.present ? 'Yes' : 'No'],
      ['Impact', dosha.impact],
    ];

    if (dosha.remedy.isNotEmpty) {
      rows.add(['Remedy', dosha.remedy]);
    }

    return _buildTableCard(context, title, rows);
  }

  Widget _buildTableCard(
      BuildContext context, String title, List<List<String>> rows) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              border: TableBorder.all(color: Colors.black12),
              children: List.generate(rows.length, (index) {
                final row = rows[index];
                final isEven = index % 2 == 0;
                return TableRow(
                  decoration: BoxDecoration(
                    color: isEven ? Colors.red[100] : Colors.white,
                  ),
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cell,
                        style: row.indexOf(cell) == 0
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartsTab extends StatelessWidget {
  final KundliData data;

  const ChartsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Astrological Charts',
          ),
          SizedBox(height: 16),
          Text(
            'Male Chart',
          ),
          SvgPicture.string(
            data.matchResult.charts.male.d1Image.svg,
            height: 300,
            width: 300,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16),
          Text(
            'Female Chart',
          ),
          SvgPicture.string(
            data.matchResult.charts.female.d1Image.svg,
            height: 300,
            width: 300,
            color: Colors.red.shade300,
          ),
        ],
      ),
    );
  }
}