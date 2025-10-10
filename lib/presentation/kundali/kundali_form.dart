import 'dart:convert';
import 'dart:developer';
import 'package:astro_shree_user/data/api_call/language_controller.dart';
import 'package:http/http.dart' as http;
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/kundali_matching_controller.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

import 'package:uuid/uuid.dart';

class KundaliMatchingForm extends StatefulWidget {
  const KundaliMatchingForm({super.key});

  @override
  State<KundaliMatchingForm> createState() => _KundaliMatchingFormState();
}

class _KundaliMatchingFormState extends State<KundaliMatchingForm> {
  final kundaliMatchingController = Get.put(KundaliMatchingController());
  final TextEditingController bNameController = TextEditingController();
  final TextEditingController gNameController = TextEditingController();
  final TextEditingController bDobController = TextEditingController();
  final TextEditingController gDobController = TextEditingController();
  final TextEditingController bTobController = TextEditingController();
  final TextEditingController gTobController = TextEditingController();
  final TextEditingController bPobController = TextEditingController();
  final TextEditingController gPobController = TextEditingController();

  final languageController = Get.put(LanguageController());

  String convertDate(String inputDate) {
    DateTime parsedDate = DateFormat('dd MMM yyyy').parse(inputDate);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String convertTime(String inputTime) {
    // Normalize non-breaking spaces and other Unicode issues
    String cleaned = inputTime
        .replaceAll(
            '\u202F', ' ') // Replace narrow no-break space with normal space
        .replaceAll('\u00A0', ' ') // Replace normal no-break space
        .replaceAll(RegExp(r'\s+'), ' ') // Collapse multiple spaces
        .trim();

    // Now parse
    DateTime parsedTime = DateFormat('hh:mm a').parse(cleaned);
    return DateFormat('HH:mm').format(parsedTime);
  }

  double? _latitude;
  double? _longitude;
  List<dynamic> _placeBSuggestions = [];
  List<dynamic> _placeGSuggestions = [];
  String _sessionToken = const Uuid().v4();
  bool _isBLoading = false;
  bool _isGLoading = false;

  Future<void> _fetchBoyPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeBSuggestions = [];
      });
      return;
    }

    setState(() {
      _isBLoading = true;
    });

    const String apiKey = 'HrQKnSjkagYwVI0irBhstY7KWRhhyRHNjoX0yutE';
    const String baseUrl = 'https://api.olamaps.io/places/v1/autocomplete';
    final String encodedInput = Uri.encodeComponent(input);
    final String request =
        '$baseUrl?input=$encodedInput&api_key=$apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placeBSuggestions = data['predictions'] ?? [];
          _isBLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load place suggestions: Status ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isBLoading = false;
      });
      log('Error fetching places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching places: $e')),
      );
    }
  }

  Future<void> _selectBoyPlace(dynamic place) async {
    setState(() {
      bPobController.text = place['description'] ?? '';
      _placeBSuggestions = [];
      _latitude = place['geometry']?['location']?['lat']?.toDouble();
      _longitude = place['geometry']?['location']?['lng']?.toDouble();

      log('latiiii$_latitude');
      log('latiiii$_longitude');
    });
  }

  Future<void> _fetchGirlPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeGSuggestions = [];
      });
      return;
    }

    setState(() {
      _isGLoading = true;
    });

    const String apiKey = 'HrQKnSjkagYwVI0irBhstY7KWRhhyRHNjoX0yutE';
    const String baseUrl = 'https://api.olamaps.io/places/v1/autocomplete';
    final String encodedInput = Uri.encodeComponent(input);
    final String request =
        '$baseUrl?input=$encodedInput&api_key=$apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placeGSuggestions = data['predictions'] ?? [];
          _isGLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load place suggestions: Status ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isGLoading = false;
      });
      log('Error fetching places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching places: $e')),
      );
    }
  }

  Future<void> _selectGirlPlace(dynamic place) async {
    setState(() {
      gPobController.text = place['description'] ?? '';
      _placeGSuggestions = [];
      _latitude = place['geometry']?['location']?['lat']?.toDouble();
      _longitude = place['geometry']?['location']?['lng']?.toDouble();

      log('latiiii$_latitude');
      log('latiiii$_longitude');
    });
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
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: AppbarTitle(
          text: 'Kundli',
          margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "Boy's Details",
                        style: TextStyles.bodyText2,
                      )),
                      KundliCustomTextInput(
                        label: 'Name',
                        hintText: 'Enter Boy Name',
                        prefixIcon: CupertinoIcons.person,
                        controller: bNameController,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Date',
                        hintText: 'Boy Birth Date',
                        prefixIcon: CupertinoIcons.calendar_today,
                        controller: bDobController,
                        enablePicker: true,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Time',
                        hintText: 'Boy Birth Time',
                        prefixIcon: CupertinoIcons.clock,
                        controller: bTobController,
                        enablePicker: true,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Location',
                        hintText: 'Boy Birth Location',
                        prefixIcon: Icons.location_on_outlined,
                        controller: bPobController,
                        onChanged: _fetchBoyPlaceSuggestions,
                      ),
                      if (_isBLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(),
                        ),
                      if (_placeBSuggestions.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _placeBSuggestions.length,
                            itemBuilder: (context, index) {
                              final place = _placeBSuggestions[index];
                              log('checkkkkkkk=======$place');
                              return ListTile(
                                title: Text(
                                    place['description'] ?? 'Unknown Place'),
                                onTap: () => _selectBoyPlace(place),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Center(
                          child: Text("Girl's Details",
                              style: TextStyles.bodyText2)),
                      KundliCustomTextInput(
                        label: 'Name',
                        hintText: 'Enter Girl Name',
                        prefixIcon: CupertinoIcons.person,
                        controller: gNameController,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Date',
                        hintText: 'Girl Birth Date',
                        prefixIcon: CupertinoIcons.calendar_today,
                        controller: gDobController,
                        enablePicker: true,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Time',
                        hintText: 'Girl Birth Time',
                        prefixIcon: CupertinoIcons.clock,
                        controller: gTobController,
                        enablePicker: true,
                      ),
                      SizedBox(height: 10),
                      KundliCustomTextInput(
                        label: 'Birth Location',
                        hintText: 'Birth Location',
                        prefixIcon: Icons.location_on_outlined,
                        controller: gPobController,
                        onChanged: _fetchGirlPlaceSuggestions,
                      ),
                      if (_isGLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(),
                        ),
                      if (_placeGSuggestions.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _placeGSuggestions.length,
                            itemBuilder: (context, index) {
                              final place = _placeGSuggestions[index];
                              log('checkkkkkkk=======$place');
                              return ListTile(
                                title: Text(
                                    place['description'] ?? 'Unknown Place'),
                                onTap: () => _selectGirlPlace(place),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ElevatedButton(
              onPressed: kundaliMatchingController.isButtonLoading.value
                  ? () {}
                  : () {
                      bool validateInputs(BuildContext context) {
                        if (bNameController.text.isEmpty) {
                          showSnackBar(context, 'Please enter male name');
                          return false;
                        }
                        if (bDobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter male date of birth');
                          return false;
                        }
                        if (bTobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter male time of birth');
                          return false;
                        }
                        if (bPobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter male place of birth');
                          return false;
                        }
                        if (gNameController.text.isEmpty) {
                          showSnackBar(context, 'Please enter female name');
                          return false;
                        }
                        if (gDobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter female date of birth');
                          return false;
                        }
                        if (gTobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter female time of birth');
                          return false;
                        }
                        if (gPobController.text.isEmpty) {
                          showSnackBar(
                              context, 'Please enter female place of birth');
                          return false;
                        }

                        return true;
                      }

                      if (validateInputs(context)) {
                        final Map<String, dynamic> data = {
                          "maleDetails": {
                            "name": bNameController.text,
                            "dob": bDobController.text,
                            "tob": convertTime(bTobController.text),
                            "place": bPobController.text,
                            "latitude": 23.6833,
                            "longitude": 86.9833,
                            "timezone": 5.5,
                            "gender": "male"
                          },
                          "femaleDetails": {
                            "name": gNameController.text,
                            "dob": gDobController.text,
                            "tob": convertTime(gTobController.text),
                            "place": gPobController.text,
                            "latitude": 22.5726,
                            "longitude": 88.3639,
                            "timezone": 5.5,
                            "gender": "female"
                          },
                          "language": languageController.selectedLanguage.value,
                        };
                        kundaliMatchingController.getKundliMatching(data);
                      }
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: kundaliMatchingController.isButtonLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text('Show Kundli', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class KundliCustomTextInput extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool enablePicker;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const KundliCustomTextInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.onChanged,
    this.validator,
    this.enablePicker = false,
  });

  @override
  State<KundliCustomTextInput> createState() => _KundliCustomTextInputState();
}

class _KundliCustomTextInputState extends State<KundliCustomTextInput> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // widget.controller.text = DateFormat('dd MMM yyyy').format(picked);
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      print('call date birth ====>${widget.controller.text}');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      widget.controller.text = DateFormat.jm().format(dt);
      print('call time birth ====>${widget.controller.text}');
    }
  }

  void _handleTap() {
    if (!widget.enablePicker) return;

    if (widget.prefixIcon == CupertinoIcons.calendar_today) {
      _selectDate(context);
    } else if (widget.prefixIcon == CupertinoIcons.clock) {
      _selectTime(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          readOnly: widget.enablePicker,
          onTap: _handleTap,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Container(
              padding: const EdgeInsets.only(right: 4),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: Icon(widget.prefixIcon),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}

///dropDown
class KundliCustomDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const KundliCustomDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Container(
              padding: const EdgeInsets.only(right: 4),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: Icon(prefixIcon),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
