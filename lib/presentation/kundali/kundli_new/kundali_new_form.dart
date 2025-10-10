import 'dart:developer';

import 'package:astro_shree_user/data/api_call/language_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../data/api_call/member_controller.dart';
import '../../../data/model/get_kundali_member_model.dart';
import '../../../widget/app_bar/appbar_title.dart';
import '../../../widget/app_bar/custom_navigate_back_button.dart';
import '../kundali_form.dart';
import 'get_kundali_api.dart';

class KundliFormScreen extends StatefulWidget {
  const KundliFormScreen({super.key});

  @override
  State<KundliFormScreen> createState() => _KundliFormScreenState();
}

class _KundliFormScreenState extends State<KundliFormScreen> {
  final GetKundliApi kundliController = Get.put(GetKundliApi());
  final MemberController kundliMemberController = Get.put(MemberController());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _tobController = TextEditingController();
  final _placeController = TextEditingController();
  final _timezoneController = TextEditingController(text: '5.5');
  String _gender = 'Male';
  String _language = 'en';
  double? _latitude;
  double? _longitude;
  List<dynamic> _placeSuggestions = [];
  String _sessionToken = const Uuid().v4();
  bool _isLoading = false;




  ///googleSearch
  final Dio _dio = Dio();

  // Future<void> _fetchGooglePlaceSuggestions(String input) async {
  //   if (input.isEmpty) {
  //     _placeSuggestions = [];
  //     return;
  //   }
  //
  //   _isLoading = true;
  //
  //   const String apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';
  //   const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //
  //   try {
  //     final response = await _dio.get(baseUrl, queryParameters: {
  //       'input': input,
  //       'key': apiKey,
  //       // 'sessiontoken': _sessionToken,
  //       'types': '(cities)', // Optional: filter to cities
  //       'language': 'en',    // Optional: language
  //     });
  //
  //
  //     print('responseGooglr$response');
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //       _placeSuggestions = data['predictions'] ?? [];
  //
  //       ///
  //       print('placeSuggetion$_placeSuggestions');
  //     } else {
  //       throw Exception('Failed to load suggestions: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Error fetching places: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching suggestions: $e')),
  //     );
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  Future<void> _fetchGooglePlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeSuggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'input': input,
        'key': apiKey,
        'types': '(cities)',
        'language': 'en',
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final suggestions = data['predictions'] ?? [];

