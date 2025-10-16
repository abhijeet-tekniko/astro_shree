import 'dart:async';

import 'package:astro_shree_user/presentation/astro_profile/astrologers_profile.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/chat_screen.dart';
import 'package:astro_shree_user/presentation/home_screen/home_screen.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/no_internet_page.dart';
import '../../core/utils/navigator_service.dart';
import '../../data/api_call/astrologers_api.dart';
import '../../data/api_call/member_controller.dart';
import '../../data/api_call/profile_api.dart';
import '../../routes/app_routes.dart';
import '../../widget/homepagewidgets/top_astrologers_card.dart';
import '../add_family_chat_screen.dart';
import '../newChatScreen.dart';
import '../socket_services.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final AstrologersApi astrologersApi = Get.put(AstrologersApi());
  final ProfileApi profileApi = Get.put(ProfileApi());

  String chatSocketId = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading();
      SocketService.on('astrologerStatus', _handleAstrologerStatus);
      SocketService.on('chatRequestSent', _handleChatRequestSent);
      SocketService.on('chatRequestAccepted', _handleChatRequestAccepted);
      SocketService.on('chatRequestRejected', _handleChatRequestRejected);
    });
    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );
  }

  void _handleAstrologerStatus(dynamic data) {
    astrologersApi.handleAstrologerStatus(data);
  }

  void _handleChatRequestSent(dynamic data) {
    chatSocketId = data["chatRequestId"];
    setState(() {});
  }

  void _handleChatRequestAccepted(dynamic data) {
    // Navigation handled in SocketService
  }

  void _handleChatRequestRejected(dynamic data) {
    // Snackbar handled in SocketService
  }

  Future<bool> _onWillPop() async {
    Get.off(() => HomeScreen());

    return false;
  }

  final memberController = Get.put(MemberController());

  loading() async {
    await astrologersApi.fetchAstrologers();
    await checkInternet.hasConnection();
    memberController.fetchMembers();
    profileApi.fetchProfile();
    profileApi.fetchIsNewUser();
  }

  void _showChatRequestBottomSheet(dynamic astro) {
    bool isLoading = false;
    Timer? timeoutTimer;
    int remainingSeconds = 120;
    Timer? countdownTimer;

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
            void startTimeoutTimer() {
              timeoutTimer = Timer(const Duration(minutes: 2), () {
                astrologersApi.notRespondAstrologer(chatId: chatSocketId);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Astrologer Not Available'),
                    content: const Text(
                      'The astrologer did not respond in time. Please try again later.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK',
                            style: TextStyle(color: primaryColor)),
                      ),
                    ],
                  ),
                );
              });
            }

            void startCountdownTimer() {
              countdownTimer =
                  Timer.periodic(const Duration(seconds: 1), (timer) {
                if (remainingSeconds > 0) {
                  setState(() {
                    remainingSeconds--;
                  });
                } else {
                  timer.cancel();
                }
              });
            }

            String formatDuration(int seconds) {
              final minutes = seconds ~/ 60;
              final secs = seconds % 60;
              return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
            }

            void cancelTimeoutTimer() {
              if (timeoutTimer?.isActive ?? false) {
                timeoutTimer?.cancel();
              }
            }

            void onAstrologerAccepted() {
              cancelTimeoutTimer();
              Navigator.pop(context);
              // Proceed to chat screen...
            }

            void handleNotifyMe() {
              // astrologersApi.subscribeToAstrologerAvailability(astro.id);
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
                      if (isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            formatDuration(remainingSeconds),
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final userProfile = profileApi.userProfile.value;
                    final balance = userProfile?.wallet?.balance ?? 0.0;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Your Wallet Balance: ₹${balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Text(
                    'Chat Price: ₹${astro.pricing.chat}/minute',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum for 5 min: ₹${astro.pricing.chat * 5}',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final userProfile = profileApi.userProfile.value;
                    final balance = userProfile?.wallet?.balance ?? 0.0;
                    final minimumRequired = astro.pricing.chat * 5;
                    final isSufficient = balance >= minimumRequired;
                    final isAstrologerAvailable =
                        astro.status == 'online' && !(astro.isBusy ?? false);

                    return Column(
                      children: [
                        if (isAstrologerAvailable)
                          ElevatedButton(
                            onPressed: isSufficient && !isLoading
                                ? () {
                                    setState(() {
                                      isLoading = true;
                                      remainingSeconds = 120;
                                    });
                                    // SocketService.sendChatRequest(astro.id.toString());
                                    startCountdownTimer();
                                    startTimeoutTimer();
                                  }
                                : isSufficient
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        NavigatorService.pushNamed(
                                            AppRoutes.walletScreen);
                                      },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSufficient
                                  ? primaryColor
                                  : Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isSufficient
                                        ? 'Request Chat'
                                        : 'Add Money to Wallet',
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
                        if (!isSufficient)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Insufficient balance for a 5-minute chat',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MemberScreen(id: astro.id)),
                            );
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

  @override
  void dispose() {
    SocketService.off('astrologerStatus', _handleAstrologerStatus);
    SocketService.off('chatRequestSent', _handleChatRequestSent);
    SocketService.off('chatRequestAccepted', _handleChatRequestAccepted);
    SocketService.off('chatRequestRejected', _handleChatRequestRejected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Obx(() {
          if (astrologersApi.isLoading.value) {
            return const Center(child: CustomLoadingScreen());
          }
          if (checkInternet.noInternet.value) {
            return Center(child: NoInternetPage(onRetry: loading));
          }
          final astrologers = astrologersApi.astrologerList.value;

          if (astrologers == null || astrologers.isEmpty) {
            return const Center(child: Text('No astrologers found.'));
          }

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: astrologers.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final astro = astrologers[index];

                final isBusy = astro.isBusy;

                return InkWell(
                  onTap: () {
                    Get.to(() => AstrologersProfile(astroId: astro.id));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TopAstrologersListCard(
                      imageUrl: EndPoints.base + astro.profileImage.toString(),
                      name: astro.name,
                      position: astro.speciality
                          .where((e) => e.status)
                          .map((e) => e.name)
                          .join(', '),
                      language: astro.language.join(', '),
                      charge: "${astro.pricing.chat}",
                      comesFrom: 'chat',
                      isCall: false,
                      isChat: astro.services.chat,
                      isPopular: index % 3 == 0,
                      status: astro.status ?? "",
                      isBusy: isBusy,
                      experience: astro.experience.toString(),
                      maxDuration: astro.maxWaitingTime ?? "",
                      onPressed: () {
                        final userProfile = profileApi.userProfile.value;
                        final isNew = profileApi.isNewUser.value;
                        final balance = userProfile?.wallet?.balance ?? 0.0;
                        final minimumRequired = astro.pricing.chat * 5;
                        final isSufficient = balance >= minimumRequired;
                        if (isNew) {
                          showFreeChatRequestBS(astro, 'chat');
                        } else if (isSufficient && isBusy == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MemberScreen(id: astro.id)),
                          );
                        } else if (isBusy == true) {
                          astrologersApi.notifyAstrologer(
                              astrologerId: astro.id,
                              title: astro.name,
                              message: 'Not Available',
                              type: 'chat');
                        } else {
                          _showChatRequestBottomSheet(astro);
                        }
                      },
                      onTap: () {
                        Get.to(() => AstrologersProfile(astroId: astro.id));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
