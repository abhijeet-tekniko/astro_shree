
import 'package:astro_shree_user/presentation/call_pick_screen.dart';
import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core/utils/themes/appThemes.dart';
import '../data/api_call/member_controller.dart';


import '../widget/app_bar/appbar_title.dart';
import '../widget/app_bar/custom_navigate_back_button.dart';

class MemberScreen extends StatefulWidget {
  final String id;
  const MemberScreen({super.key, required this.id});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> with SingleTickerProviderStateMixin {
  bool showLoader = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedGender;
  final _placeController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _selectedMemberId;

  final memberController = Get.put(MemberController());

  @override
  void initState() {
    super.initState();
    memberController.fetchMembers();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _selectMember(int index) {
    final member = memberController.memberList[index];
    setState(() {
      _selectedMemberId = member.sId;
      _nameController.text = member.name ?? '';
      _selectedDate = DateTime.tryParse(member.dob ?? '');
      _selectedTime = TimeOfDay.fromDateTime(DateTime.tryParse(member.birthTime ?? '') ?? DateTime.now());
      _selectedGender = member.gender.toString().toLowerCase() == 'male'
          ? 'Male'
          : member.gender.toString().toLowerCase() == 'female'
          ? 'Female'
          : 'Other';
      _placeController.text = member.placeOfBirth ?? '';
      _animationController.forward(from: 0);
    });
  }

  void _startAddingMember() {
    setState(() {
      _selectedMemberId = null;
      _nameController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _selectedGender = null;
      _placeController.clear();
      _animationController.forward(from: 0);
    });
  }

  void _proceedToChat() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedMemberId == null) {
        print('yegya');
        // Add new member before proceeding
        /*final newMemberId =*/ await memberController.createMember(name: _nameController.text, gender:  _selectedGender?.toLowerCase() ?? 'male', dob:   _selectedDate.toString().substring(0,10), birthTime: formatTimeOfDay(_selectedTime!), placeOfBirth: _placeController.text.toString(),);
        // setState(() {
        //   _selectedMemberId = newMemberId; // Set the new member ID
        // });
      } else {
        // Update existing member
        // await memberController.updateMember(
        //   _selectedMemberId!,
        //   _nameController.text,
        //   _selectedDate!,
        //   _selectedTime!,
        //   _selectedGender!,
        //   _placeController.text,
        // );
      }

      // Proceed to chat
      // Navigator.pushNamed(context, '/chat', arguments: _selectedMemberId);

     SocketService.sendChatRequest(
        widget.id.toString(),
        _nameController.text.toString(),
        _selectedGender?.toLowerCase() ?? 'male',
       _selectedDate.toString().substring(0,10),
         formatTimeOfDay(_selectedTime!),
        _placeController.text.toString(),
      );

      setState(() {
        showLoader = true;
      });

      Get.off(CallPickScreen(callerName: _nameController.text.toString(), callType: 'chat', profileImage: 'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=',astroId: widget.id,));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields to proceed to chat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title:  AppbarTitle(text: 'Select Member'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Theme.of(context).colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 80,
              //   child: Obx(() => ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: memberController.memberList.length + 1,
              //     itemBuilder: (context, index) {
              //       if (index == memberController.memberList.length) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //           child: GestureDetector(
              //             onTap: _startAddingMember,
              //             child: CircleAvatar(
              //               radius: 30,
              //               backgroundColor: Theme.of(context).colorScheme.primary,
              //               child: const Icon(
              //                 Icons.add,
              //                 color: Colors.white,
              //                 size: 30,
              //               ),
              //             ),
              //           ),
              //         );
              //       }
              //       final member = memberController.memberList[index];
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: GestureDetector(
              //           onTap: () => _selectMember(index),
              //           child: CircleAvatar(
              //             radius: 30,
              //             backgroundColor: index % 3 == 0
              //                 ? Colors.teal[300]
              //                 : index % 2 == 0
              //                 ? Colors.purple[300]
              //                 : Colors.blue[300],
              //             child: Text(
              //               member.name![0],
              //               style: const TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 24,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   )),
              // ),

              SizedBox(
                height: 80,
                child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: memberController.memberList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Add Icon as the first item
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: _startAddingMember,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }

                    // Shift index to access correct member after first item
                    final member = memberController.memberList[index - 1];
                    final isSelected = _selectedMemberId == member.sId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectMember(index - 1),
                        child: Container(
                          padding: const EdgeInsets.all(2), // Border padding
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.red, width: 3)
                                : null,
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: (index % 3 == 0)
                                ? Colors.teal[300]
                                : (index % 2 == 0)
                                ? Colors.purple[300]
                                : Colors.blue[300],
                            child: Text(
                              member.name![0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _showDatePicker,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Select date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                  : Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _showTimePicker,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Time of Birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
                            prefixIcon: Icon(
                              Icons.access_time,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text(
                            _selectedTime == null
                                ? 'Select time'
                                : _selectedTime!.format(context),
                            style: TextStyle(
                              color: _selectedTime == null
                                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                  : Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(
                            gender,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _placeController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Place of Birth',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a place';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _proceedToChat,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black.withOpacity(0.2),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          child: showLoader
                              ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                              : const Text('Proceed to Chat'),
                        ),
                      ),
                    ],
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



// void showMemberBottomSheet(BuildContext context, String sId) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     backgroundColor: Colors.white,
//     builder: (context) => MemberBottomSheet(id: sId),
//   );
// }
//
// class MemberBottomSheet extends StatefulWidget {
//   final String id;
//   const MemberBottomSheet({super.key, required this.id});
//
//   @override
//   State<MemberBottomSheet> createState() => _MemberBottomSheetState();
// }
//
// class _MemberBottomSheetState extends State<MemberBottomSheet> with SingleTickerProviderStateMixin {
//   bool _isAddingMember = false;
//   bool _isEditingMember = false;
//   bool _isSubmitting = false;
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedGender;
//   final _placeController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   String? _editingMemberId;
//
//   final memberController = Get.put(MemberController());
//
//   @override
//   void initState() {
//     super.initState();
//     memberController.fetchMembers();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _placeController.dispose();
//     super.dispose();
//   }
//
//   void _showDatePicker() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
//
//   void _showTimePicker() async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }
//
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       if (_isEditingMember) {
//         // Update existing member
//         // await memberController.updateMember(
//         //   _editingMemberId!,
//         //   _nameController.text,
//         //   _selectedDate!,
//         //   _selectedTime!,
//         //   _selectedGender!,
//         //   _placeController.text,
//         // );
//       } else {
//         // Add new member
//         // await memberController.addMember(
//         //   _nameController.text,
//         //   _selectedDate!,
//         //   _selectedTime!,
//         //   _selectedGender!,
//         //   _placeController.text,
//         // );
//       }
//
//       setState(() {
//         _isSubmitting = false;
//         _isAddingMember = false;
//         _isEditingMember = false;
//         _editingMemberId = null;
//         _nameController.clear();
//         _selectedDate = null;
//         _selectedTime = null;
//         _selectedGender = null;
//         _placeController.clear();
//         _animationController.forward(from: 0);
//       });
//     }
//   }
//
//   void _editMember(int index) {
//     final member = memberController.memberList[index];
//     setState(() {
//       _isAddingMember = true;
//       _isEditingMember = true;
//       _editingMemberId = member.sId;
//       _nameController.text = member.name ?? '';
//       _selectedDate = DateTime.tryParse(member.dob ?? '');
//       _selectedTime = TimeOfDay.fromDateTime(DateTime.tryParse(member.birthTime ?? '') ?? DateTime.now());
//       _selectedGender = member.gender;
//       _placeController.text = member.placeOfBirth ?? '';
//       _animationController.forward(from: 0);
//     });
//   }
//
//   void _deleteMember(String memberId) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this member?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       // await memberController.deleteMember(memberId);
//       setState(() {
//         _animationController.forward(from: 0);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.6,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Theme.of(context).colorScheme.surface.withOpacity(0.95),
//               ],
//             ),
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 50,
//                     height: 5,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(2.5),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   _isAddingMember ? (_isEditingMember ? 'Edit Member' : 'Add New Member') : 'Select Member',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: _isAddingMember
//                       ? _buildAddMemberForm()
//                       : _buildMemberList(scrollController),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           _isAddingMember = !_isAddingMember;
//                           _isEditingMember = false;
//                           _editingMemberId = null;
//                           _nameController.clear();
//                           _selectedDate = null;
//                           _selectedTime = null;
//                           _selectedGender = null;
//                           _placeController.clear();
//                           _animationController.forward(from: 0);
//                         });
//                       },
//                       style: TextButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         foregroundColor: Theme.of(context).colorScheme.secondary,
//                       ),
//                       child: Text(
//                         _isAddingMember ? 'Cancel' : 'Add Member',
//                         style: const TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     if (_isAddingMember)
//                       SizedBox(
//                         width: 150,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _isSubmitting ? null : _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                             elevation: 2,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             backgroundColor: Theme.of(context).colorScheme.primary,
//                             foregroundColor: Colors.white,
//                           ),
//                           child: _isSubmitting
//                               ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                               : Text(
//                             _isEditingMember ? 'Update' : 'Save',
//                             style: const TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildMemberList(ScrollController scrollController) {
//     return Obx(() => ListView.builder(
//       controller: scrollController,
//       itemCount: memberController.memberList.length,
//       itemBuilder: (context, index) {
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             title: Text(
//               memberController.memberList[index].name.toString(),
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             onTap: () {
//               SocketService.sendChatRequest(
//                 widget.id.toString(),
//                 memberController.memberList[index].name.toString(),
//                 memberController.memberList[index].gender.toString(),
//                 memberController.memberList[index].dob.toString(),
//                 memberController.memberList[index].birthTime.toString(),
//                 memberController.memberList[index].placeOfBirth.toString(),
//               );
//             },
//             leading: CircleAvatar(
//               backgroundColor: index % 2 == 0
//                   ? Colors.teal[300]
//                   : index % 3 == 0
//                   ? Colors.purple[300]
//                   : Colors.blue[300],
//               child: Text(
//                 memberController.memberList[index].name![0],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.edit,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   onPressed: () => _editMember(index),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.delete,
//                     color: Colors.red,
//                   ),
//                   onPressed: () => _deleteMember(memberController.memberList[index].sId.toString()),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ));
//   }
//
//   Widget _buildAddMemberForm() {
//     return Form(
//       key: _formKey,
//       child: ListView(
//         children: [
//           TextFormField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: 'Name',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               filled: true,
//               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//               prefixIcon: const Icon(Icons.person_outline),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a name';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           InkWell(
//             onTap: _showDatePicker,
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 labelText: 'Date of Birth',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 prefixIcon: const Icon(Icons.calendar_today),
//               ),
//               child: Text(
//                 _selectedDate == null
//                     ? 'Select date'
//                     : DateFormat.yMMMd().format(_selectedDate!),
//                 style: TextStyle(
//                   color: _selectedDate == null
//                       ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
//                       : Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           InkWell(
//             onTap: _showTimePicker,
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 labelText: 'Time of Birth',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//                 prefixIcon: const Icon(Icons.access_time),
//               ),
//               child: Text(
//                 _selectedTime == null
//                     ? 'Select time'
//                     : _selectedTime!.format(context),
//                 style: TextStyle(
//                   color: _selectedTime == null
//                       ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
//                       : Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           DropdownButtonFormField<String>(
//             value: _selectedGender,
//             decoration: InputDecoration(
//               labelText: 'Gender',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               filled: true,
//               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//               prefixIcon: const Icon(Icons.person),
//             ),
//             items: ['Male', 'Female', 'Other']
//                 .map((gender) => DropdownMenuItem(
//               value: gender,
//               child: Text(gender),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedGender = value;
//               });
//             },
//             validator: (value) {
//               if (value == null) {
//                 return 'Please select a gender';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _placeController,
//             decoration: InputDecoration(
//               labelText: 'Place',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               filled: true,
//               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
//               prefixIcon: const Icon(Icons.location_on_outlined),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a place';
//               }
//               return null;
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
