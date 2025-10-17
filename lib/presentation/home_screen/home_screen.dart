import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:astro_shree_user/presentation/astrologers_view_all/live_astrologers.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/call_list_screen.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/chat_list_screen.dart';
import 'package:astro_shree_user/presentation/drawer_screen/CustomDrawer.dart';
import 'package:astro_shree_user/presentation/home_screen/home_page.dart';
import 'package:astro_shree_user/widget/app_bar/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/no_internet_page.dart';
import '../../data/api_call/banner_controller.dart';
import '../../data/api_call/blog_api.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/api_call/recharge_list_api.dart';
import '../active_session_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../remedy/remedies_home.dart';
import '../socket_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final BlogApi blogApi = Get.put(BlogApi());
  final BannerController bannerController = Get.put(BannerController());
  final ProfileApi profileApi = Get.put(ProfileApi());
  final RechargeListApi rechargeListApi = Get.put(RechargeListApi());
  final AstrologersApi astrologersApi = Get.put(AstrologersApi());

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  List<Widget> get _pages => [
        HomePage(onItemSelected: _onItemTapped),
        ChatListScreen(),
        // RemediesHome(),
        AstrologerListScreen(),
        CallListScreen(),
        ProfileScreen(isHome: false),
      ];

  @override
  void initState() {
    socketLoad();
    astrologersApi.fetchActiveSession();
    rechargeListApi.fetchUserWallet();
    rechargeListApi.fetchRechargeList();
    super.initState();
  }

  socketLoad() async {
    await profileApi.fetchProfile();
    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            height: screenHeight,
            width: screenWidth,
            logoImagePath: ImageConstant.imgLogo,
            menuIconImagePath: ImageConstant.imgMenuIcon,
            onMenuIconTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            profileImagePath: ImageConstant.imgPersonIcon,
            walletIconImagePath: ImageConstant.imgWallet,
            languagePath: 'assets/images/translate_icon.png',
            walletAmountObs: rechargeListApi.userWallet,
          ),
          drawer: CustomDrawer(
            screenHeight: screenHeight,
            onItemSelected: _onItemTapped,
            profileApi: profileApi,
            screenWidth: screenWidth,
          ),
          body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                checkInternet.hasConnection();
                blogApi.fetchBlogs();
                astrologersApi.fetchAstrologers();
                astrologersApi.fetchLiveAstrologers("");
                profileApi.fetchProfile();
                rechargeListApi.fetchUserWallet();
                rechargeListApi.fetchRechargeList();
                await profileApi.fetchProfile();
              },
              child: _pages[_selectedIndex]),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
          floatingActionButton: Obx(() {
            if (profileApi.isLoading.value || astrologersApi.isLoading.value) {
              return SizedBox.shrink();
            }

            if (astrologersApi.activeSessionData.value != null &&
                astrologersApi.activeSessionData.value.data != null &&
                astrologersApi.activeSessionData.value.data!.type == 'chat') {
              return ActiveSessionFAB(
                session: astrologersApi.activeSessionData
                    .value, // Replace with your ActiveSessionModel instance
              );
            } else {
              return SizedBox.shrink();
            }
          })),
    );
  }
}

///23.6

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Icon paths
  final List<String> icons = [
    ImageConstant.homeInactiveIcon,
    ImageConstant.chatIconNav,
    ImageConstant.liveInactive,
    ImageConstant.callIcon,
    ImageConstant.profileIcon,
  ];

  final List<String> activeIcons = [
    ImageConstant.homeIcon,
    ImageConstant.chatActive,
    ImageConstant.liveRed,
    ImageConstant.callActiveIcon,
    ImageConstant.profileActiveIcon,
  ];

  final List<String> labels = [
    'Home',
    'Chat',
    'Live',
    'Call',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFC62828),
      unselectedItemColor: Color(0xFFC62828),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
      showUnselectedLabels: true,
      items: List.generate(icons.length, (index) {
        return BottomNavigationBarItem(
          icon: Image.asset(
            icons[index],
            width: 18,
            height: 18,
            color: Color(0xFFC62828), // tint for inactive
          ),
          activeIcon: Image.asset(
            activeIcons[index],
            width: 18,
            height: 18,
            color: Color(0xFFC62828),
          ),
          label: labels[index],
        );
      }),
    );
  }
}

class AnimatedNotchIcon extends StatefulWidget {
  final String icon;
  final String label;
  final bool isSelected;

  const AnimatedNotchIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  _AnimatedNotchIconState createState() => _AnimatedNotchIconState();
}

class _AnimatedNotchIconState extends State<AnimatedNotchIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _notchAnimation;
  late Animation<double> _iconOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _notchAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _iconOffsetAnimation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedNotchIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.icon.toString(),
              color: Colors.white,
              height: 20,
              width: 20,
              // size: 24,
            ),
          ],
        );
      },
    );
  }
}
