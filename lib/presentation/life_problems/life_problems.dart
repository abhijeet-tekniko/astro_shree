import 'package:astro_shree_user/widget/homepagewidgets/astrologers_full_screen_card.dart';
import 'package:flutter/material.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

class LifeProblems extends StatefulWidget {
  final int initialIndex;
  const LifeProblems({super.key, required this.initialIndex});

  @override
  State<LifeProblems> createState() => _LifeProblemsState();
}

class _LifeProblemsState extends State<LifeProblems>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final titles = ['Health', 'Love', 'Marriage', 'Business', 'Job'];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
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
      appBar: AppBar(
        title:
            widget.initialIndex == 0
                ? Text(titles[widget.initialIndex])
                : widget.initialIndex == 1
                ? Text(titles[widget.initialIndex])
                : widget.initialIndex == 2
                ? Text(titles[widget.initialIndex])
                : widget.initialIndex == 3
                ? Text(titles[widget.initialIndex])
                : Text(titles[4]),
        centerTitle: true,
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.red,
                  dividerColor: Colors.white,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(),
                  tabs: List.generate(5, (index) {
                    final image = [
                      ImageConstant.healthIcon,
                      ImageConstant.loveIcon,
                      ImageConstant.marriageIcon,
                      ImageConstant.businessIcon,
                      ImageConstant.jobIcon,
                    ];

                    return Tab(
                      child: AnimatedBuilder(
                        animation: _tabController.animation!,
                        builder: (context, child) {
                          final selected = _tabController.index == index;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: selected ? Colors.red : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  image[index],
                                  width: 16,
                                  height: 16,
                                  color: selected ? Colors.red : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                    color: selected ? Colors.red : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: screenHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent("Health"),
                    _buildTabContent("Love"),
                    _buildTabContent("Marriage"),
                    _buildTabContent("Business"),
                    _buildTabContent("Job"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String tabType) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: AstrologersListScreenCard(
            imageUrl: ImageConstant.astrologerImage1,
            name: "Astro Neetu",
            position: "Vedic Astrology",
            language: "Hindi/English",
            charge: "₹15/min",
            status: index % 2 == 0 ? "online" : "online",
            isPopular: index % 3 == 0 ? true : false,
            onPressed: () {},
          ),
        );
      },
    );
  }
}
