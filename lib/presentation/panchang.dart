import 'package:astro_shree_user/data/api_call/language_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/network/endpoints.dart';
import '../data/api_call/astrologers_api.dart';
import '../data/api_call/panchang_api.dart';
import '../data/model/panchang_model.dart';
import '../services/translate_service_file.dart';
import '../widget/app_bar/appbar_title.dart';
import '../widget/app_bar/custom_navigate_back_button.dart';
import '../widget/homepagewidgets/top_astrologers_card.dart';
import 'astro_profile/astrologers_profile.dart';

class Panchang extends StatefulWidget {
  const Panchang({super.key});

  @override
  State<Panchang> createState() => _PanchangState();
}

class _PanchangState extends State<Panchang> {
  final panchangApi = Get.put(PanchangApi());

  final AstrologersApi astrologersApi = Get.put(AstrologersApi());

  Widget buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SmartTranslatableText(
              translatable: TranslatableString(title,),
              languageCode: langController.selectedLanguage.value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold
              ),
        textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child:
          SmartTranslatableText(
            translatable: TranslatableString("$label ",),
            languageCode: langController.selectedLanguage.value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ), ),
          // Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          SmartTranslatableText(
            translatable: TranslatableString("$value ",),
            languageCode: langController.selectedLanguage.value,
            style: TextStyle(
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    panchangApi.fetchPanchang(date.toString().substring(0,10));
  }

  DateTime tempPickedDate=DateTime.now();

  void _showDatePickerDialog() {
    tempPickedDate = date; // Set initial temp value
    _showDialog(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              initialDateTime: date,
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              showDayOfWeek: true,
              onDateTimeChanged: (DateTime newDate) {
                tempPickedDate = newDate; // Update temp value only
              },
            ),
          ),
          CupertinoButton(
            child: Text('Done'),
            onPressed: () {
              setState(() {
                date = tempPickedDate; // Commit the picked date
              });
              panchangApi.fetchPanchang(date.toString().substring(0, 10)); // Call API once
              Navigator.pop(context); // Close dialog
            },
          ),
        ],
      ),
    );
  }


  void _showDialog(Widget child) {
    showCupertinoDialog<void>(
      context: context,barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.4,horizontal: 20),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,left: 20,right: 20,bottom: MediaQuery.of(context).size.height*0.5),

          padding: const EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CupertinoColors.systemBackground.resolveFrom(context),
          ),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Provide a background color for the popup.

          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(top: false, child: child),
        );
      },
    );
  }


  // void _showDialog(Widget child) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder:
  //         (BuildContext context) => Container(
  //       height: 216,
  //       padding: const EdgeInsets.only(top: 6.0),
  //       // The Bottom margin is provided to align the popup above the system
  //       // navigation bar.
  //       // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //       // Provide a background color for the popup.
  //       color: CupertinoColors.systemBackground.resolveFrom(context),
  //       // Use a SafeArea widget to avoid system overlaps.
  //       child: SafeArea(top: false, child: child),
  //     ),
  //   );
  // }

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: CustomNavigationButton(
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          title: AppbarTitle(
            text: 'Panchang',
            margin: EdgeInsets.only(left: screenWidth * 0.2),
          ),
        ),
        body: Obx(() {
          if (panchangApi.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final panchang = panchangApi.panchangData.value?.advancedPanchang;
          if (panchang == null) {
            return const Center(
              child: Text("No Data Found"),
            );
          }

          return Column(
            children: [
SizedBox(height: 10,),
              SizedBox(
                height: 38,
                child: TabBar(
                  indicatorColor: Color(0xFFC62828),
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.center,
                  physics: NeverScrollableScrollPhysics(),
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xFFC62828),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFC62828),
                  ),
                  onTap: (value) {
                    if (value == 0) {

                      _showDatePickerDialog();
                      // _showDialog(
                      //   CupertinoDatePicker(
                      //     initialDateTime: date,
                      //     mode: CupertinoDatePickerMode.date,
                      //     use24hFormat: true,
                      //     showDayOfWeek: true,
                      //     onDateTimeChanged: (DateTime newDate) {
                      //       setState(() {
                      //         date = newDate;
                      //
                      //         print('datetetet$date');
                      //       });
                      //       panchangApi.fetchPanchang(date.toString().substring(0,10));
                      //       Navigator.pop(context);
                      //       // panchangApi.fetchPanchang(date); // You may need to modify your API to accept date
                      //     },
                      //
                      //     // onDateTimeChanged: (DateTime newDate) {
                      //     //   setState(() {
                      //     //     date = newDate;
                      //     //     // TODO: Add API fetch logic for selected date
                      //     //   });
                      //     // },
                      //   ),
                      // );
                    }else if(value==1){
                      panchangApi.fetchPanchang(DateTime.now().toString().substring(0,10));
                    }else{
                      final tomorrow = DateTime.now().add(Duration(days: 1));
                      panchangApi.fetchPanchang(tomorrow.toString().substring(0, 10));
                    }
                  },
                  tabs: [
                    SizedBox(
                      width: 88,
                      child: Tab(child: Text('Calendar', textAlign: TextAlign.center)),
                    ),
                    SizedBox(
                      width: 88,
                      child: Tab(child: Text('Today', textAlign: TextAlign.center)),
                    ),
                    SizedBox(
                      width: 88,
                      child: Tab(child: Text('Tomorrow', textAlign: TextAlign.center)),
                    ),
                  ],
                ),
              ),

              // TabBar(
              //   // isScrollable: true,
              //   indicatorColor: Colors.red,
              //   // indicatorWeight: 4,
              //   dividerColor: Colors.red,
              //   tabAlignment: TabAlignment.center,
              //   labelColor: Colors.white,
              //   indicatorSize: TabBarIndicatorSize.tab,
              //   indicator: BoxDecoration(
              //   borderRadius: BorderRadius.circular(25),
              //   color: Colors.red,
              // ),
              //   onTap: (value){
              //     if(value==0){
              //       _showDialog(
              //         CupertinoDatePicker(
              //           initialDateTime: date,
              //           mode: CupertinoDatePickerMode.date,
              //           use24hFormat: true,
              //           // This shows day of week alongside day of month
              //           showDayOfWeek: true,
              //           // This is called when the user changes the date.
              //           onDateTimeChanged: (DateTime newDate) {
              //             setState(() => date = newDate);
              //           },
              //         ),
              //       );
              //     }
              //   },
              //   tabs: [
              //     Tab(
              //         child: Text(
              //           'Calendar',
              //           // style: TextStyle(color: Colors.red),
              //         )),
              //     Tab(
              //         child: Text(
              //           'Today',
              //           // style: TextStyle(color: Colors.red),
              //         )),
              //     Tab(
              //         child: Text(
              //           'Tomorrow',
              //           // style: TextStyle(color: Colors.red),
              //         )),
              //     // Tab(text: 'Charts'),
              //   ],
              // ),

              Expanded(
                // height: screenHeight * 0.8,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [

                    buildPanchangWidget(panchang),
                    buildPanchangWidget(panchang),
                    buildPanchangWidget(panchang),
                    // DetailsTab(data: data!),
                    // GunaMilanTab(
                    //     gunaData: data.matchResult.gunaMilan,
                    //     data: data.matchResult.compatibility,
                    //     remedies: data.matchResult.remedies),
                    // DoshaAnalysisTab(data: data.matchResult.doshaAnalysis),
                    // ChartsTab(data: data)
                    // ChartsTab(data: kundaliData['matchResult']['charts']),
                  ],
                ),
              ),


           /*   buildSection('Today\'s Panchaang', [
                buildRow('Tithi Name', panchang.tithi.name),
                buildRow('Deity', panchang.tithi.deity),
                buildRow('Sunset', panchang.tithi.summary),
                buildRow('Sunset', panchang.tithi.summary),
              ]), */


              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  final langController=Get.put(LanguageController());


  Widget buildPanchangWidget(AdvancedPanchang panchang ){

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [


          buildSection('Day & Time', [
            buildRow('Day', panchang.day),
            buildRow('Sunrise', panchang.sunrise),
            buildRow('Sunset', panchang.sunset),
            buildRow('Moonrise', panchang.moonrise),
            buildRow('Moonset', panchang.moonset),
            buildRow('Vedic Sunrise', panchang.vedicSunrise),
            buildRow('Vedic Sunset', panchang.vedicSunset),
          ]),
          buildSection('Tithi', [
            buildRow('Name', panchang.tithi.name),
            buildRow('Deity', panchang.tithi.deity),
            buildRow('End Time', panchang.tithi.endTime),
            buildRow('Special', panchang.tithi.special),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 0.6,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmartTranslatableText(
                  translatable: TranslatableString('Summary: '),
                  languageCode: langController.selectedLanguage.value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SmartTranslatableText(
              translatable: TranslatableString(panchang.tithi.summary,),
              languageCode: langController.selectedLanguage.value,
              style: TextStyle(
                  fontSize: 12,fontWeight: FontWeight.normal
              ),
            ),
          ]),
          buildSection('Nakshatra', [
            buildRow('Name', panchang.nakshatra.name),
            buildRow('Ruler', panchang.nakshatra.ruler),
            buildRow('Deity', panchang.nakshatra.deity),
            buildRow('End Time', panchang.nakshatra.endTime),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 0.6,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmartTranslatableText(
                    translatable: TranslatableString('Summary: '),
                    languageCode: langController.selectedLanguage.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SmartTranslatableText(
                translatable: TranslatableString(panchang.nakshatra.summary),
                languageCode: langController.selectedLanguage.value,
                style: TextStyle()
            ),
          ]),
          buildSection('Karana', [
            buildRow('Name', panchang.karana.name),
            buildRow('Deity', panchang.karana.deity),
            buildRow('End Time', panchang.karana.endTime),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 0.6,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmartTranslatableText(
                    translatable: TranslatableString('Special: '),
                    languageCode: langController.selectedLanguage.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SmartTranslatableText(
                translatable: TranslatableString(' ${panchang.karana.special}'),
                languageCode: langController.selectedLanguage.value,
                style: TextStyle()
            ),
          ]),
          buildSection('Yoga', [
            buildRow('Name', panchang.yoga.name),
            buildRow('End Time', panchang.yoga.endTime),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 0.6,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmartTranslatableText(
                    translatable: TranslatableString('Meaning: '),
                    languageCode: langController.selectedLanguage.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SmartTranslatableText(
                translatable: TranslatableString(' ${panchang.yoga.meaning}'),
                languageCode: langController.selectedLanguage.value,
                style: TextStyle()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmartTranslatableText(
                    translatable: TranslatableString('Special: '),
                    languageCode: langController.selectedLanguage.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SmartTranslatableText(
                translatable: TranslatableString(' ${panchang.yoga.special}'),
                languageCode: langController.selectedLanguage.value,
                style: TextStyle()
            ),
          ]),
          buildSection('Calendar', [
            buildRow('Paksha', panchang.paksha),
            buildRow('Ayana', panchang.ayana),
            buildRow('Ritu', panchang.ritu),
            buildRow('Sun Sign', panchang.sunSign),
            buildRow('Moon Sign', panchang.moonSign),
            buildRow('Panchang Yog', panchang.panchangYog),
            buildRow('Vikram Samvat',
                '${panchang.vikramSamvat} (${panchang.vikramSamvatName})'),
            buildRow('Shaka Samvat',
                '${panchang.shakaSamvat} (${panchang.shakaSamvatName})'),
          ]),
          buildSection('Muhurta & Kaal', [
            buildRow('Abhijit',
                '${panchang.abhijitMuhurta.start} - ${panchang.abhijitMuhurta.end}'),
            buildRow('Rahukaal',
                '${panchang.rahukaal.start} - ${panchang.rahukaal.end}'),
            buildRow('GuliKaal',
                '${panchang.guliKaal.start} - ${panchang.guliKaal.end}'),
            buildRow('Yamghant Kaal',
                '${panchang.yamghantKaal.start} - ${panchang.yamghantKaal.end}'),
          ]),


          Padding(
            padding: EdgeInsets.symmetric(
              /*vertical: screenWidth * 0.020, */horizontal: screenWidth * 0.035),
            child: Row(
              children: [
                Text("Our Top Astrologers",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // listHeader(
          //   screenWidth,
          //   "Our Top Astrologers",
          //       () {
          //     widget.onItemSelected(1);
          //   },
          // ),

          Obx(() {
            if (astrologersApi.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            final astrologers = astrologersApi.astrologerList.value;

            if (astrologers == null || astrologers.isEmpty) {
              return const Center(
                  child: Text('No astrologers found.'));
            }

            return Container(
              padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.020,
                  horizontal: screenWidth * 0.025),
              height: screenHeight * 0.25,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  List.generate(astrologers.length>=5?5:astrologers.length, (index) {
                    final astro = astrologers[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() =>
                                AstrologersProfile(astroId: astro.id));
                          },
                          child: TopAstrologersCard(
                            imageUrl: EndPoints.base +
                                astro.profileImage.toString(),
                            name: astro.name,
                            position: astro.speciality
                                .where((e) => e.status)
                                .map((e) => e.name)
                                .join(', '),
                            language: astro.language.join(', '),
                            charge: "₹${astro.pricing.chat}",
                            isCall: false,
                            isVerify: astro.isVerify,
                            onPressed: () {
                              Get.to(() =>
                                  AstrologersProfile(astroId: astro.id));
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }



}
