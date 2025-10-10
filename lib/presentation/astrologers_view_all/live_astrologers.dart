
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/themes/textStyle.dart';
import '../../data/api_call/astrologers_api.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/model/get_live_astro_model.dart';
import '../../widget/custom_buttons/custom_loading.dart';
import '../../widget/homepagewidgets/live_astrologers_card.dart';
import '../home_screen/home_screen.dart';
import '../live_screen/user_live_attend_screen.dart';
import '../live_screen/watch_live.dart';

// class LiveAstrologers extends StatefulWidget {
//   const LiveAstrologers({super.key});
//
//   @override
//   State<LiveAstrologers> createState() => _LiveAstrologersState();
// }
//
// class _LiveAstrologersState extends State<LiveAstrologers> {
//   bool isLoading = true;
//
//   Future<bool> _onWillPop() async {
//     Get.offAll(() => HomeScreen());
//     return false;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loading();
//   }
//
//   final AstrologersApi astrologersApi = Get.put(AstrologersApi());
//
//   loading() async {
//     await Future.delayed(Duration(milliseconds: 2000));
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         // appBar: AppBar(
//         //   title: Text('Live Astrologers'),
//         //   centerTitle: true,
//         //   leading: CustomNavigationButton(
//         //     onPressed: () {
//         //       Navigator.pop(context);
//         //     },
//         //   ),
//         //   backgroundColor: Colors.white,
//         //   iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
//         // ),
//         backgroundColor: Colors.white,
//         body:
//             isLoading
//                 ? Center(child: CustomLoadingScreen())
//                 : liveAstroWidget()
//                 // : Center(child: Text('No Live Astrologer'),)
//       ),
//     );
//   }
//
//   Widget liveAstroWidget(){
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.all(screenWidth * 0.04),
//       child: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 'Live Vedic Astrologers',
//                 style: TextStyles.headline4,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 5),
//                 height: screenHeight * 0.22,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return LiveFullScreenCard(
//                       imageUrl: "assets/images/liveastroImage2.png",
//                       title: "Param",
//                       subtitle: "Vedic Astrology",
//                       isLive: true,
//                       onPressed: () {
//                         Get.to(() => WatchLiveScreen(id: 1));
//                       },
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 'Live Tarot Astrologers',
//                 style: TextStyles.headline4,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 1),
//                 height: screenHeight * 0.22,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return LiveFullScreenCard(
//                       imageUrl: "assets/images/liveastroImage1.png",
//                       title: "Param",
//                       subtitle: "Vedic Astrology",
//                       isLive: true,
//                       onPressed: () {
//                         Get.to(() => WatchLiveScreen(id: 1));
//                       },
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 'Live Face Reading Astrologers',
//                 style: TextStyles.headline4,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 5),
//                 height: screenHeight * 0.22,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return LiveFullScreenCard(
//                       imageUrl: "assets/images/liveastroImage2.png",
//                       title: "Param",
//                       subtitle: "Vedic Astrology",
//                       isLive: true,
//                       onPressed: () {
//                         Get.to(() => WatchLiveScreen(id: 1));
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


///


class AstrologerListScreen extends StatefulWidget {
  @override
  _AstrologerListScreenState createState() => _AstrologerListScreenState();
}

class _AstrologerListScreenState extends State<AstrologerListScreen> {
  final List<String> specialities = [
    'All',
    'Love',
    'Career',
    'Health',
    'Marriage',
    'Wealth',
    'Spiritual',
  ];

  String selectedSpeciality = 'All';

  final String imageUrl =
      'https://media.istockphoto.com/id/1347480695/photo/beard-priest-holy-astrologer-guru-or-jyotishi-placing-cowrie-shells-on-chart-and-counting-to.jpg?s=612x612&w=0&k=20&c=Fa0mG3pfB7X_odMXwU4rM0lyyVFIradeKZjgmo3sd0Y=';

  final List<Astrologer> allAstrologers = [
    Astrologer(name: 'Astro Neha', speciality: 'Love'),
    Astrologer(name: 'Guru Raj', speciality: 'Career'),
    Astrologer(name: 'Swami Om', speciality: 'Health'),
    Astrologer(name: 'Pandit Ramesh', speciality: 'Love'),
    Astrologer(name: 'Astro Kiran', speciality: 'Marriage'),
    Astrologer(name: 'Astro Jyoti', speciality: 'Spiritual'),
    Astrologer(name: 'Yogi Aadesh', speciality: 'Wealth'),
  ];

  final AstrologersApi astrologersApi = Get.put(AstrologersApi());
  final ProfileApi profileApi = Get.put(ProfileApi());

  @override
  void initState() {
    astrologersApi.fetchLiveAstrologers("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Astrologer> filteredAstrologers = selectedSpeciality == 'All'
        ? allAstrologers
        : allAstrologers
        .where((a) => a.speciality == selectedSpeciality)
        .toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Live Astrologers'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSpecialityTabs(),
          Expanded(child: _buildAstrologerGrid(filteredAstrologers)),
        ],
      ),
    );
  }

  Widget _buildSpecialityTabs() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // itemCount: specialities.length,
        itemCount: astrologersApi.specialities.length,
        itemBuilder: (context, index) {
          final speciality = astrologersApi.specialities[index];
          // final speciality = specialities[index];
          // final isSelected = speciality == selectedSpeciality;
          final isSelected = astrologersApi.selectedSpecialityId == (speciality.sId ?? '');
          return GestureDetector(
            onTap: () {
              setState(() {
                astrologersApi.selectedSpecialityId = speciality.sId ?? '';
                astrologersApi.fetchLiveAstrologers(astrologersApi.selectedSpecialityId);
                // selectedSpeciality = speciality;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey.shade200,

                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey.shade200,

                ),
              ),
              child: Center(
                child: Text(
                  speciality.name?.capitalizeFirst ?? '',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAstrologerGrid(List<Astrologer> astrologers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child:/* astrologersApi.isLoading.value?Center(child: CircularProgressIndicator()):*/GridView.builder(
        itemCount: astrologersApi.astrologerLiveList.value!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two per row
          childAspectRatio: 0.97,
          crossAxisSpacing: 12,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final astrologer = astrologersApi.astrologerLiveList.value![index];
          // return _buildAstrologerCard(astrologer);
          return liveAstroWidget(astrologer);
        },
      ),
    );
  }

  Widget liveAstroWidget(LiveAstrologerListData livAstro){
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(0),
      child:LiveFullScreenCard(
        imageUrl: (EndPoints.imageBaseUrl+livAstro.profileImage.toString())??"assets/images/liveastroImage2.png",
        title: livAstro.name?.capitalizeFirst??"Param",
        subtitle: livAstro.specialities?.first.name?.capitalizeFirst??"Vedic Astrology",
        isLive: true,
        onPressed: () {
          Get.to(() => UserLiveScreen(userId: profileApi.userProfile.value!.id.toString(), liveSessionId: livAstro.liveSession!.liveSessionId.toString(), astroId: livAstro.astrologerId.toString(),));

          // Get.to(() => WatchLiveScreen(id: 1));
        },
      ),
    );
  }

  Widget _buildAstrologerCard(Astrologer astrologer) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              astrologer.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              astrologer.speciality,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 2),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.red,
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //     ),
          //     onPressed: () {
          //       // Action
          //     },
          //     child: const Text('Consult Now'),
          //   ),
          // )
        ],
      ),
    );
  }

}

class Astrologer {
  final String name;
  final String speciality;

  Astrologer({
    required this.name,
    required this.speciality,
  });
}
