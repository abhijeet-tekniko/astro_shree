import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:astro_shree_user/presentation/wallet_screen/wallet_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dioClient;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/network/endpoints.dart';
import '../core/utils/themes/appThemes.dart';
import '../data/api_call/astrologers_api.dart';
import '../data/api_call/profile_api.dart';
import '../data/model/chat_session_message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:developer';

import '../widget/app_bar/appbar_title.dart';
import '../widget/app_bar/custom_navigate_back_button.dart';
import 'chat_and_call_screen/chat_summary_screen.dart';

class ChatNewwScreen extends StatefulWidget {
  final String chatSessionId;
  final String astrologerName;
  final String astrologerId;
  final String astrologerImage;
  String? comesFrom;
  final String maxDuartion;
  // final int chatPrice;

  ChatNewwScreen({
    required this.chatSessionId,
    required this.astrologerName,
    required this.astrologerId,
    required this.astrologerImage,
    this.comesFrom,
    // required this.chatPrice,
    super.key,
    required this.maxDuartion,
  });

  @override
  _ChatNewwScreenState createState() => _ChatNewwScreenState();
}

class _ChatNewwScreenState extends State<ChatNewwScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool isTyping = false;
  bool isAstrologerTyping = false;
  Timer? _typingTimer;
  final AstrologersApi astrologersApi = Get.find<AstrologersApi>();
  final ProfileApi profileApi = Get.put(ProfileApi());
  Duration chatDuration = Duration.zero;
  Timer? chatTimer;

  @override
  void initState() {
    super.initState();
    _loadMessagesFromSession();
    SocketService.on('newMessage', _handleNewMessage);
    SocketService.on('messageSent', _handleMessageSent);
    SocketService.on('messageError', _handleMessageError);
    SocketService.on('messageUpdated', _handleMessageUpdated);
    SocketService.on('messageEdited', _handleMessageEdited);
    SocketService.on('messageDeleted', _handleMessageDeleted);
    SocketService.on('messagesRead', _handleMessagesRead);
    SocketService.on('messagesMarkedAsRead', _handleMessagesMarkedAsRead);
    SocketService.on('userTyping', _handleUserTyping);
    SocketService.on('userStoppedTyping', _handleUserStoppedTyping);
    SocketService.on('chatSessionEnded', _handleChatSessionEnded);
    SocketService.on('chatSessionPaused', _handleChatSessionPause);
    SocketService.on('chatSessionResumed', _handleChatSessionResume);

    _messageController.addListener(_handleTyping);

    remainingSeconds = int.parse(widget.maxDuartion) /** 60*/;
    startTimer();
  }

  void addAllMessagesToList(List<Data> dataList) {
    messages.addAll(dataList.map((data) => data.toJson()));
  }

  ///pickFilesCode
  List<File> selectedFiles = [];
  List<String> filePreviews = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'mp4',
        'mov',
        'avi',
        'pdf'
      ],
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
        filePreviews = selectedFiles.map((file) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType?.startsWith('image/') == true ||
              mimeType?.startsWith('video/') == true) {
            return file.path;
          }
          return ''; // No preview for non-image/video files
        }).toList();
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
      filePreviews.removeAt(index);
    });
  }

  ///pickFilesCode

  Future<void> _loadMessagesFromSession() async {
    await astrologersApi.fetchChatMessageSession(
        sessionId: widget.chatSessionId.toString(), from: 'active');

    print('messagesSessionApi.length========${messages.length}');
    print(
        'messagesSessionApi.length========${astrologersApi.chatSessionMessage.value?.data!.first.sender}');

    try {
      setState(() {
        addAllMessagesToList(
            astrologersApi.chatSessionMessage.value?.data ?? []);
      });
      _scrollToBottom();
    } catch (e) {
      print('Error loading messages from session: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load session messages: $e')),
      );
    }
  }

  void _handleNewMessage(dynamic data) {
    if (!mounted) return;
    setState(() {
      messages.add(data);
    });
    print('_handleNewMessage======$data');
    SocketService.markMessagesAsRead(widget.astrologerId);
    _scrollToBottom();
  }

  void _handleMessageSent(dynamic data) {
    if (!mounted) return;
    setState(() {
      messages.add(data);

      print('_handleMessageSent======$data');
      print('_handleMessageSent======$messages');
    });
    _scrollToBottom();
  }

  void _handleMessageError(dynamic data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message error: ${data['message']}')),
    );
  }

  void _handleMessageUpdated(dynamic data) {
    setState(() {
      final index = messages.indexWhere((m) => m['_id'] == data['_id']);
      if (index != -1) {
        messages[index] = data;
      }
    });
  }

  void _handleMessageEdited(dynamic data) {
    setState(() {
      final index = messages.indexWhere((m) => m['_id'] == data['_id']);
      if (index != -1) {
        messages[index] = data;
      }
    });
  }

  void _handleMessageDeleted(dynamic data) {
    setState(() {
      messages.removeWhere((m) => m['_id'] == data['messageId']);
    });
  }

  void _handleMessagesRead(dynamic data) {
    setState(() {
      for (var message in messages) {
        if (message['sender'] == SocketService.userId &&
            message['recipient'] == data['recipientId']) {
          message['isRead'] = true;
        }
      }
    });
  }

  // Update _handleChatSessionPause to show UI feedback
  void _handleChatSessionPause(dynamic data) {
    print('checkPausedSession====$data');
    // setState(() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Chat session paused due to low balance')),
    // );
    // });
  }

  // Update _handleChatSessionResume to show UI feedback
  void _handleChatSessionResume(dynamic data) {
    print('checkPausedSession==Resume==$data');
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        remainingSeconds = data['remainingTime'];
        setState(() {});
      },
    );
  }

  void _handleMessagesMarkedAsRead(dynamic data) {
    setState(() {
      for (var message in messages) {
        if (message['sender'] == data['senderId'] &&
            message['recipient'] == SocketService.userId) {
          message['isRead'] = true;
        }
      }
    });
  }

  void _handleUserTyping(dynamic data) {
    if (data['senderId'] == widget.astrologerId) {
      setState(() {
        isAstrologerTyping = true;
      });
    }
  }

  void _handleUserStoppedTyping(dynamic data) {
    if (data['senderId'] == widget.astrologerId) {
      setState(() {
        isAstrologerTyping = false;
      });
    }
  }

  // Future<double> _fetchAvailableBalance() async {
  //   try {
  //     // Assume astrologersApi has a method to fetch wallet balance
  //     final response = await astrologersApi.fetchWalletBalance(); // Hypothetical method
  //     return response['balance']?.toDouble() ?? 0.0;
  //   } catch (e) {
  //     print('Error fetching balance: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to fetch balance: $e')),
  //     );
  //     return 0.0;
  //   }
  // }

  void _handleChatSessionEnded(dynamic data) async {
    // final availableBalance = data['balance']?.toDouble() ?? await _fetchAvailableBalance();
    // Get.off(() => ChatSummaryScreen(
    //   chatDuration: chatDuration,
    //   astrologerName: widget.astrologerName,
    //   astrologerId: widget.astrologerId,
    //   astrologerImage: widget.astrologerImage,
    //   availableBalance: 23,
    // ));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Chat ended: ${data['reason']}')),
    // );
  }

  void _handleTyping() {
    if (_messageController.text.isNotEmpty && !isTyping) {
      setState(() {
        isTyping = true;
      });
      SocketService.emitTyping(widget.astrologerId);
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          isTyping = false;
        });
        SocketService.emitStopTyping(widget.astrologerId);
      });
    } else if (_messageController.text.isEmpty && isTyping) {
      setState(() {
        isTyping = false;
      });
      SocketService.emitStopTyping(widget.astrologerId);
      _typingTimer?.cancel();
    }
  }

  Future<void> _sendMessage() async {
    ///fileCode
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty && selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message or select files')),
      );
      return;
    }
    try {
      if (selectedFiles.isNotEmpty) {
        final dio = dioClient.Dio();

        print('object${widget.chatSessionId}');

        final formData = dioClient.FormData.fromMap({
          'chatSessionId': widget.chatSessionId,
          'senderId': profileApi.userProfile.value!.id,
          'senderType': 'User',
          'recipientId': widget.astrologerId,
          'recipientType': 'Astrologer',
          if (messageText.isNotEmpty) 'messageText': messageText,
          'media': await Future.wait(
            selectedFiles.map((file) async {
              final mimeType =
                  lookupMimeType(file.path) ?? 'application/octet-stream';
              return await dioClient.MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
                contentType: MediaType.parse(mimeType),
              );
            }),
          ),
        });

        print('apiFile========$formData');
        final response = await dio.post(
          'http://167.71.232.245:4856/api/user/send',
          data: formData,
          options: dioClient.Options(
            contentType: 'multipart/form-data',
          ),
        );

        print('apiFile========$response');
        print('apiFile========${response.statusCode}');

        if (response.statusCode == 200) {
          final responseData = response.data;
          setState(() {
            messages.add(responseData['data']);
            _messageController.clear();
            selectedFiles = [];
            filePreviews = [];
          });
          _scrollToBottom();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to send media: ${response.statusMessage}')),
          );
        }
      } else {
        SocketService.sendMessage(
            widget.chatSessionId, _messageController.text);
        // Send text via Socket.IO
        // socket!.emit('sendMessage', {
        //   'chatSessionId': widget.chatSessionId,
        //   'senderId': widget.senderId,
        //   'senderType': widget.senderType,
        //   'messageText': messageText,
        // });
        _messageController.clear();
        _typingTimer?.cancel();
        setState(() {
          isTyping = false;
        });
        SocketService.emitStopTyping(widget.astrologerId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }

    ///fileCode

    ///below is fine code
    // if (_messageController.text.isNotEmpty) {
    //   final hindiTranslation = await translateToHindi(_messageController.text);
    //   // final combinedMessage = '${_messageController.text}\n$hindiTranslation';
    //   SocketService.sendMessage(widget.chatSessionId, _messageController.text);
    //   // SocketService.sendMessage(widget.chatSessionId,combinedMessage);
    //   _messageController.clear();
    //   _typingTimer?.cancel();
    //   setState(() {
    //     isTyping = false;
    //   });
    //   SocketService.emitStopTyping(widget.astrologerId);
    // }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file')),
      );
    }
  }

  void _editMessage(String messageId, String currentText) async {
    final newText = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: currentText);
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit your message',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newText != null && newText.isNotEmpty) {
      SocketService.editMessage(messageId, newText);
    }
  }

  void _deleteMessage(String messageId) async {
    final forEveryone = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Delete for everyone?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Delete for me'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete for everyone'),
            ),
          ],
        );
      },
    );
    if (forEveryone != null) {
      SocketService.deleteMessage(messageId, forEveryone);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _endChat() {
    SocketService.endChatSession(widget.chatSessionId);
    profileApi.fetchProfile();
    profileApi.fetchIsNewUser();
    // SocketService.endChatScreenSession(widget.chatSessionId,chatDuration,widget.astrologerName,widget.astrologerId,widget.astrologerImage);
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secs.toString().padLeft(2, '0');

    if (hours > 0) {
      final hoursStr = hours.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr:$secondsStr'; // HH:MM:SS
    } else {
      return '$minutesStr:$secondsStr'; // MM:SS
    }
  }

  Future<String> translateToHindi(String text) async {
    final apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';
    final dio = dioClient.Dio();

    final url =
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

    try {
      final response = await dio.post(
        url,
        options: dioClient.Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          'q': text,
          'source': 'en',
          'target': 'hi',
          'format': 'text',
        },
      );

      if (response.statusCode == 200) {
        print('check response translate data=====>${response.data['data']}');
        final translatedText =
            response.data['data']['translations'][0]['translatedText'];
        print('check response translate data=====>$translatedText');
        return translatedText;
      } else {
        throw Exception('Failed to translate: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Translation error: $e');
    }
  }

  late int remainingSeconds;
  Timer? timer;

  Future<bool> _showRechargePopup() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Low Balance'),
              content: const Text(
                  'Your chat time is below 3 minutes. Would you like to recharge your wallet to continue?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Recharge'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  bool hasRecharged = false;
  Set<int> shownPopupThresholds =
      {}; // Stores which thresholds have already triggered a popup

  void startTimer() {
    final isNew = profileApi.isNewUser.value;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            remainingSeconds--;
          });
        }

        if (!isNew) {
          print('Remaining seconds: $remainingSeconds');
          print('Shown popups: $shownPopupThresholds');
          print('Has recharged: $hasRecharged');

          // Check thresholds: 180, 120, 60
          List<int> popupThresholds = [/*180,*/ 121, 61];
          for (int threshold in popupThresholds) {
            if (remainingSeconds <= threshold &&
                !shownPopupThresholds.contains(threshold) &&
                !hasRecharged) {
              shownPopupThresholds.add(threshold);
              t.cancel(); // Pause timer during popup
              SocketService.pauseChatSession(widget.chatSessionId);

              final shouldRecharge = await _showRechargePopup();
              if (mounted) {
                if (shouldRecharge) {
                  hasRecharged = true;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WalletScreen()),
                  );
                  SocketService.resumeChatSession(widget.chatSessionId);
                } else {
                  SocketService.resumeChatSession(widget.chatSessionId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Chat will continue until time runs out')),
                  );
                }
                startTimer(); // Resume timer
              }
              return;
            }
          }
        }
      } else {
        t.cancel();
        if (mounted) {
          _endChat();
        }
      }
    });
  }

  Future<bool> _showEndChatConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('End Chat'),
              content: const Text('Do you want to end the chat session?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  // onPressed: () => Navigator.pop(context, true),
                  onPressed: () {
                    Navigator.pop(context, true);

                    //
                    // Navigator.pushReplacement(context, MaterialPageRoute(
                    //   builder: (_) =>
                    //       ChatSummaryScreen(
                    //         chatDuration: chatDuration, // Assume duration is passed or fetched
                    //         astrologerName: widget.astrologerName,
                    //         astrologerId: widget.astrologerId ?? '',
                    //         astrologerImage:(widget.astrologerImage?? ''),
                    //         availableBalance:  400.0,
                    //         ratePerMinute:10.0/* double.parse(widget.chatPrice.toString())*/,
                    //         // Assume balance is passed or fetched
                    //       ),
                    // ));

                    // Get.off(
                    // );
                  },
                  child: const Text('End Chat'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldEndChat = await _showEndChatConfirmationDialog();
        if (shouldEndChat) {
          _endChat();

          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC62828),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              bool shouldEndChat = await _showEndChatConfirmationDialog();
              if (shouldEndChat) {
                _endChat();
              }
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.astrologerImage),
                radius: 18,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.astrologerName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    // _formatDuration(chatDuration),
                    formatDuration(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Container(
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white,
            //   ),
            //   padding: const EdgeInsets.all(2),
            //   margin: const EdgeInsets.all(8),
            //   child: IconButton(
            //     icon: const Icon(Icons.handshake_outlined,
            //         color: Color(0xFFC62828)),
            //     onPressed: () async {
            //       Get.to(SuggestedRemedyListingScreen());
            //     },
            //   ),
            // ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.call_end_outlined,
                    color: Color(0xFFC62828)),
                onPressed: () async {
                  bool shouldEndChat = await _showEndChatConfirmationDialog();
                  if (shouldEndChat) {
                    _endChat();
                  }
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8E1E1),
                Color(0xFFFFF0F0),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    final media = message['media'] as List<dynamic>?;
                    // print('MessageCheck========${message}');
                    // final isMe = message['sender'] == SocketService.userId;
                    final isMe =
                        message['sender']?['_id'] == SocketService.userId;

                    print('Checktimestamp11====${message['timestamp']}');

                    final timestampStr = message['timestamp'];

                    final timestamp = timestampStr != null
                        ? DateFormat('h:mm a')
                            .format(DateTime.parse(timestampStr).toLocal())
                        : '';

                    print('Checktimestamp====$timestamp');
                    try {
                      if (message['createdAt'] != null) {
                        // final date = (message['createdAt'] is Timestamp)
                        //     ? (message['createdAt'] as Timestamp).toDate()
                        //     : DateTime.parse(message['createdAt'].toString());
                        // timestamp = DateFormat('h:mm a').format(date.toLocal());
                      }
                    } catch (e) {
                      // timestamp = 'Invalid time';
                    }

                    // print('SocketService.userId========${SocketService.userId}');
                    // print('messageSender========${message['sender']?['_id']}');
                    // print('messageSender========${message['sender']}');

                    // log('MessageNewCheck========${messages[0]}');
                    // log('timestamp========$timestamp');
                    // log('isMe========$isMe');

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFFFFCDD2) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: Radius.circular(isMe ? 12 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onLongPress: isMe
                              ? () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit,
                                              color: Color(0xFFC62828)),
                                          title: const Text('Edit'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _editMessage(message['_id'],
                                                message['message']);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete,
                                              color: Color(0xFFC62828)),
                                          title: const Text('Delete'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _deleteMessage(message['_id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              : null,
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isMe ? Colors.black87 : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),

                              ///fileCode
                              if (media != null && media.isNotEmpty) ...[
                                SizedBox(height: 5),
                                Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: media.map((m) {
                                    print(m);
                                    print('m]=====${m['type']}');
                                    final url =
                                        'http://167.71.232.245:4856/${m['url']}';
                                    if (m['type'] == 'image') {
                                      return GestureDetector(
                                        onTap: () => _launchURL(url),
                                        child: CachedNetworkImage(
                                          imageUrl: url,
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error,
                                                  color: Colors.red),
                                        ),
                                      );
                                    } /*else if (m['type'] == 'video') {
                                      return VideoPlayerWidget(url: url);
                                    }*/
                                    else {
                                      return GestureDetector(
                                        onTap: () => _launchURL(url),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            m['fileName'],
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ),
                              ],

                              ///fileCode
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timestamp,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe
                                          ? Colors.black54
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              ///fileCode
              if (filePreviews.isNotEmpty)
                Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filePreviews.length,
                    itemBuilder: (context, index) {
                      final preview = filePreviews[index];
                      return Stack(
                        children: [
                          preview.isNotEmpty
                              ? (lookupMimeType(selectedFiles[index].path)!
                                      .startsWith('image/')
                                  ? Image.file(
                                      selectedFiles[index],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.videocam, size: 80))
                              : Icon(Icons.insert_drive_file, size: 80),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => _removeFile(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              ///fileCode
              // if (isAstrologerTyping)
              //   Container(
              //     padding: const EdgeInsets.all(8),
              //     child: Row(
              //       children: [
              //         CircleAvatar(
              //           backgroundImage: NetworkImage(widget.astrologerImage),
              //           radius: 10,
              //         ),
              //         const SizedBox(width: 8),
              //         const Text(
              //           'Typing...',
              //           style: TextStyle(
              //               color: Colors.black54, fontStyle: FontStyle.italic),
              //         ),
              //       ],
              //     ),
              //   ),
              SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: _pickFiles,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFC62828),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    chatTimer?.cancel();
    SocketService.off('newMessage', _handleNewMessage);
    SocketService.off('messageSent', _handleMessageSent);
    SocketService.off('messageError', _handleMessageError);
    SocketService.off('messageUpdated', _handleMessageUpdated);
    SocketService.off('messageEdited', _handleMessageEdited);
    SocketService.off('messageDeleted', _handleMessageDeleted);
    SocketService.off('messagesRead', _handleMessagesRead);
    SocketService.off('messagesMarkedAsRead', _handleMessagesMarkedAsRead);
    SocketService.off('userTyping', _handleUserTyping);
    SocketService.off('userStoppedTyping', _handleUserStoppedTyping);
    SocketService.off('chatSessionEnded', _handleChatSessionEnded);
    super.dispose();
  }
}

// class ChatNewwScreen extends StatefulWidget {
//   final String chatSessionId;
//   final String astrologerName;
//   final String astrologerId;
//   final String astrologerImage;
//   String? comesFrom;
//
//   ChatNewwScreen({
//     required this.chatSessionId,
//     required this.astrologerName,
//     required this.astrologerId,
//     required this.astrologerImage,
//     this.comesFrom,
//     super.key,
//   });
//
//   @override
//   _ChatNewwScreenState createState() => _ChatNewwScreenState();
// }
//
// class _ChatNewwScreenState extends State<ChatNewwScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> messages = [];
//   final ScrollController _scrollController = ScrollController();
//   bool isTyping = false;
//   bool isAstrologerTyping = false;
//   Timer? _typingTimer;
//   final AstrologersApi astrologersApi = Get.find<AstrologersApi>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Duration chatDuration = Duration.zero;
//   Timer? chatTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMessagesFromFirestore();
//     _loadMessagesFromSession();
//     SocketService.on('newMessage', _handleNewMessage);
//     SocketService.on('messageSent', _handleMessageSent);
//     SocketService.on('messageError', _handleMessageError);
//     SocketService.on('messageUpdated', _handleMessageUpdated);
//     SocketService.on('messageEdited', _handleMessageEdited);
//     SocketService.on('messageDeleted', _handleMessageDeleted);
//     SocketService.on('messagesRead', _handleMessagesRead);
//     SocketService.on('messagesMarkedAsRead', _handleMessagesMarkedAsRead);
//     SocketService.on('userTyping', _handleUserTyping);
//     SocketService.on('userStoppedTyping', _handleUserStoppedTyping);
//     SocketService.on('chatSessionEnded', _handleChatSessionEnded);
//
//     SocketService.markMessagesAsRead(widget.astrologerId);
//     _messageController.addListener(_handleTyping);
//
//     chatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         chatDuration += const Duration(seconds: 1);
//       });
//     });
//   }
//
//   Future<void> _loadMessagesFromFirestore() async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('chat_sessions')
//           .doc(widget.chatSessionId)
//           .collection('messages')
//           .orderBy('createdAt')
//           .get();
//
//       setState(() {
//         messages.clear();
//         for (var doc in querySnapshot.docs) {
//           final data = doc.data();
//           messages.add({
//             '_id': doc.id,
//             'sender': data['senderId'],
//             'senderType': data['senderType'],
//             'message': data['messageText'],
//             'createdAt': data['createdAt'],
//             'isRead': data['isRead'],
//           });
//         }
//       });
//       _scrollToBottom();
//     } catch (e) {
//       print('Error loading messages from Firestore: $e');
//     }
//   }
//
//   void addAllMessagesToList(List<Data> dataList) {
//     messages.addAll(dataList.map((data) => data.toJson()));
//   }
//
//
//   Future<void> _loadMessagesFromSession() async {
//     try {
//       await astrologersApi.fetchChatMessageSession(sessionId: widget.chatSessionId.toString(),from: 'active'); // Assuming this method exists
//
//       addAllMessagesToList(astrologersApi.chatSessionMessage.value!.data!);
//       setState(() {
//         // messages.addAll(astrologersApi.chatSessionMessage.value!.data);
//         // for (var doc in querySnapshot.docs) {
//         //   final data = doc.data();
//         //   messages.add({
//         //     '_id': doc.id,
//         //     'sender': data['senderId'],
//         //     'senderType': data['senderType'],
//         //     'message': data['messageText'],
//         //     'createdAt': data['createdAt'],
//         //     'isRead': data['isRead'],
//         //   });
//         // }
//       });
//       _scrollToBottom();
//     } catch (e) {
//       print('Error loading messages from Firestore: $e');
//     }
//   }
//
//   void _handleNewMessage(dynamic data) {
//     if (!mounted) return;
//     setState(() {
//       messages.add(data);
//     });
//     SocketService.markMessagesAsRead(widget.astrologerId);
//     _scrollToBottom();
//   }
//
//   void _handleMessageSent(dynamic data) {
//     if (!mounted) return;
//     setState(() {
//       messages.add(data);
//     });
//     _scrollToBottom();
//   }
//
//   void _handleMessageError(dynamic data) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Message error: ${data['message']}')),
//     );
//   }
//
//   void _handleMessageUpdated(dynamic data) {
//     setState(() {
//       final index = messages.indexWhere((m) => m['_id'] == data['_id']);
//       if (index != -1) {
//         messages[index] = data;
//       }
//     });
//   }
//
//   void _handleMessageEdited(dynamic data) {
//     setState(() {
//       final index = messages.indexWhere((m) => m['_id'] == data['_id']);
//       if (index != -1) {
//         messages[index] = data;
//       }
//     });
//   }
//
//   void _handleMessageDeleted(dynamic data) {
//     setState(() {
//       messages.removeWhere((m) => m['_id'] == data['messageId']);
//     });
//   }
//
//   void _handleMessagesRead(dynamic data) {
//     setState(() {
//       for (var message in messages) {
//         if (message['sender'] == SocketService.userId &&
//             message['recipient'] == data['recipientId']) {
//           message['isRead'] = true;
//         }
//       }
//     });
//   }
//
//   void _handleMessagesMarkedAsRead(dynamic data) {}
//
//   // void _handleUserTyping(dynamic data) {
//   //   if (data['senderId'] == widget.astrologerId) {
//   //     setState(() {
//   //       isAstrologerTyping = true;
//   //     });
//   //   }
//   // }
//
//   void _handleUserTyping(dynamic data) {
//     if (data['senderId'] == widget.astrologerId) {
//       final wasFocused = _focusNode.hasFocus;
//
//       setState(() {
//         isAstrologerTyping = true;
//       });
//
//       if (wasFocused) {
//         FocusScope.of(context).requestFocus(_focusNode); // <-- Keep keyboard open
//       }
//     }
//   }
//
//   // void _handleUserStoppedTyping(dynamic data) {
//   //   if (data['senderId'] == widget.astrologerId) {
//   //     setState(() {
//   //       isAstrologerTyping = false;
//   //     });
//   //   }
//   // }
//
//
//   void _handleUserStoppedTyping(dynamic data) {
//     if (data['senderId'] == widget.astrologerId) {
//       final wasFocused = _focusNode.hasFocus;
//
//       setState(() {
//         isAstrologerTyping = false;
//       });
//
//       if (wasFocused) {
//         FocusScope.of(context).requestFocus(
//             _focusNode); // <-- Keep keyboard open
//       }
//     }
//   }
//
//   void _handleChatSessionEnded(dynamic data) {
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Chat ended: ${data['reason']}')),
//     );
//   }
//
//   void _handleTyping() {
//     if (_messageController.text.isNotEmpty && !isTyping) {
//       setState(() {
//         isTyping = true;
//       });
//       SocketService.emitTyping(widget.astrologerId);
//       _typingTimer?.cancel();
//       _typingTimer = Timer(const Duration(seconds: 3), () {
//         setState(() {
//           isTyping = false;
//         });
//         SocketService.emitStopTyping(widget.astrologerId);
//       });
//     } else if (_messageController.text.isEmpty && isTyping) {
//       setState(() {
//         isTyping = false;
//       });
//       SocketService.emitStopTyping(widget.astrologerId);
//       _typingTimer?.cancel();
//     }
//   }
//
//   void _sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       SocketService.sendMessage(widget.chatSessionId, _messageController.text);
//       _messageController.clear();
//       _typingTimer?.cancel();
//       setState(() {
//         isTyping = false;
//       });
//       SocketService.emitStopTyping(widget.astrologerId);
//     }
//   }
//
//   void _editMessage(String messageId, String currentText) async {
//     final newText = await showDialog<String>(
//       context: context,
//       builder: (context) {
//         final controller = TextEditingController(text: currentText);
//         return AlertDialog(
//           title: const Text('Edit Message'),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Edit your message',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, controller.text),
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//     if (newText != null && newText.isNotEmpty) {
//       SocketService.editMessage(messageId, newText);
//     }
//   }
//
//   void _deleteMessage(String messageId) async {
//     final forEveryone = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Message'),
//           content: const Text('Delete for everyone?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Delete for me'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text('Delete for everyone'),
//             ),
//           ],
//         );
//       },
//     );
//     if (forEveryone != null) {
//       SocketService.deleteMessage(messageId, forEveryone);
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _endChat() {
//     SocketService.endChatSession(widget.chatSessionId);
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = duration.inHours;
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//
//     if (hours > 0) {
//       return '${twoDigits(hours)}:$minutes:$seconds';
//     } else {
//       return '$minutes:$seconds';
//     }
//   }
//
//   // New method to show the end chat confirmation dialog
//   Future<bool> _showEndChatConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('End Chat'),
//           content: const Text('Do you want to end the chat session?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text('End Chat'),
//             ),
//           ],
//         );
//       },
//     ) ??
//         false; // Return false if dialog is dismissed
//   }
//
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         bool shouldEndChat = await _showEndChatConfirmationDialog();
//         if (shouldEndChat) {
//           _endChat();
//           return true;
//         }
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFFC62828),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(widget.astrologerImage),
//                 radius: 18,
//                 backgroundColor: Colors.white,
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.astrologerName,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     _formatDuration(chatDuration),
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   // Obx(() {
//                   //   final status = astrologersApi.astrologerList.value
//                   //       ?.firstWhereOrNull((a) => a.id == widget.astrologerId)
//                   //       ?.status;
//                   //   return Text(
//                   //     status ?? 'Offline',
//                   //     style: TextStyle(
//                   //       fontSize: 12,
//                   //       color: status == 'online' ? Colors.greenAccent : Colors.grey[400],
//                   //     ),
//                   //   );
//                   // }),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               padding: EdgeInsets.all(2),
//               margin: EdgeInsets.all(8),
//               child: IconButton(
//                 icon: const Icon(Icons.call_end_outlined, color: const Color(0xFFC62828)),
//                 onPressed: () async {
//                   bool shouldEndChat = await _showEndChatConfirmationDialog();
//                   if (shouldEndChat) {
//                     _endChat();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFF8E1E1),
//                 Color(0xFFFFF0F0),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: messages.length,
//                   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isMe = message['sender'] == SocketService.userId;
//                     // final isMe = message['sender']?['_id'] == SocketService.userId;
//                     final timestamp = message['timestamp'] != null
//                         ? DateFormat('h:mm a').format(DateTime.parse(message['timestamp']).toLocal())
//                         : '';
//
//                     print('SocketService.userId========${SocketService.userId}');
//                     // print('messageSender========${message['sender']?['_id']}');
//                     print('messageSender========${message['sender']}');
//                     print('MessageCheck========${message}');
//                     log('MessageNewCheck========${messages[0]}');
//                     log('timestamp========$timestamp');
//                     log('isMe========$isMe');
//                     return Align(
//                       alignment: isMe||index==0 ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.7,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isMe
//                               ? const Color(0xFFFFCDD2)
//                               : Colors.white,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(12),
//                             topRight: const Radius.circular(12),
//                             bottomLeft: Radius.circular(isMe ? 12 : 0),
//                             bottomRight: Radius.circular(isMe ? 0 : 12),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: GestureDetector(
//                           onLongPress: isMe
//                               ? () {
//                             showModalBottomSheet(
//                               context: context,
//                               backgroundColor: Colors.white,
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                               ),
//                               builder: (context) => Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ListTile(
//                                     leading: const Icon(Icons.edit, color: Color(0xFFC62828)),
//                                     title: const Text('Edit'),
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                       _editMessage(message['_id'], message['message']);
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.delete, color: Color(0xFFC62828)),
//                                     title: const Text('Delete'),
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                       _deleteMessage(message['_id']);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                               : null,
//                           child: Column(
//                             crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 message['message'],
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: isMe ? Colors.black87 : Colors.black,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     timestamp,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       color: isMe ? Colors.black54 : Colors.grey[600],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // if (isAstrologerTyping)
//               //   Container(
//               //     padding: const EdgeInsets.all(8),
//               //     child: Row(
//               //       children: [
//               //         CircleAvatar(
//               //           backgroundImage: NetworkImage(widget.astrologerImage),
//               //           radius: 10,
//               //         ),
//               //         const SizedBox(width: 8),
//               //         const Text(
//               //           'Typing...',
//               //           style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: const Color(0xFFC62828),
//                       child: IconButton(
//                         icon: const Icon(Icons.send, color: Colors.white),
//                         onPressed: _sendMessage,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _focusNode.dispose();
//     _typingTimer?.cancel();
//     SocketService.off('newMessage', _handleNewMessage);
//     SocketService.off('messageSent', _handleMessageSent);
//     SocketService.off('messageError', _handleMessageError);
//     SocketService.off('messageUpdated', _handleMessageUpdated);
//     SocketService.off('messageEdited', _handleMessageEdited);
//     SocketService.off('messageDeleted', _handleMessageDeleted);
//     SocketService.off('messagesRead', _handleMessagesRead);
//     SocketService.off('messagesMarkedAsRead', _handleMessagesMarkedAsRead);
//     SocketService.off('userTyping', _handleUserTyping);
//     SocketService.off('userStoppedTyping', _handleUserStoppedTyping);
//     SocketService.off('chatSessionEnded', _handleChatSessionEnded);
//     super.dispose();
//
//     chatTimer?.cancel();
//   }
// }

///

///remedy suggested screen

class Remedy {
  final String title;
  final String description;
  final bool isCompleted;

  Remedy({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class SuggestedRemedyListingScreen extends StatefulWidget {
  @override
  _SuggestedRemedyListingScreenState createState() =>
      _SuggestedRemedyListingScreenState();
}

class _SuggestedRemedyListingScreenState
    extends State<SuggestedRemedyListingScreen> {
  List<Remedy> remedies = [
    Remedy(
      title: "Wear Blue Sapphire",
      description: "Wear on Saturday morning after purification rituals.",
    ),
    Remedy(
      title: "Chant Gayatri Mantra",
      description: "Recite 108 times daily before sunrise.",
    ),
    Remedy(
      title: "Donate to Poor on Saturdays",
      description: "Donate black sesame or mustard oil.",
    ),
  ];

  void markAsDone(int index) {
    setState(() {
      remedies[index] = Remedy(
        title: remedies[index].title,
        description: remedies[index].description,
        isCompleted: true,
      );
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
        centerTitle: true,
        title: AppbarTitle(
          text: 'Suggested Remedies',
          margin: EdgeInsets.only(left: screenWidth * 0.08),
        ),
      ),
      body: ListView.builder(
        itemCount: remedies.length,
        itemBuilder: (context, index) {
          final remedy = remedies[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: remedy.isCompleted ? Colors.green[50] : Colors.white,
            child: ListTile(
              title: Text(
                remedy.title,
                style: TextStyle(
                  decoration:
                      remedy.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(remedy.description),
              trailing: remedy.isCompleted
                  ? Icon(Icons.check, color: Colors.green)
                  : TextButton(
                      child: Text("Mark as Done"),
                      onPressed: () => markAsDone(index),
                    ),
            ),
          );
        },
      ),
    );
  }
}
