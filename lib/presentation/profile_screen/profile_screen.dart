import 'dart:io';

import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/data/api_call/profile_api.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
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
import '../../widget/custom_buttons/custom_loading.dart';
import '../home_screen/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isHome;
  const ProfileScreen({super.key, this.isHome = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  bool? home;
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadData();
      },
    );
    if (widget.isHome != null) {
      setState(() {
        home = widget.isHome;
      });
    } else {
      setState(() {
        home = false;
      });
    }
  }

  void loadData() async {
    checkInternet.hasConnection();
    profileApi.fetchProfile().then((_) {
      final user = profileApi.userProfile.value;
      if (user != null) {
        nameController.text = user.name;
        mobileNumberController.text = user.mobile;
        emailController.text = user.email;
        dateOfBirthController.text = user.dateOfBirth.isNotEmpty
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user.dateOfBirth))
            : '';
        timeOfBirthController.text = user.timeOfBirth;
        placeOfBirthController.text = user.placeOfBirth;

        _selectedGender = user.gender.toLowerCase() == 'male'
            ? 'Male'
            : user.gender.toLowerCase() == 'female'
                ? 'Female'
                : 'Other';

        _selectedMaritalStatus = user.maritalStatus.isNotEmpty
            ? user.maritalStatus[0].toUpperCase() +
                user.maritalStatus.substring(1).toLowerCase()
            : null;
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (home == false) {
      Get.offAll(() => HomeScreen());
    } else {
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: home!
            ? AppBar(
                leading: CustomNavigationButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.white,
                iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
                title: AppbarTitle(
                  text: 'Profile',
                  margin: EdgeInsets.only(left: screenWidth * 0.2),
                ),
              )
            : AppBar(backgroundColor: Colors.transparent, toolbarHeight: 5),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            if (home == true) {
              loadData();
            }
          },
          child: Obx(() {
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
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // The CircleAvatar wrapped with ClipOval for smooth clipping
                          ClipOval(
                            child: Container(
                              width: screenHeight * 0.12, // Ensures a uniform size for the circle
                              height: screenHeight * 0.12,
                              child: selectedImageFile != null
                                  ? Image.file(
                                selectedImageFile!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover, // Ensures the image covers the entire container
                              )
                                  : CustomImageView(
                                imagePath: profileApi.userProfile.value?.profileImage != ''
                                    ? profileApi.userProfile.value!.profileImage
                                    : ImageConstant.tempProfileImg,
                                fit: BoxFit.cover,
                                height: screenHeight * 0.12,
                              ),
                            ),
                          ),
                          // Positioned Camera Icon for selecting a new image
                          Positioned(
                            bottom: 0,
                            right: 0,
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
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  inputTextFields(
                    title: "Name",
                    textEditingController: nameController,
                    val: (val) =>
                        val == null || val.isEmpty ? "Name is required" : null,
                  ),
                  inputTextFields(
                    title: "Mobile Number",
                    textEditingController: mobileNumberController,
                    inputType: TextInputType.phone,
                    maxLength: 10,
                    readOnly: true,
                  ),
                  inputTextFields(
                    title: "Email ID",
                    textEditingController: emailController,
                    inputType: TextInputType.emailAddress,
                    val: (val) {
                      if (val == null || val.isEmpty)
                        return "Email is required";
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      return !emailRegex.hasMatch(val)
                          ? "Enter a valid email"
                          : null;
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
                    validator: (value) =>
                        value == null ? "Please select a gender" : null,
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
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        dateOfBirthController.text = formattedDate;
                      }
                    },
                    val: (val) {
                      if (val == null || val.isEmpty) return "DOB is required";
                      final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                      if (!regex.hasMatch(val))
                        return "Enter date in DD/MM/YYYY format";
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
                        final formattedTime =
                            pickedTime.format(context); // e.g., "6:24 PM"
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
                    validator: (value) =>
                        value == null ? "Please select marital status" : null,
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
                            // NavigatorService.pop(); // Or Get.back();
                            print('true');
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            );
          }),
        ),
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
              .map(
                (gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)),
              )
              .toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