        setState(() {
          _placeSuggestions = suggestions;
          _isLoading = false;
        });

      } else {
        throw Exception('Failed to load suggestions: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      log('Error fetching places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching suggestions: $e')),
      );
    }
  }

  final langController = Get.find<LanguageController>();
  ///googleSearch

  Future<void> _fetchPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeSuggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String apiKey =
        'HrQKnSjkagYwVI0irBhstY7KWRhhyRHNjoX0yutE';
    const String baseUrl = 'https://api.olamaps.io/places/v1/autocomplete';
    final String encodedInput = Uri.encodeComponent(input);
    final String request =
        '$baseUrl?input=$encodedInput&api_key=$apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placeSuggestions = data['predictions'] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load place suggestions: Status ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('Error fetching places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching places: $e')),
      );
    }
  }

  Future<void> _selectPlace(dynamic place, String placeDisplayText) async {
    final placeId = place['place_id'];

    const String apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';
    const String detailsBaseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';

    try {
      final response = await _dio.get(detailsBaseUrl, queryParameters: {
        'place_id': placeId,
        'key': apiKey,
      });

      if (response.statusCode == 200) {
        final result = response.data['result'];
        final geometry = result['geometry']['location'];

        setState(() {
          _placeController.text = placeDisplayText;
          _latitude = geometry['lat']?.toDouble();
          _longitude = geometry['lng']?.toDouble();
          _placeSuggestions = [];
        });

        log('Selected location: $_latitude, $_longitude');
      } else {
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      log('Error fetching place details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get place details')),
      );
    }
  }


  // Future<void> _selectPlace(dynamic place,String placeData) async {
  //   setState(() {
  //
  //     print('checkPlace Detail==================>$place');
  //     // _placeController.text = place['description'] ?? '';
  //     _placeController.text = placeData;
  //     _placeSuggestions = [];
  //     _latitude = place['geometry']?['location']?['lat']?.toDouble();
  //     _longitude = place['geometry']?['location']?['lng']?.toDouble();
  //
  //     log('latiiii$_latitude');
  //     log('latiiii$_longitude');
  //   });
  //
  // }

  Future<void> _fetchPlaceDetails(String placeId) async {
    const String apiKey = 'HrQKnSjkagYwVI0irBhstY7KWRhhyRHNjoX0yutE';
    const String baseUrl = 'https://api.olamaps.io/places/v1/details';
    final String request =
        '$baseUrl?placeid=$placeId&api_key=$apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _latitude =
              data['result']?['geometry']?['location']?['lat']?.toDouble();
          _longitude =
              data['result']?['geometry']?['location']?['lng']?.toDouble();
        });
      } else {
        log('Failed to fetch place details: Status ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Error fetching place details: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _tobController.text = picked.format(context);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a valid place with coordinates')),
        );
        return;
      }
      print('kundliDate====${_dobController.text}');
      print('kundliDate====${_tobController.text}');
      print('kundliDate====${_latitude}');
      print('kundliDate====${_longitude}');

      final timeOfBirth=convertTo24HourFormat(_tobController.text);


      final kundliData = {
        'name': _nameController.text,
        'dob': _dobController.text,
        'tob': timeOfBirth,
        'place': _placeController.text,
        'latitude': _latitude,
        'longitude': _longitude,
        'timezone': double.parse(_timezoneController.text),
        'gender': _gender.toLowerCase(),
        'language': _language,
      };
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Kundli Data Submitted!')),
      // );

      log('Kundli Data: $kundliData');
      _showLoadingPopup(context);

      kundliMemberController.createKundliMember(
          name: _nameController.text,
          dob: _dobController.text,
          // tob: _tobController.text,
          birthTime: timeOfBirth,
          placeOfBirth: _placeController.text,
          gender: _gender.toLowerCase()
      );

      kundliController.fetchKundli(
          name: _nameController.text,
          dob: _dobController.text,
          // tob: _tobController.text,
          tob: timeOfBirth,
          address: _placeController.text,
          gender: _gender.toLowerCase(),
          language: langController.selectedLanguage.value
      );
    }
    // kundliController.fetchKundli(
    //   name: "Animesh Singh",
    //   dob: "2000-04-11",
    //   tob: "10:30",
    //   address: "Asansol,west Bengol",
    // );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _tobController.dispose();
    _placeController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: AppbarTitle(
          text: 'Kundli Form',
          // margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KundliCustomTextInput(
                label: 'Name',
                hintText: 'Enter Your Name',
                prefixIcon: CupertinoIcons.person,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              KundliCustomTextInput(
                label: 'Birth Date',
                hintText: 'Enter Your Birth Date',
                prefixIcon: CupertinoIcons.calendar_today,
                controller: _dobController,
                enablePicker: true,
                // onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              KundliCustomTextInput(
                label: 'Birth Time',
                hintText: 'Enter Your Birth Time',
                prefixIcon: CupertinoIcons.clock,
                controller: _tobController,
                enablePicker: true,

              ),
              SizedBox(height: 10),
              KundliCustomTextInput(
                label: 'Birth Location',
                hintText: 'Enter Your Location',
                prefixIcon: Icons.location_on_outlined,
                controller: _placeController,
                // onChanged: _fetchPlaceSuggestions,
                onChanged: _fetchGooglePlaceSuggestions,
              ),

              ///
              // TextFormField(
              //   controller: _nameController,
              //   decoration: const InputDecoration(
              //     labelText: 'Name',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.person),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a name';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _dobController,
              //   decoration: const InputDecoration(
              //     labelText: 'Date of Birth (YYYY-MM-DD)',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.calendar_today),
              //   ),
              //   readOnly: true,
              //   onTap: _selectDate,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a date of birth';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _tobController,
              //   decoration: const InputDecoration(
              //     labelText: 'Time of Birth',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.access_time),
              //   ),
              //   readOnly: true,
              //   onTap: _selectTime,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a time of birth';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _placeController,
              //   decoration: const InputDecoration(
              //     labelText: 'Place of Birth',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.location_on),
              //     suffixIcon: Icon(Icons.search),
              //   ),
              //   onChanged: _fetchPlaceSuggestions,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a place';
              //     }
              //     return null;
              //   },
              // ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: LinearProgressIndicator(),
                ),
              if (_placeSuggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _placeSuggestions.length,
                    itemBuilder: (context, index) {
                      final place = _placeSuggestions[index];
                      log('checkkkkkkk=======$place');
                      log('chaeckCityTerms=======${place['terms']}');

                      final terms = (place['terms'] as List<dynamic>);
                      final displayText = terms.map((t) => t['value']).join(', ');

                      // final placeData=  (place['terms'] as List)
                      //     .map((term) => term['value'].toString().trim())
                      //     .firstWhere(
                      //       (value) {
                      //     // Reject values that are postal codes or contain digits only
                      //     if (RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) return false;
                      //
                      //     // Reject values that clearly aren't cities
                      //     final lower = value.toLowerCase();
                      //     return !lower.contains('sector') &&
                      //         !lower.contains('metro') &&
                      //         !lower.contains('road') &&
                      //         !lower.contains('marg') &&
                      //         !lower.contains('station') &&
                      //         !lower.contains('block') &&
                      //         !lower.contains('plot');
                      //   },
                      //   orElse: () => 'Unknown City',
                      // );

                      return ListTile(
                        title: Text(displayText),
                        onTap: () => _selectPlace(place, displayText),
                      );
                      // return ListTile(
                      //   // title: Text(place['description'] ?? 'Unknown Place'),
                      //
                      //   title: Text(
                      //       placeData,
                      //   ),
                      //
                      //
                      //   // title: Text(place['terms'][1]['value'] ?? 'Unknown Place'),
                      //   onTap: () => _selectPlace(place,placeData),
                      //   // onTap: (){
                      //   //   _placeController.text=placeData;
                      //   // },
                      // );
                    },
                  ),
                ),
              SizedBox(height: 10),
              KundliCustomDropdown(
                label: 'Gender',
                hintText: 'Select Gender',
                prefixIcon: Icons.person_outline,
                value: _gender,
                items: ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),

              // DropdownButtonFormField<String>(
              //   value: _gender,
              //   decoration: const InputDecoration(
              //     labelText: 'Gender',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.person_outline),
              //   ),
              //   items: ['Male', 'Female', 'Other']
              //       .map((gender) => DropdownMenuItem(
              //     value: gender,
              //     child: Text(gender),
              //   ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _gender = value!;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Please select a gender';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 34),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Submit Kundli',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLoadingPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text("Making your Kundli..."),
        ],
      ),
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

