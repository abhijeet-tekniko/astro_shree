import 'dart:async';

import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:astro_shree_user/presentation/astro_profile/astro_ratings.dart';
import 'package:astro_shree_user/presentation/live_screen/user_live_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/navigator_service.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../core/utils/themes/textStyle.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/api_call/voice_call_controller.dart';
import '../../data/model/astrologers_model.dart';
import '../../routes/app_routes.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import 'package:flutter/material.dart';
import '../../core/network/endpoints.dart';
import '../../core/utils/image_constant.dart';
import '../../widget/custom_buttons/custom_loading.dart';
import '../../widget/custom_image_view.dart';
import '../add_family_chat_screen.dart';
import '../call_pick_screen.dart';
import '../chat_and_call_screen/call_screen.dart';
import '../socket_services.dart';

class AstrologersProfile extends StatefulWidget {
  // final Astrologer astro;
  final String astroId;
  const AstrologersProfile({super.key, required this.astroId});

  @override
  State<AstrologersProfile> createState() => _AstrologersProfileState();
}

class _AstrologersProfileState extends State<AstrologersProfile> {
  final RatingsController controller = Get.put(RatingsController());
  final ProfileApi profileApi = Get.put(ProfileApi());
  final AstrologersApi astrologersApi = Get.put(AstrologersApi());
  final giftController = Get.put(UserLiveController());
  final voiceController = Get.put(VoiceCallController());

