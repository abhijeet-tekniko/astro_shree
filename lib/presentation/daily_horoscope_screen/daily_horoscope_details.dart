import 'package:astro_shree_user/core/utils/string_resource.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:astro_shree_user/widget/shimmer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/endpoints.dart';
import '../../data/api_call/astrologers_api.dart';
import '../../data/api_call/horoscope_controller.dart';
import '../../data/api_call/language_controller.dart';
import '../../widget/homepagewidgets/top_astrologers_card.dart';
import '../astro_profile/astrologers_profile.dart';

class HoroscopeDetailedScreen extends StatefulWidget {
  final String data;
  final int index;

  const HoroscopeDetailedScreen(
      {super.key, required this.data, required this.index});

  @override
  State<HoroscopeDetailedScreen> createState() =>
      _HoroscopeDetailedScreenState();
}

class _HoroscopeDetailedScreenState extends State<HoroscopeDetailedScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var horoscopeController = Get.put(HoroscopeController());


  final AstrologersApi astrologersApi = Get.put(AstrologersApi());

  final langController = Get.find<LanguageController>();

  late Map<String, dynamic> selectedHoroscope;
  late String selectedSign;
  late String selectedLanguage = "ENGLISH";
  String? type = "daily";
  @override
  void initState() {
    super.initState();

    selectedSign = widget.data;
    selectedHoroscope = StringResource.horoscopeList[widget.index];

    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchHoroscopeForTab(_tabController.index);
    });

    horoscopeController.getDailyHoroscope(
        sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
    horoscopeController.getTomorrowHoroscope(
        sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
    horoscopeController.getMonthlyHoroscope(
        sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
    _tabController = TabController(length: 3, vsync: this);
  }

  void _fetchHoroscopeForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        setState(() {
          type = "daily";
        });
        horoscopeController.getDailyHoroscope(
            sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
        break;
      case 1:
        setState(() {
          type = "tomorrow";
        });
        horoscopeController.getTomorrowHoroscope(
            sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
        break;
      case 2:
        setState(() {
          type = "monthly";
        });
        horoscopeController.getMonthlyHoroscope(
            sign: selectedSign.toLowerCase(), context: context,language:langController.selectedLanguage.value );
        break;
      default:
        setState(() {
          type = "daily";
        });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(selectedSign),
        centerTitle: true,
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Prevent outer scroll conflicts
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.12,
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final sign = StringResource.horoscopeList[index];
                  final isSelected = sign["Name"].toString().toLowerCase() ==
                      selectedSign.toLowerCase();
                  var horoscope = StringResource.horoscopeList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSign = sign["Name"];
                        selectedHoroscope = StringResource.horoscopeList[index];
                      });
                      _fetchHoroscopeForTab(_tabController.index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(45),
                              border: isSelected
                                  ? Border.all(color: Colors.red, width: 1.5)
                                  : Border.all(color: Colors.blueGrey),
                            ),
                            child: CustomImageView(
                              imagePath: horoscope["Image"],
                              width: isSelected ? screenWidth * 0.12 : screenWidth * 0.10,
                              height: isSelected ? screenWidth * 0.12 : screenWidth * 0.10,
                              radius: BorderRadius.circular(20),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            horoscope["Name"],
                            style: TextStyles.bodyText4,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              return horoscopeController.isLoading.value
                  ? shimmerPlaceholder()
                  : Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    /// Tab Switch
                    SizedBox(height: 10),
                    Container(
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelStyle: TextStyle(color: Colors.grey),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.red,
                        dividerColor: Colors.white,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        tabs: const [
                          Tab(text: 'Today'),
                          Tab(text: 'Tomorrow'),
                          Tab(text: 'Monthly'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.65, // Keep constrained height
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTabContent("Today"),
                          _buildTabTomorrowContent("Tomorrow"),
                          _buildTabMonthlyContent("Monthly"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),


            ///astro

          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String tabType) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return horoscopeController.isLoading.value
          ? shimmerPlaceholder()
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/personal_new_icon.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Personal Life :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.personalLife ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/profession_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Profession :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.profession ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/health_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Health :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.health ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/emotion_horo.png',height: 18,width: 25,),
                  Text('Emotions :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.emotions ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/travel_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Travel :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.travel ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/luck_horoscope.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Luck :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeModel.value?.data?.first.prediction?.prediction?.luck ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),

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
        ),
      );
    });
  }

  Widget _buildTabTomorrowContent(String tabType) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return horoscopeController.isLoading.value
          ? shimmerPlaceholder()
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/personal_horoscope.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Personal Life :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.personalLife ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/profession_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Profession :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.profession ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/health_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Health :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.health ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/emotion_horo.png',height: 18,width: 25,),
                  Text('Emotions :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),

              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.emotions ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/travel_horo.png',height: 18,width: 25,),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Travel :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.travel ?? "",
                style: TextStyles.bodyText3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/luck_horoscope.png',height: 18,width: 25,),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Luck :', style: TextStyles.bodyText2,textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 8),
              Text(
                horoscopeController.horoscopeTomorrowModel.value?.data?.first.prediction?.prediction?.luck ?? "",
                style: TextStyles.bodyText3,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),

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
        ),
      );
    });
  }

  Widget _buildTabMonthlyContent(String tabType) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return horoscopeController.isLoading.value
          ? shimmerPlaceholder()
          : Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFC62828)),
                ),
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Already set
                  itemCount: horoscopeController.horoscopeMonthlyModel.value!.data!.first.prediction!.prediction!.length,
                  itemBuilder: (context, index) {
                    final predictions = horoscopeController.horoscopeMonthlyModel.value!.data!.first.prediction!.prediction![index];
                    return Text(
                      "● $predictions",
                      style: TextStyles.bodyText3,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Divider(color: Colors.red[300]),
              ),

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
        ),
      );
    });
  }
}
