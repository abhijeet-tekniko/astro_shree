import 'dart:convert';

import 'package:astro_shree_user/core/network/dio_client.dart';
import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:astro_shree_user/data/api_call/blog_api.dart';
import 'package:astro_shree_user/data/model/get_my_session_model.dart';
import 'package:astro_shree_user/presentation/astrologers_view_all/live_astrologers.dart';
import 'package:astro_shree_user/presentation/astrologers_view_all/our_astrologers.dart';
import 'package:astro_shree_user/presentation/blog_screen/blog_detailed_screen.dart';
import 'package:astro_shree_user/presentation/blog_screen/blog_list_screen.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/chat_screen.dart';
// import 'package:astro_shree_user/presentation/kundali/kundali_form.dart';
import 'package:astro_shree_user/presentation/life_problems/life_problems.dart';
import 'package:astro_shree_user/presentation/panchang.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/widget/banners.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_loading.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:astro_shree_user/widget/homepagewidgets/live_astrologers_card.dart';
import 'package:astro_shree_user/widget/homepagewidgets/top_astrologers_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/no_internet_page.dart';
import '../../data/api_call/banner_controller.dart';
import '../../data/api_call/language_controller.dart';
import '../../data/api_call/member_controller.dart';
import '../../data/api_call/profile_api.dart';
import '../../services/firebase_service_file.dart';
import '../astro_profile/astrologers_profile.dart';
import '../chat_and_call_screen/call_screen.dart';
import '../chat_session_screen.dart';
import '../e_pooja/pooja_listing.dart';
import '../kundali/kundali_form.dart';
import '../kundali/kundli_new/kundali_new_form.dart';
import '../kundali/kundli_match_detaIl_screen.dart';
import '../live_screen/user_live_attend_screen.dart';
import '../live_screen/user_live_controller.dart';
import '../newChatScreen.dart';
import '../products/product_list_screen.dart';
import '../socket_services.dart';