///kundli member


class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {



  final MemberController kundliMemberController = Get.put(MemberController());

  final GetKundliApi kundliController = Get.put(GetKundliApi());

  final langController = Get.find<LanguageController>();

  @override
  void initState() {
    kundliMemberController.fetchKundaliMembers();
    super.initState();
  }

  void _deleteMember(GetKundliMemberData member,int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      kundliMemberController.deleteKundaliMembers(id: member.sId.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member deleted')),
      );
    }
  }

  void _editMember(GetKundliMemberData member, int index) {


    // Navigate to the Kundli Form screen and pass the existing data
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => YourKundliFormScreen(
    //       initialData: member,
    //       onSave: (updatedData) {
    //         setState(() {
    //           members[index] = updatedData;
    //         });
    //       },
    //     ),
    //   ),
    // );
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
        centerTitle: true,
        backgroundColor: Colors.white,
        title: AppbarTitle(
          text: 'Saved Kundli'
              '',
          margin: EdgeInsets.only(left: screenWidth * 0.08),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.to(() => KundliFormScreen());
          }, icon: Icon(Icons.add))
        ],
      ),

      body:Obx(() =>kundliMemberController.isLoading.value?Center(child: CircularProgressIndicator(),): kundliMemberController.kundaliMemberList.isEmpty
          ? const Center(child: Text("No saved Kundlis."))
          : ListView.builder(
        itemCount: kundliMemberController.kundaliMemberList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final member = kundliMemberController.kundaliMemberList[index];
// Format date
          String formattedDOB = '';
          try {
            final date = DateTime.parse(member.dob ?? '');
            formattedDOB = DateFormat('dd MMM yyyy').format(date);
          } catch (_) {
            formattedDOB = member.dob ?? '';
          }

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _showLoadingPopup(context);
                kundliController.fetchKundli(
                  name: member.name?.capitalizeFirst ?? "",
                  dob: member.dob ?? "",
                  tob: member.birthTime ?? "",
                  address: member.placeOfBirth?.capitalizeFirst ?? "",
                  gender: member.gender?.toLowerCase() ?? "",
                  language: langController.selectedLanguage.value
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        (member.name?.isNotEmpty ?? false)
                            ? member.name![0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name?.capitalizeFirst ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.cake, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text('DOB: $formattedDOB'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text('Gender: ${member.gender?.capitalizeFirst ?? ""}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(child: Text(member.placeOfBirth?.capitalizeFirst ?? "")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editMember(member, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMember(member, index),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
          // return Card(
          //   elevation: 3,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12)),
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       radius: 24,
          //       backgroundColor: Colors.deepPurple.shade100,
          //       child: Text(
          //         member.name![0].toUpperCase(),
          //         style: const TextStyle(
          //             fontSize: 20, color: Colors.deepPurple),
          //       ),
          //     ),
          //     title: Text(
          //       member.name.toString().capitalizeFirst??"",
          //       style: const TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     subtitle: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const SizedBox(height: 4),
          //         Text('📅 DOB: ${member.dob.toString()}'),
          //         Text('👤 Gender: ${member.gender.toString().capitalizeFirst??""}'),
          //         Text('📍 ${member.placeOfBirth.toString().capitalizeFirst??""}'),
          //       ],
          //     ),
          //     trailing: Wrap(
          //       spacing: 8,
          //       children: [
          //         IconButton(
          //           icon: const Icon(Icons.edit, color: Colors.blue),
          //           onPressed: () => _editMember(member, index),
          //         ),
          //         IconButton(
          //           icon: const Icon(Icons.delete, color: Colors.red),
          //           onPressed: () => _deleteMember(member,index),
          //         ),
          //       ],
          //     ),
          //     onTap: (){
          //
          //       _showLoadingPopup(context);
          //       kundliController.fetchKundli(
          //           name:member.name.toString().capitalizeFirst??"",
          //           dob: member.dob.toString(),
          //           tob: member.birthTime.toString(),
          //           address: member.placeOfBirth.toString().capitalizeFirst??"",
          //           gender: member.gender.toString().toLowerCase()
          //       );
          //     },
          //   ),
          // );
        },
      ),),
    );
  }
}



///google search place


class PlaceSearchDioPage extends StatefulWidget {
  const PlaceSearchDioPage({super.key});

  @override
  _PlaceSearchDioPageState createState() => _PlaceSearchDioPageState();
}

class _PlaceSearchDioPageState extends State<PlaceSearchDioPage> {
  final String apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> searchPlace(String input) async {
    final Dio dio = Dio();

    final String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
    final Map<String, dynamic> queryParams = {
      'query': input,
      'key': apiKey,
    };

    try {
      final response = await dio.get(url, queryParameters: queryParams);
      final data = response.data;

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final firstResult = data['results'][0];
        setState(() {
          _result = '''
Name: ${firstResult['name']}
Address: ${firstResult['formatted_address']}
Lat: ${firstResult['geometry']['location']['lat']}
Lng: ${firstResult['geometry']['location']['lng']}
          ''';
        });
      } else {
        setState(() {
          _result = 'No results found or error: ${data['status']}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Place Search with Dio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city, state, country',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => searchPlace(_controller.text),
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