  bool isVideoCallLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.setAstrologerId(widget.astroId);
        profileApi.fetchProfile();
        profileApi.fetchIsNewUser();
        astrologersApi.fetchAstrologersDetail(consultantId: widget.astroId);
        giftController.fetchGiftList();
      },
    );

    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );

    SocketService.on('videoCallRequestSent', (data) {
      print('objectttttttt$data');
    });

    SocketService.on('chatRequestSent', _handleChatRequestSent);

    // Handle errors
    SocketService.on('error', (data) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${data['message'] ?? 'An error occurred'}')),
      );
    });
    super.initState();
  }

  ///chat
  String chatSocketId = '';

  void _handleChatRequestSent(dynamic data) {
    chatSocketId = data["chatRequestId"];
    setState(() {});
  }

  void _showChatRequestBottomSheet(dynamic astro, String serviceType) {
    bool isLoading = false;
    Timer? timeoutTimer;
    int remainingSeconds = 120;
    Timer? countdownTimer;

    const primaryColor = Color(0xFFC62828); // Custom red color
    const secondaryColor = Color(0xFF4A4A4A); // Dark gray for text
    const accentColor =
        Color(0xFFFFF3E0); // Light orange for background accents

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
                            '$serviceType with ${astro.name}',
                            // 'Chat with ${astro.name}',
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
                    '$serviceType Price: ₹${serviceType.toLowerCase() == 'chat' ? astro.pricing.chat : serviceType.toLowerCase() == 'voice' ? astro.pricing.voice : astro.pricing.video}/minute',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum for 5 min: ₹${serviceType.toLowerCase() == 'chat' ? astro.pricing.chat * 5 : serviceType.toLowerCase() == 'voice' ? astro.pricing.voice * 5 : astro.pricing.video * 5}',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final userProfile = profileApi.userProfile.value;
                    final balance = userProfile?.wallet?.balance ?? 0.0;
                    final minimumRequired = serviceType.toLowerCase() == 'chat'
                        ? astro.pricing.chat * 5
                        : serviceType.toLowerCase() == 'voice'
                            ? astro.pricing.voice * 5
                            : astro.pricing.video * 5;
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
                              'Insufficient balance for a 5-minute $serviceType',
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
                          onPressed: type == 'chat'
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MemberScreen(id: astro.sId)),
                                  );
                                }
                              : type == 'video'
                                  ? () {
                                      initiateVideoCall(astro.sId, astro.name);
                                    }
                                  : () {
                                      voiceController
                                          .sendVoiceCallRequest(astro.sId);
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

  ///videoPart
  void initiateVideoCall(String astrologerId, String name) {
    try {
      isVideoCallLoading = true;
      setState(() {});
      // Show loading dialog

      SocketService.sendVideoCallRequest(astrologerId, name);
    } finally {
      isVideoCallLoading = false;
      setState(() {});
    }

    if (isVideoCallLoading) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: IconButton(
                  onPressed: () {
                    SharePlus.instance
                        .share(ShareParams(text: 'check out my this astro'));
                  },
                  icon: const Icon(Icons.share))),
          // Image.asset('assets/images/whatsapp.jpg'),
          // IconButton(onPressed: (){}, icon: Icon(Icons.sha))
        ],
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return astrologersApi.isDetailLoading.value
            ? Center(child: CustomLoadingScreen())
            : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  await controller.fetchRatings();

                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      controller.setAstrologerId(widget.astroId);
                      profileApi.fetchProfile();
                      astrologersApi.fetchAstrologersDetail(
                          consultantId: widget.astroId);
                    },
                  );
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          // Stack(
                          children: [
                            // CircleAvatar(
                            //   radius: 42,
                            //   backgroundColor: Colors.red,
                            //   child:     CustomImageView(
                            //     // margin: EdgeInsets.symmetric(horizontal: 5),
                            //     height: screenHeight * 0.1,
                            //     width: screenWidth * 0.2,
                            //     radius: BorderRadius.circular(60),
                            //     imagePath:
                            //     EndPoints.base + astrologersApi.astrologerDetail.value.data!.profileImage.toString(),
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            Container(
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: const Color(0xFFFFD9DB),
                                  border: Border.all(
                                      color: Color(0xFFC62828), width: 1)),
                              child: CustomImageView(
                                // margin: const EdgeInsets.symmetric(horizontal: 5),
                                // height: screenHeight * 0.1,
                                width: screenWidth,
                                radius: BorderRadius.circular(60),
                                imagePath: EndPoints.base +
                                    astrologersApi.astrologerDetail.value.data!
                                        .profileImage
                                        .toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            // SizedBox(height: 4,),

                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  // color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "⭐ 4.2",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   left: 0,
                            //   right: 0,
                            //   child:
                            // ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                astrologersApi
                                        .astrologerDetail.value.data!.name ??
                                    "",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: screenWidth * 0.40,
                              child: Text(
                                astrologersApi
                                    .astrologerDetail.value.data!.speciality!
                                    .where((e) => e.status!)
                                    .map((e) => e.name)
                                    .join(', '),
                                style: TextStyles.bodyText5,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${astrologersApi.astrologerDetail.value.data!.experience} yrs Exp.| ${astrologersApi.astrologerDetail.value.data!.language!.join(', ')}",
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgCallIcon,
                                height: screenHeight * 0.035,
                                color: Colors.grey,
                              ),
                              Text(
                                "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.voice}/min",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                            child: VerticalDivider(
                              color: Colors.red,
                              width: 2,
                              thickness: 1,
                            ),
                          ),
                          Row(
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.chatSmallIcon,
                                height: screenHeight * 0.035,
                                color: Colors.grey,
                              ),
                              Text(
                                "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.chat}/min",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                            child: VerticalDivider(
                              color: Colors.red,
                              width: 2,
                              thickness: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.video_chat_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Text(
                                "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.video}/min",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 10, top: 10),
                      child: Text("About", style: TextStyles.headline3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 5),
                      child: Text(
                        astrologersApi.astrologerDetail.value.data!.about ?? '',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (controller.ratings.isEmpty) {
                        return const Center(
                          child: SizedBox.shrink(),
                          // child: Text("No Reviews Found For This Astrologer"),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text("Reviews", style: TextStyles.headline3),
                          ),
                          ListView.builder(
                            controller: controller.scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.ratings.length,
                            itemBuilder: (context, index) {
                              final data = controller.ratings[index];

                              return data.user.name.isEmpty
                                  ? SizedBox.shrink()
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Row(
                                              children: [
                                                CustomImageView(
                                                  height: 40,
                                                  radius:
                                                      BorderRadius.circular(60),
                                                  width: 40,
                                                  fit: BoxFit.fill,
                                                  imagePath:
                                                      data.user.profileImage,
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data.user.name),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: _buildStarRow(
                                                          data.rating),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(data.createdAt
                                                        .toLocal()
                                                        .toString()
                                                        .split(" ")
                                                        .first),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            data.comment ?? "",
                                            style: TextStyles.bodyText5,
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => RatingsPage(
                                    astrologerId: astrologersApi
                                        .astrologerDetail.value.data!.sId!,
                                    astrologerName: astrologersApi
                                        .astrologerDetail.value.data!.name!,
                                  ));
                            },
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(child: Text("View All Reviews")),
                            ),
                          ),
                        ],
                      );
                    }),
                    Obx(() {
                      if (giftController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (giftController.gifts.isEmpty) {
                        return const Center(child: Text('No gifts available'));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Send a Gift',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                // childAspectRatio: 0.8,
                              ),
                              itemCount: giftController.gifts.length,
                              itemBuilder: (context, index) {
                                final gift = giftController.gifts[index];
                                return GestureDetector(
                                  onTap: () {
                                    giftController.sendGift(
                                      astroId: widget.astroId,
                                      giftId: gift.sId!,
                                      context: context,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (gift.image != null)
                                          Image.network(
                                            EndPoints.imageBaseUrl +
                                                gift.image!,
                                            height: 50,
                                            width: 50,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          gift.name ?? 'Gift',
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '\u20B9 ${gift.amount ?? 0}',
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                  ],
                ),
              );
      }),
      bottomNavigationBar: Obx(() {
        return astrologersApi.isDetailLoading.value
            ? SizedBox.shrink()
            : SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              if (astrologersApi.astrologerDetail.value.data!
                                      .services!.voice ==
                                  true) {
                                final userProfile =
                                    profileApi.userProfile.value;
                                final isNew = profileApi.isNewUser.value;
                                final balance =
                                    userProfile?.wallet?.balance ?? 0.0;
                                final minimumRequired = astrologersApi
                                        .astrologerDetail
                                        .value
                                        .data!
                                        .pricing!
                                        .voice *
                                    5;
                                final isSufficient = balance >= minimumRequired;
                                if (isNew) {
                                  showFreeChatRequestBS(
                                      astrologersApi
                                          .astrologerDetail.value.data!,
                                      "voice");
                                } else if (isSufficient &&
                                    astrologersApi.astrologerDetail.value.data!
                                            .isBusy ==
                                        false) {
                                  SocketService.sendVoiceCallRequest(
                                      astrologersApi
                                          .astrologerDetail.value.data!.sId!);
                                  Fluttertoast.showToast(
                                    msg:
                                        "Thank you! Our team will contact you shortly.",
                                  );
                                  // Get.to(() => CallScreen(id: astrologersApi.astrologerDetail.value.data!.sId!, profileImage: astrologersApi.astrologerDetail.value.data!.profileImage!, name:astrologersApi.astrologerDetail.value.data!.name!,));
                                } else if (astrologersApi
                                        .astrologerDetail.value.data!.isBusy ==
                                    true) {
                                  astrologersApi.notifyAstrologer(
                                      astrologerId: astrologersApi
                                          .astrologerDetail.value.data!.sId!,
                                      title: astrologersApi
                                          .astrologerDetail.value.data!.name!,
                                      message: 'Not Available',
                                      type: 'voice');
                                } else {
                                  _showChatRequestBottomSheet(
                                      astrologersApi
                                          .astrologerDetail.value.data!,
                                      'Voice');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Astrologer is not available for voice');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: astrologersApi.astrologerDetail.value
                                            .data!.isBusy ==
                                        true
                                    ? Colors.red.shade700
                                    : astrologersApi.astrologerDetail.value
                                                .data!.services!.voice ==
                                            true
                                        ? Colors.green
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgCallIcon,
                                    height: screenHeight * 0.03,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Call",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.voice}/min",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (astrologersApi.astrologerDetail.value.data!
                                      .services!.chat ==
                                  true) {
                                final userProfile =
                                    profileApi.userProfile.value;
                                final isNew = profileApi.isNewUser.value;
                                final balance =
                                    userProfile?.wallet?.balance ?? 0.0;
                                final minimumRequired = astrologersApi
                                        .astrologerDetail
                                        .value
                                        .data!
                                        .pricing!
                                        .chat *
                                    5;
                                final isSufficient = balance >= minimumRequired;
                                if (isNew) {
                                  showFreeChatRequestBS(
                                      astrologersApi
                                          .astrologerDetail.value.data!,
                                      "chat");
                                } else if (isSufficient &&
                                    astrologersApi.astrologerDetail.value.data!
                                            .isBusy ==
                                        false) {
                                  // showMemberBottomSheet(context,astro.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MemberScreen(
                                            id: astrologersApi.astrologerDetail
                                                .value.data!.sId!)),
                                  );
                                } else if (astrologersApi
                                        .astrologerDetail.value.data!.isBusy ==
                                    true) {
                                  astrologersApi.notifyAstrologer(
                                      astrologerId: astrologersApi
                                          .astrologerDetail.value.data!.sId!,
                                      title: astrologersApi
                                          .astrologerDetail.value.data!.name!,
                                      message: 'Not Available',
                                      type: 'chat');
                                } else {
                                  _showChatRequestBottomSheet(
                                      astrologersApi
                                          .astrologerDetail.value.data!,
                                      'Chat');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Astrologer is not available for chat');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: astrologersApi.astrologerDetail.value
                                            .data!.isBusy ==
                                        true
                                    ? Colors.red.shade700
                                    : astrologersApi.astrologerDetail.value
                                                .data!.services!.chat ==
                                            true
                                        ? Colors.green
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.chatSmallIcon,
                                    height: screenHeight * 0.03,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Chat",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.chat}/min",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            profileApi.fetchProfile();
                          },
                        );

                        if (astrologersApi
                                .astrologerDetail.value.data!.services!.video ==
                            true) {
                          final userProfile = profileApi.userProfile.value;
                          final isNew = profileApi.isNewUser.value;
                          final balance = userProfile?.wallet?.balance ?? 0.0;
                          final minimumRequired = astrologersApi
                                  .astrologerDetail.value.data!.pricing!.video *
                              5;
                          final isSufficient = balance >= minimumRequired;

                          print('isSufficient=======$isSufficient');
                          print('isSufficient=======$balance');
                          print('isSufficient=======$minimumRequired');
                          if (isNew) {
                            showFreeChatRequestBS(
                                astrologersApi.astrologerDetail.value.data!,
                                "video");
                          } else if (isSufficient &&
                              astrologersApi
                                      .astrologerDetail.value.data!.isBusy ==
                                  false) {
                            // Get.to(CallPickScreen(callerName: astrologersApi.astrologerDetail.value.data!.name!, callType: 'video', profileImage: 'https://i.pravatar.cc/100'));
                            initiateVideoCall(
                                astrologersApi
                                    .astrologerDetail.value.data!.sId!,
                                astrologersApi
                                    .astrologerDetail.value.data!.name!);
                          } else if (astrologersApi
                                  .astrologerDetail.value.data!.isBusy ==
                              true) {
                            astrologersApi.notifyAstrologer(
                                astrologerId: astrologersApi
                                    .astrologerDetail.value.data!.sId!,
                                title: astrologersApi
                                    .astrologerDetail.value.data!.name!,
                                message: 'Not Available',
                                type: 'video');
                          } else {
                            _showChatRequestBottomSheet(
                                astrologersApi.astrologerDetail.value.data!,
                                'Video');
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Astrologer is not available for video');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: astrologersApi
                                      .astrologerDetail.value.data!.isBusy ==
                                  true
                              ? Colors.red.shade700
                              : astrologersApi.astrologerDetail.value.data!
                                          .services!.video ==
                                      true
                                  ? Colors.green
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgCallIcon,
                              height: screenHeight * 0.03,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Video Call",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "  ₹${astrologersApi.astrologerDetail.value.data!.pricing!.video}/min",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
      }),
    );
  }

  List<Widget> _buildStarRow(int rating) {
    return List.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        size: 16,
        color: Colors.yellow[700],
      );
    });
  }
}

class Item {
  final String title;
  final String imageUrl;
  final double price;

  Item({required this.title, required this.imageUrl, required this.price});
}
