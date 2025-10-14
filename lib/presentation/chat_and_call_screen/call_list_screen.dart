import 'package:astro_shree_user/core/network/dio_client.dart';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/presentation/astro_profile/astrologers_profile.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/no_internet_page.dart';
import '../../core/utils/image_constant.dart';
import '../../data/api_call/astrologers_api.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/api_call/voice_call_controller.dart';
import '../../widget/custom_buttons/custom_loading.dart';
import '../../widget/homepagewidgets/top_astrologers_card.dart';
import '../home_screen/home_screen.dart';
import '../socket_services.dart';

class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key});

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  final AstrologersApi astrologersApi = Get.put(AstrologersApi());
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final ProfileApi profileApi = Get.put(ProfileApi());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading();
    });
    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );
  }

  loading() async {
    checkInternet.hasConnection();
    astrologersApi.fetchAstrologers();
    await profileApi.fetchProfile();

  }

  final VoiceCallController controller = Get.put(VoiceCallController());

  Future<bool> _onWillPop() async {
    Get.offAll(() => HomeScreen());
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Obx(() {
          if (astrologersApi.isLoading.value) {
            return const Center(child: CustomLoadingScreen());
          }
          if (checkInternet.noInternet.value) {
            return Center(
              child: NoInternetPage(onRetry: loading),
            );
          }
          final astrologers = astrologersApi.astrologerList.value;

          if (astrologers == null || astrologers.isEmpty) {
            return const Center(child: Text('No astrologers found.'));
          }

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: astrologers.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final astro = astrologers[index];
                  return InkWell(
                    onTap: () {
                      Get.to(() => AstrologersProfile(astroId: astro.id));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: TopAstrologersListCard(
                        imageUrl:
                            EndPoints.base + astro.profileImage.toString(),
                        name: astro.name,
                        position: astro.speciality
                            .where((e) => e.status)
                            .map((e) => e.name)
                            .join(', '),
                        language: astro.language.join(', '),
                        charge: "${astro.pricing.voice}",
                        comesFrom: 'call',
                        isCall: true,
                        isChat: astro.services.chat,
                        isPopular: index % 3 == 0 ? true : false,
                        status: astro.status ?? "",
                        maxDuration: astro.maxWaitingTime ?? "",
                        experience: astro.experience!.toString(),
                        onPressed: () {
                          final isNew = profileApi.isNewUser.value;
                          if (isNew) {
                            showFreeChatRequestBS(astro, 'call');
                          } else {
                            Get.to(() => CallScreen(
                                  id: astro.id,
                                  name: astro.name,
                                  profileImage: astro.profileImage.toString(),
                                ));
                          }
                        },
                        onTap: () {
                          Get.to(() => AstrologersProfile(astroId: astro.id));
                        },
                        isBusy: astro.isBusy,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  void showFreeChatRequestBS(dynamic astro, String type) {
    const primaryColor = Color(0xFFC62828);
    const secondaryColor = Color(0xFF4A4A4A);
    const accentColor = Color(0xFFFFF3E0);

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isAstrologerAvailable =
                astro.status == 'online' && !(astro.isBusy ?? false);

            void handleNotifyMe() {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'You will be notified when ${astro.name} is available'),
                  duration: const Duration(seconds: 3),
                  backgroundColor: primaryColor,
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [accentColor, Colors.white],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Text(
                              astro.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Chat with ${astro.name}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'This is you first free $type',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${type.capitalizeFirst!} is available for two minutes',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      if (isAstrologerAvailable)
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => CallScreen(
                                  id: astro.id,
                                  name: astro.name,
                                  profileImage: astro.profileImage.toString(),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Request Free ${type.capitalizeFirst!}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isAstrologerAvailable)
                        ElevatedButton(
                          onPressed: handleNotifyMe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Notify Me When Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isAstrologerAvailable)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Astrologer is currently busy or offline',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
