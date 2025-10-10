import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/all_charts_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/astakvarga_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/dasha_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/kp_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/kundli_chart_tab.dart';
import 'package:astro_shree_user/presentation/kundali/kundli_new/kundli_details_tab/report_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/app_bar/appbar_title.dart';
import '../../../widget/app_bar/custom_navigate_back_button.dart';
import 'get_kundali_api.dart';
import 'kundli_details_tab/basic_tab.dart';
import 'kundli_details_tab/harshabala_tab.dart';
import 'kundli_details_tab/lalkitab_tab.dart';
import 'kundli_details_tab/planetary_position_tab.dart';
import 'kundli_details_tab/saham_tab.dart';
import 'kundli_model.dart';

class KundliDetailsScreen extends StatefulWidget {
  const KundliDetailsScreen({super.key});

  @override
  State<KundliDetailsScreen> createState() => _KundliDetailsScreenState();
}

class _KundliDetailsScreenState extends State<KundliDetailsScreen> {
  final GetKundliApi kundliController = Get.put(GetKundliApi());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: AppbarTitle(
            text: 'Kundli Details',
            // margin: EdgeInsets.only(left: screenWidth * 0.2),
          ),
        ),
        body: Obx(() {
          if (kundliController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red.shade700),
                  const SizedBox(height: 16),
                  const Text('Fetching Kundli data...',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          if (kundliController.kundli.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade400, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'No Kundli data available. Please check inputs or try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          final KundliData data = kundliController.kundli.value!;
          print(
              " Planet Ashtak ${data.ashtakvarga!.planetAshtak!.sun?.ashtakVarga}");
          print(" Sarva Ashtak ${data.ashtakvarga!.sarvashtak}");
          return Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(text: 'Basic'),
                  Tab(text: 'Charts'),
                  Tab(text: 'KP'),
                  Tab(text: 'Astakvarga'),
                  Tab(text: 'Dasha'),
                  Tab(text: 'Report'),
                ],
              ),
              Flexible(
                child: TabBarView(
                  children: [
                    BasicDetailsTab(data: data),
                    KundliChartTab(data: data),
                    KpSystemTab(kpSystem: data.kpSystem!),
                    AshtakvargaTab(data: data.ashtakvarga!),
                    DashaTablesTab(dasha: data.dasha!),
                    ReportsTab(
                      reports: data.reports!,
                      dosha: data.dosha,
                      remedies: data.lalkitab?.remedies,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