class HomePage extends StatefulWidget {
  final Function(int) onItemSelected;
  const HomePage({super.key, required this.onItemSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final langController = Get.put(LanguageController());
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final BlogApi blogApi = Get.put(BlogApi());
  final AstrologersApi astrologersApi = Get.put(AstrologersApi());
  final ProfileApi profileApi = Get.put(ProfileApi());
  final BannerController bannerController = Get.put(BannerController());
  var selectedUniLanguage = 'en';
  Future<bool> _onWillPop() async {
    bool shouldLeave = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit"),
        content: Text("Do you want to exit the application?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return shouldLeave;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading();
    });
  }

  final MemberController kundliMemberController = Get.put(MemberController());

  loading() async {
    profileApi.fetchIsNewUser();
    checkInternet.hasConnection();
    astrologersApi.fetchAstrologers();
    astrologersApi.fetchSpeciality();
    astrologersApi.fetchLiveAstrologers("");
    astrologersApi.fetchActiveSession();
    blogApi.fetchBlogs();
    blogApi.fetchNews();
    kundliMemberController.fetchKundaliMembers();
    blogApi.fetchTestimonial();
    await profileApi.fetchProfile();
    await langController.loadLanguage();

    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );

    if (astrologersApi.activeSessionData.value != null &&
        astrologersApi.activeSessionData.value.data != null) {
      if (astrologersApi.activeSessionData.value.data!.type == 'chat') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatNewwScreen(
              chatSessionId:
                  astrologersApi.activeSessionData.value.data!.chatSessionId ??
                      '',
              astrologerName: astrologersApi
                      .activeSessionData.value.data!.astrologer?.name ??
                  '',
              astrologerId: astrologersApi
                      .activeSessionData.value.data!.astrologer?.sId ??
                  '',
              astrologerImage: EndPoints.imageBaseUrl +
                      astrologersApi.activeSessionData.value.data!.astrologer!
                          .profileImage
                          .toString() ??
                  '',
              maxDuartion: astrologersApi
                      .activeSessionData.value.data!.remainingTime
                      .toString() ??
                  '',
              // chatPrice: 10,
            ),
          ),
        );
      } else if (astrologersApi.activeSessionData.value.data!.type == 'voice') {
        Fluttertoast.showToast(msg: 'You have an active Voice Call Session');
      }
    } else {
      return SizedBox.shrink();
    }
  }

  final controller = Get.put(UserLiveController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() {
        selectedUniLanguage = langController.selectedLanguage.value;
        final topLabel = selectedUniLanguage == 'en'
            ? [
                {'label': 'Daily\nHoroscope'},
                {'label': 'Free\nKundli'},
                {'label': 'Kundli\nMatching'},
                {'label': 'Today\'s\nPanchang'},
              ]
            : [
                {'label': 'दैनिक\nराशिफल'},
                {'label': 'मुफ़्त\nकुंडली'},
                {'label': 'कुंडली\nमिलान'},
                {'label': 'आज का\nपंचांग'},
              ];
        if (profileApi.isLoading.value ||
            astrologersApi.isLoading.value ||
            blogApi.isLoading.value) {
          return Center(child: CustomLoadingScreen());
        }
        if (checkInternet.noInternet.value) {
          return Center(
            child: NoInternetPage(onRetry: loading),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    /// Horoscope, Kundli, Panchang, Numerology
                    Container(
                      // color: const Color(0xFFFDC3C3),
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.015,
                          horizontal: screenWidth * 0.045),
                      height: screenHeight * 0.15,
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.08,
                                  width: screenHeight * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: const Color(0xFFFFD9DB),
                                    // border: Border.all(color: Color(0xFFC62828),width: 4)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.01),
                                    child: CustomImageView(
                                      onTap: () {
                                        NavigatorService.pushNamed(
                                          AppRoutes.dailyHoroscopeScreen,
                                        );
                                      },
                                      imagePath:
                                          ImageConstant.newDailyHoroscope,
                                      // imagePath: ImageConstant.dailyHoroscopeIcon,
                                      fit: BoxFit.fill,
                                      // color: Color(0xFFC62828),
                                      radius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    topLabel[0]['label']!,
                                    style: TextStyles.bodyText4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.08,
                                  width: screenHeight * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: const Color(0xFFFFD9DB),
                                    // border: Border.all(color: Color(0xFFC62828),width: 4)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: CustomImageView(
                                      height: Get.height * 0.08,
                                      width: Get.width * 0.1,
                                      // imagePath: ImageConstant.kundliIcon,
                                      // imagePath: ImageConstant.newFreeKundli,\
                                      imagePath:
                                          "assets/images/free_kundli_new_latest_icon.png",
                                      // fit: BoxFit.cover,
                                      // radius: BorderRadius.circular(40),
                                      onTap: () async {
                                        await kundliMemberController
                                            .fetchKundaliMembers();
                                        if (kundliMemberController
                                            .kundaliMemberList.isEmpty) {
                                          Get.to(() => KundliFormScreen());
                                        } else {
                                          Get.to(() => MemberListScreen());
                                        }
                                        // Get.to(() => KundaliForm());

                                        ///below uncomment krna h
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    topLabel[1]['label']!,
                                    style: TextStyles.bodyText4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.08,
                                  width: screenHeight * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: const Color(0xFFFFD9DB),
                                    // border: Border.all(color: Color(0xFFC62828),width: 4)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: CustomImageView(
                                      // imagePath: ImageConstant.kundliIcon,
                                      imagePath:
                                          'assets/images/kundli_match_new_icon.png',
                                      // ImageConstant.newMatchKundali,
                                      // fit: BoxFit.contain,
                                      // radius: BorderRadius.circular(40),
                                      onTap: () {
                                        Get.to(() => KundaliMatchingForm());
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    // 'Panchang',
                                    topLabel[2]['label']!,
                                    style: TextStyles.bodyText4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.08,
                                  width: screenHeight * 0.08,
                                  decoration: BoxDecoration(
                                      //   shape: BoxShape.circle,
                                      //   color: const Color(0xFFFFD9DB),
                                      color: Colors.white),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(screenWidth * 0.012),
                                    child: CustomImageView(
                                      imagePath:
                                          "assets/images/panchang_latest_icon.png",
                                      // ImageConstant.newTodayPanchaang,
                                      fit: BoxFit.cover,
                                      // radius: BorderRadius.circular(40),
                                      onTap: () {
                                        Get.to(Panchang());
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    // 'Numerology',
                                    topLabel[3]['label']!,
                                    style: TextStyles.bodyText4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.shade300,
                        )),
                    // SizedBox(height: screenHeight * 0.01),

                    /// First banner
                    Obx(() {
                      if (bannerController.isBannerLoading.value ||
                          bannerController.banner.value == null) {
                        return Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        );
                      } else {
                        return BannerCarouselSlider(
                          banners: bannerController.banner.value!.data!,
                          autoPlay: true,
                          horizontalPadding: 10,
                          imageFit: BoxFit.fill,
                        );
                      }
                    }),

                    SizedBox(height: screenHeight * 0.01),

                    Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.shade300,
                        )),

                    ///Live Astrologers

                    Obx(() {
                      if (astrologersApi.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final astrologers =
                          astrologersApi.astrologerLiveList.value;

                      if (astrologers == null || astrologers.isEmpty) {
                        return SizedBox.shrink();
                        // return const Center(
                        //     child: Text('No astrologers found.'));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listHeader(
                            screenWidth,
                            "Live Session",
                            () {
                              // widget.onItemSelected(1);
                            },
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: screenHeight * 0.22,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: astrologersApi
                                  .astrologerLiveList.value!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final liveAstro = astrologersApi
                                    .astrologerLiveList.value![index];

                                // DateTime dateTime = DateTime.parse(liveAstro.);
                                //
                                // String formattedTime = DateFormat('hh:mm a').format(dateTime);
                                return LiveFullScreenCard(
                                  imageUrl: EndPoints.imageBaseUrl +
                                      liveAstro.profileImage.toString(),
                                  title: liveAstro.name!.capitalizeFirst ??
                                      "Param",
                                  subtitle: liveAstro.specialities?.first.name
                                          ?.capitalizeFirst ??
                                      "Vedic Astrology",
                                  isLive: true,
                                  onPressed: () {
                                    print(profileApi.userProfile.value!.id
                                            .toString() +
                                        'x');
                                    // controller.initSocketListeners(profileApi.userProfile.value!.id.toString(),);
                                    // controller.joinLiveSession(liveAstro.liveSession!.liveSessionId.toString(),profileApi.userProfile.value!.id.toString(),);
                                    Get.to(() => UserLiveScreen(
                                          userId: profileApi
                                              .userProfile.value!.id
                                              .toString(),
                                          liveSessionId: liveAstro
                                              .liveSession!.liveSessionId
                                              .toString(),
                                          astroId:
                                              liveAstro.astrologerId.toString(),
                                        ));
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      );
                    }),

                    /// My Session Astrologers

                    Obx(() {
                      if (astrologersApi.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final astrologers = astrologersApi.mySessionList.value;

                      if (astrologers == null || astrologers.isEmpty) {
                        return SizedBox.shrink();
                        // return const Center(
                        //     child: Text('No astrologers found.'));
                      }

                      return Column(
                        children: [
                          listHeader(
                            screenWidth,
                            "My Session",
                            () {
                              Get.to(() => MySessionListScreen(
                                    sessionData: astrologers,
                                  ));

                              // widget.onItemSelected(1);
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                // vertical: screenWidth * 0.020,
                                horizontal: screenWidth * 0.025),
                            height: screenHeight * 0.18,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    astrologers.length >= 5
                                        ? 5
                                        : astrologers.length, (index) {
                                  final astro = astrologers[index];

                                  final isChat = astro.type == "chat";
                                  final isVideo = astro.type == "video";

                                  final price = isChat
                                      ? astro.astrologer!.pricing!.chat
                                      : isVideo
                                          ? astro.astrologer!.pricing!.video
                                          : astro.astrologer!.pricing!.voice;

                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => AstrologersProfile(
                                          astroId: astro.astrologer!.sId
                                              .toString()));
                                    },
                                    child: Container(
                                      width: screenWidth * 0.90,
                                      height: screenHeight * 0.14,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color(0xFFFDC3C3)),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          // Profile Image
                                          Container(
                                            height: screenHeight * 0.09,
                                            width: screenHeight * 0.09,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFC62828),
                                                  width: 1),
                                            ),
                                            child: ClipOval(
                                              child: CustomImageView(
                                                width: screenHeight * 0.09,
                                                imagePath: EndPoints.base +
                                                    astro.astrologer!
                                                        .profileImage
                                                        .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // Name, charge, and buttons
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  astro.astrologer!.name
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "₹ $price/min",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    isChat
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ChatSessionDetailsScreen(
                                                                    id: astro
                                                                        .sId
                                                                        .toString(),
                                                                    astroName: astro
                                                                        .astrologer!
                                                                        .name
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height:
                                                                  screenHeight *
                                                                      0.035,
                                                              width:
                                                                  screenWidth *
                                                                      0.25,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blue
                                                                        .shade700),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Text(
                                                                'View Chat',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade700,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    const SizedBox(width: 10),

                                                    // Chat Again Button (right)
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Handle "Chat Again" action
                                                      },
                                                      child: Container(
                                                        height: screenHeight *
                                                            0.035,
                                                        width:
                                                            screenWidth * 0.25,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .green
                                                                  .shade800),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                          isChat
                                                              ? 'Chat Again'
                                                              : isVideo
                                                                  ? 'Video Again'
                                                                  : 'Call Again',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .green.shade800,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    ///AstroShree Remedies
                    listHeader(
                      screenWidth,
                      "AstroShree Remedies",
                      viewAll: false,
                      () {},
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Product Container (Bracelets & Pendants)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryPage(),
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/productImage.jpg', // Fallback to local asset
                                        height: 170,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )),
                                  // Gradient overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  // Centered Title at the bottom
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(),
                                            ));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          'Products',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: const Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Pooja Container (E-Pooja)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductListingScreen(),
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/poojaImage.png', // Fallback to local asset
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )),
                                  // Gradient overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  // Centered Title at the bottom
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductListingScreen(),
                                            ));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          'E-Pooja',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: const Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                        child: Divider(
                          thickness: 2,
                        )),

                    /// Top Astrologers
                    listHeader(
                      screenWidth,
                      "Our Top Astrologers",
                      () {
                        widget.onItemSelected(1);
                      },
                    ),

                    Obx(() {
                      if (astrologersApi.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
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
                            children: List.generate(
                                astrologers.length >= 5
                                    ? 5
                                    : astrologers.length, (index) {
                              final astro = astrologers[index];

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => AstrologersProfile(
                                          astroId: astro.id));
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
                                        Get.to(() => AstrologersProfile(
                                            astroId: astro.id));
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

                    /// Latest Blogs
                    listHeader(
                      screenWidth,
                      "Latest blog",
                      () {
                        Get.to(() => BlogListScreen());
                      },
                    ),
                    Obx(() {
                      if (blogApi.isLoading.value) {
                        return const Center(child: CustomLoadingScreen());
                      }

                      final blog = blogApi.blogs;

                      if (blog.isEmpty) {
                        return const Center(child: Text('No blogs found.'));
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenWidth * 0.020,
                            horizontal: screenWidth * 0.025),
                        height: screenHeight * 0.24,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: blogApi.blogs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final blog = blogApi.blogs[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => BlogDetailedScreen(blog: blog));
                              },
                              child: SizedBox(
                                width: screenWidth * 0.60,
                                child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: CustomImageView(
                                          height: screenHeight * 0.14,
                                          width: screenWidth * 1,
                                          imagePath: blog.thumbImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: screenHeight * 0.01),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2,
                                              vertical: 0.2,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            width: screenWidth * 1,
                                            child: Text(
                                              blog.title,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'inc42',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '07 Nov 2024',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    // SizedBox(height: screenHeight * 0.01),

                    /// Customer Reviews
                    blogApi.reviewData.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                // vertical: screenWidth * 0.030,
                                horizontal: screenWidth * 0.035),
                            child: Row(
                              children: [
                                Text('Customer Review',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Text('View All',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),

                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.020,
                          horizontal: screenWidth * 0.025),
                      height: screenHeight * 0.20,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: blogApi.reviewData.length > 4
                            ? 4
                            : blogApi.reviewData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final reviewData = blogApi.reviewData[index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            width: screenWidth * 0.75,
                            child: GestureDetector(
                              onTap: () {
                                // NavigatorService.pushNamed(
                                //   AppRoutes.blogDetailedScreen,
                                // );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      width: screenWidth * 0.75,
                                      height: screenHeight * 0.09,
                                      child: Text(
                                        reviewData.message.toString(),
                                        // 'Korem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.Korem ipsum dolor sit amet, consectetur adipiscing elit. ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        maxLines: 3,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: CustomImageView(
                                                height: screenHeight * 0.06,
                                                // width: screenWidth * 0.15,
                                                imagePath:
                                                    EndPoints.imageBaseUrl +
                                                        reviewData
                                                            .user!.profileImage
                                                            .toString(),
                                                radius:
                                                    BorderRadius.circular(40),
                                                // imagePath: ImageConstant
                                                //     .customerImage,
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    reviewData.user!.name
                                                            .toString()
                                                            .capitalizeFirst ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                // Text("Delhi"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "26-Jan-2025",
                                              style: TextStyles.bodyText2,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.yellow,
                                                ),
                                                SizedBox(width: 3),
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.yellow,
                                                ),
                                                SizedBox(width: 3),
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.yellow,
                                                ),
                                                SizedBox(width: 3),
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.yellow,
                                                ),
                                                SizedBox(width: 3),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    ///NewsKashi
                    blogApi.news.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.035),
                            child: Text("AstroShree in News",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          )

                        /*,  listHeader(
                      screenWidth,
                      "AstroShree in News",
                      () {
                        Get.to(() => BlogListScreen());
                      },
                    )*/
                        : SizedBox.shrink(),
                    Obx(() {
                      if (blogApi.isLoading.value) {
                        return const Center(child: CustomLoadingScreen());
                      }

                      final news = blogApi.news;

                      if (news.isEmpty) {
                        return const Center(child: Text('No news found.'));
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenWidth * 0.020,
                            horizontal: screenWidth * 0.025),
                        height: screenHeight * 0.24,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: blogApi.news.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final news = blogApi.news[index];
                            return GestureDetector(
                              onTap: () {
                                // Get.to(() => BlogDetailedScreen(blog: blog));
                              },
                              child: SizedBox(
                                width: screenWidth * 0.60,
                                child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: CustomImageView(
                                          height: screenHeight * 0.14,
                                          width: screenWidth * 1,
                                          imagePath: EndPoints.imageBaseUrl +
                                              news.image.toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: screenHeight * 0.01),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2,
                                              vertical: 0.1,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            width: screenWidth * 1,
                                            child: Text(
                                              news.title?.capitalizeFirst ?? "",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  news.source
                                                          .toString()
                                                          .capitalizeFirst ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '07 Nov 2024',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: screenHeight * 0.01),

                    /// Bottom Information
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: const Color(0xFFFDC3C3),
                      padding: EdgeInsets.all(screenWidth * 0.015),
                      height: screenHeight * 0.145,
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.075,
                                  width: screenHeight * 0.075,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.privateNconfidential,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    'Private &\nConfidential',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: VerticalDivider(color: Colors.grey),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.075,
                                  width: screenHeight * 0.075,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.verifiedAstrologers,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    'Verified\nAstrologers',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: VerticalDivider(color: Colors.grey),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.075,
                                  width: screenHeight * 0.075,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.securePayments,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Expanded(
                                  child: Text(
                                    'Secure\nPayments',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassmorphicButton(
                      // text: 'Talk to\nAstrologer',
                      text: 'Call',
                      icon: Icons.phone,
                      onPressed: () {
                        widget.onItemSelected(3);
                        print('Call button pressed');
                      },
                    ),
                    const SizedBox(width: 20),
                    GlassmorphicButton(
                      text: 'Chat',
                      icon: Icons.chat,
                      onPressed: () {
                        widget.onItemSelected(1);
                        print('Chat button pressed');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget listHeader(double screenWidth, title, VoidCallback? onTap,
      {bool? viewAll = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          /*vertical: screenWidth * 0.020, */ horizontal: screenWidth * 0.035),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Spacer(),
          viewAll == true
              ? GestureDetector(
                  onTap: onTap,
                  child: Text('View All',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                )
              : Center()
        ],
      ),
    );
  }
}

///6.6

class GlassmorphicButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const GlassmorphicButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 160,
      height: 40,
      borderRadius: 45,
      blur: 1,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Color(0xFFFFB402).withOpacity(0.8),
          Color(0xFFFFB402).withOpacity(0.8),
          // Colors.white.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Color(0xFFFF7802).withOpacity(0.5),
          Color(0xFFFF7802).withOpacity(0.5),
          Colors.white.withOpacity(0.2),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///my sessionList
class MySessionListScreen extends StatefulWidget {
  final List<MySessionData> sessionData;
  const MySessionListScreen({super.key, required this.sessionData});

  @override
  State<MySessionListScreen> createState() => _MySessionListScreenState();
}

class _MySessionListScreenState extends State<MySessionListScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('My Session'),
      ),
      body: ListView.builder(
        itemCount: widget.sessionData.length,
        itemBuilder: (context, index) {
          final astro = widget.sessionData[index];

          final isChat = astro.type == "chat";
          final isVideo = astro.type == "video";

          final price = isChat
              ? astro.astrologer!.pricing!.chat
              : isVideo
                  ? astro.astrologer!.pricing!.video
                  : astro.astrologer!.pricing!.voice;

          return GestureDetector(
            onTap: () {
              //  Get.to(UserLiveScreen(liveSessionId: '68999db10dd03b627f473da9', userId: '688c9340b4ea666aedb20f46',));
              Get.to(() => AstrologersProfile(
                  astroId: astro.astrologer!.sId.toString()));
            },
            child: Container(
              width: screenWidth * 0.90,
              height: screenHeight * 0.14,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDC3C3)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    height: screenHeight * 0.09,
                    width: screenHeight * 0.09,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFC62828), width: 1),
                    ),
                    child: ClipOval(
                      child: CustomImageView(
                        width: screenHeight * 0.09,
                        imagePath: EndPoints.base +
                            astro.astrologer!.profileImage.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Name, charge, and buttons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          astro.astrologer!.name.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "₹ $price/min",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            isChat
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ChatSessionDetailsScreen(
                                            id: astro.sId.toString(),
                                            astroName: astro.astrologer!.name
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: screenHeight * 0.035,
                                      width: screenWidth * 0.25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue.shade700),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'View Chat',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            const SizedBox(width: 10),

                            // Chat Again Button (right)
                            GestureDetector(
                              onTap: () {
                                // Handle "Chat Again" action
                              },
                              child: Container(
                                height: screenHeight * 0.035,
                                width: screenWidth * 0.25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green.shade800),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isChat
                                      ? 'Chat Again'
                                      : isVideo
                                          ? 'Video Again'
                                          : 'Call Again',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
