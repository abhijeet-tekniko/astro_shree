import 'dart:io';

import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/data/api_call/profile_api.dart';
import 'package:astro_shree_user/widget/custom_InputTextField.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_Text_button.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../core/network/no_internet_page.dart';
import '../../core/utils/file_picker/file_extensions.dart';
import '../../core/utils/file_picker/file_picker.dart';
import '../../core/utils/navigator_service.dart';
import '../../data/api_call/member_controller.dart';
import '../../routes/app_routes.dart';
import '../../widget/custom_buttons/custom_loading.dart';
import '../home_screen/home_screen.dart';

class NewSignUpScreen extends StatefulWidget {
  const NewSignUpScreen({super.key});

  @override
  State<NewSignUpScreen> createState() => _NewSignUpScreenState();
}

class _NewSignUpScreenState extends State<NewSignUpScreen> {
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final ProfileApi profileApi = Get.put(ProfileApi());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController timeOfBirthController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedMaritalStatus;
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    checkInternet.hasConnection();
    profileApi.fetchProfile().then((_) {
      final user = profileApi.userProfile.value;
      if (user != null) {
        nameController.text = user.name;
        mobileNumberController.text = user.mobile;
        emailController.text = user.email;
        dateOfBirthController.text = user.dateOfBirth;
        timeOfBirthController.text = user.timeOfBirth;
        placeOfBirthController.text = user.placeOfBirth;
        // _selectedGender = user.gender;
        // _selectedMaritalStatus = user.maritalStatus;
      }
    });
  }

  final memberController = Get.put(MemberController());

  Future<bool> _onWillPop() async {
    // Navigate to home screen when back button is pressed
    NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
    return false; // Prevent default back action
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (profileApi.isLoading.value) {
            return Center(child: CustomLoadingScreen());
          }
          if (profileApi.isUpdating.value) {
            return Center(child: CustomLoadingScreen());
          }
          if (checkInternet.noInternet.value) {
            return Center(child: NoInternetPage(onRetry: loadData));
          }
          return Form(
            key: _formKey,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgLoginBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     SizedBox(height: screenHeight * 0.15),
                      //     TextButton(
                      //       onPressed: () {
                      //         // Navigate to home screen when "Skip" is pressed
                      //         NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
                      //         // Get.offAll(() => HomeScreen());
                      //       },
                      //       style: TextButton.styleFrom(
                      //         backgroundColor: Colors.transparent,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(15.0),
                      //           side: BorderSide(color: Colors.grey),
                      //         ),
                      //       ),
                      //       child: Text(
                      //         'Skip',
                      //         style: TextStyle(color: const Color(0xFFC62828), fontSize: screenWidth * 0.04),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: screenHeight * 0.1),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10, top: 0),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Use ClipOval to make sure the image fills the whole circle
                            ClipOval(
                              child: Container(
                                width: screenHeight * 0.12, // Ensuring a fixed size for the circle
                                height: screenHeight * 0.12,
                                child: selectedImageFile != null
                                    ? Image.file(
                                  File(selectedImageFile!.path),
                                  fit: BoxFit.cover, // Ensures the image covers the entire space
                                )
                                    : CustomImageView(
                                  fit: BoxFit.cover,
                                  radius: BorderRadius.circular(screenHeight * 0.06),
                                  imagePath: profileApi.userProfile.value?.profileImage != ''
                                      ? profileApi.userProfile.value?.profileImage
                                      : ImageConstant.tempProfileImg,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                width: screenWidth * 0.09,
                                height: screenWidth * 0.09,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC62828),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final file = await FilePickerHelper.pickFile(
                                      allowedExtensions: FileExtensions.imageExtensions,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedImageFile = file;
                                      });
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10, top: 0),
                      //   child: Stack(
                      //     alignment: Alignment.bottomRight,
                      //     children: [
                      //       CircleAvatar(
                      //         radius: screenHeight * 0.06,
                      //         child: selectedImageFile != null
                      //             ? Image.file(
                      //           File(selectedImageFile!.path),
                      //           height: screenHeight * 0.08,
                      //           width: screenWidth,
                      //           fit: BoxFit.cover,
                      //         )
                      //             : CustomImageView(
                      //           fit: BoxFit.cover,
                      //           radius: BorderRadius.circular(screenHeight * 0.06),
                      //           imagePath: profileApi.userProfile.value?.profileImage != ''
                      //               ? profileApi.userProfile.value?.profileImage
                      //               : ImageConstant.tempProfileImg,
                      //         ),
                      //       ),
                      //       Positioned(
                      //         child: Container(
                      //           width: screenWidth * 0.09,
                      //           height: screenWidth * 0.09,
                      //           decoration: BoxDecoration(
                      //             color: const Color(0xFFC62828),
                      //             shape: BoxShape.circle,
                      //           ),
                      //           child: IconButton(
                      //             icon: Icon(
                      //               Icons.camera_alt_outlined,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () async {
                      //               final file = await FilePickerHelper.pickFile(
                      //                 allowedExtensions: FileExtensions.imageExtensions,
                      //               );
                      //               if (file != null) {
                      //                 setState(() {
                      //                   selectedImageFile = file;
                      //                 });
                      //               }
                      //             },
                      //             padding: EdgeInsets.zero,
                      //             constraints: BoxConstraints(),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: screenHeight * 0.02),
                      inputTextFields(
                        title: "Name",
                        textEditingController: nameController,
                        val: (val) => val == null || val.isEmpty ? "Name is required" : null,
                      ),
                      inputTextFields(
                        title: "Mobile Number",
                        textEditingController: mobileNumberController,
                        inputType: TextInputType.phone,
                        maxLength: 10,
                      ),
                      inputTextFields(
                        title: "Email ID",
                        textEditingController: emailController,
                        inputType: TextInputType.emailAddress,
                        val: (val) {
                          if (val == null || val.isEmpty) return "Email is required";
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          return !emailRegex.hasMatch(val) ? "Enter a valid email" : null;
                        },
                      ),
                      genderDropdownField(
                        selectedGender: _selectedGender,
                        items: ['Male', 'Female', 'Other'],
                        title: "Gender",
                        hintText: "Select Gender",
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) => value == null ? "Please select a gender" : null,
                      ),
                      inputTextFields(
                        title: "Date Of Birth",
                        hintText: "DD/MM/YYYY",
                        textEditingController: dateOfBirthController,
                        readOnly: true,
                        suffix: Icon(Icons.calendar_today, size: 20),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                            dateOfBirthController.text = formattedDate;
                          }
                        },
                        val: (val) {
                          if (val == null || val.isEmpty) return "DOB is required";
                          final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                          if (!regex.hasMatch(val)) return "Enter date in DD/MM/YYYY format";
                          return null;
                        },
                      ),
                      inputTextFields(
                        title: "Time Of Birth",
                        hintText: "HH:mm",
                        textEditingController: timeOfBirthController,
                        readOnly: true,
                        suffix: Icon(Icons.access_time, size: 20),
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            final formattedTime = pickedTime.format(context);
                            // Convert to 24-hour format if needed:
                            final now = DateTime.now();
                            final time = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            final formatted24Hr = DateFormat('HH:mm').format(time);
                            timeOfBirthController.text = formatted24Hr;
                          }
                        },
                      ),
                      inputTextFields(
                        title: "Place Of Birth",
                        textEditingController: placeOfBirthController,
                      ),
                      genderDropdownField(
                        selectedGender: _selectedMaritalStatus,
                        items: ['Single', 'Married', 'Others'],
                        title: "Marital Status",
                        hintText: "Select Marital Status",
                        onChanged: (value) {
                          setState(() {
                            _selectedMaritalStatus = value;
                          });
                        },
                        validator: (value) => value == null ? "Please select marital status" : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextButton(
                          text: "Save",
                          textColor: Colors.white,
                          color: const Color(0xFFC62828),
                          height: screenHeight * 0.05,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final success = await profileApi.updateProfile(
                                name: nameController.text,
                                email: emailController.text,
                                dob: formatDate(dateOfBirthController.text),
                                gender: _selectedGender == 'Male'
                                    ? 'male'
                                    : _selectedGender == 'Female'
                                    ? 'female'
                                    : 'other',
                                mobile: mobileNumberController.text,
                                birthTime: formatTime(timeOfBirthController.text),
                                placeOfBirth: placeOfBirthController.text,
                                profileImageFile: selectedImageFile,
                                status: _selectedMaritalStatus ?? 'Others',
                              );
                              if (success) {
                                await memberController.createMember(name: nameController.text, gender:  _selectedGender == 'Male'
                                    ? 'male'
                                    : _selectedGender == 'Female'
                                    ? 'female'
                                    : 'other', dob: formatDate(dateOfBirthController.text), birthTime: formatTime(timeOfBirthController.text), placeOfBirth:placeOfBirthController.text);
                                NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  String formatDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      }
    } catch (_) {}
    return input;
  }

  String formatTime(String input) {
    return input;
  }
  Widget genderDropdownField({
    required String? selectedGender,
    required Function(String?) onChanged,
    required String title,
    required String hintText,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedGender,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 12.0,
            ),
          ),
          items: items
              .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
              .toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}