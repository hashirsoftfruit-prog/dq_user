// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/chat_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../widgets/coming_soon_dialog.dart';
import '../../booking_screens/booking_screen_widgets.dart';
import '../../drawer_menu_screens/pdf_view_screen.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final List<types.Message> _messages = [];

  final _user = types.User(
    id: '${getIt<SharedPreferences>().getInt(StringConstants.userId) ?? ''}',
  );

  @override
  void dispose() {
    getIt<ChatProvider>().disposeChat();

    super.dispose();
  }

  @override
  void initState() {
    // Provider.of<ChatProvider>(context, listen: false).listenToMessage(widget.appId);
    // _navigateToCall();
    super.initState();
  }

  Future<bool> onWillPop() async {
    // if (widget.isCallAvailable == true) {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CloseAlert(msg: "Are you sure you want to close?");
      },
    );

    if (result != null) {
      // getIt<BookingManager>().onLeaveSession(true);
      return Future.value(true);
    } else {
      return Future.value(false);
    }
    // } else {
    //   return Future.value(true);
    // }
  }

  // _navigateToCall() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   if (widget.isDirectToCall == true) {
  //     await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) => CallScreen(
  //                   displayName: getIt<SharedPreferences>().getString(StringConstants.userName) ?? "Unknown",
  //                   role: "0",
  //                   isJoin: true,
  //                   sessionIdleTimeoutMins: "40",
  //                   sessionName: widget.appId,
  //                   sessionPwd: 'Qwerty123',
  //                   bookingId: widget.bookId,
  //                 )));
  //     Provider.of<ChatProvider>(context, listen: false).listenToMessage(widget.appId);
  //   }
  // }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  bool isJsonString(String str) {
    try {
      jsonDecode(str);
      return true; // If jsonDecode succeeds, the string is valid JSON.
    } catch (e) {
      return false; // If jsonDecode fails, the string is not valid JSON.
    }
  }

  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: 200,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleCameraSelection();
  //               },
  //               child: Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.camera_alt_outlined),
  //                     horizontalSpace(8),
  //                     const Text('Camera'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleImageSelection();
  //               },
  //               child: Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.image_outlined),
  //                     horizontalSpace(8),
  //                     const Text('Gallery'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleFileSelection();
  //               },
  //               child: Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.file_copy_outlined),
  //                     horizontalSpace(8),
  //                     const Text('File'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.cancel_outlined),
  //                     horizontalSpace(8),
  //                     const Text('Cancel'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //   void _handleFileSelection() async {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //       allowMultiple: false,
  //     );
  //     if (result != null && result.files.single.path != null) {
  //       var res = await getIt<ChatProvider>().saveChatFile(filePath: result.files.single.path!);
  //       String fileName = result.files.single.path?.split('/').last ?? "File";
  //       if (res.status == true) {
  //         getIt<ChatProvider>().fireBSendMessage(id: const Uuid().v4(), roomId: widget.appId, type: 'File', msg: null, imageUrl: res.file, userID: _user.id, fileName: fileName, fileSize: result.files.single.size);
  //       } else {
  //         Fluttertoast.showToast(msg: res.message ?? "");
  //       }
  //     }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );=
  //   if (result != null) {
  //     var res = await getIt<ChatProvider>().saveChatFile(filePath: result.path);
  //     if (res.status == true) {
  //       getIt<ChatProvider>().fireBSendMessage(id: const Uuid().v4(), roomId: widget.appId, type: 'Image', msg: null, imageUrl: res.file, userID: _user.id);
  //     }
  //   }
  // }

  // void _handleCameraSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 60,
  //     maxWidth: 1440,
  //     source: ImageSource.camera,
  //   );
  //   if (result != null) {
  //     var res = await getIt<ChatProvider>().saveChatFile(filePath: result.path);
  //     if (res.status == true) {
  //       getIt<ChatProvider>().fireBSendMessage(id: const Uuid().v4(), roomId: widget.appId, type: 'Image', msg: null, imageUrl: res.file, userID: _user.id);
  //     }
  //   }
  // }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerPage(message.uri)),
      );
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    showComingSoonDialog(context);
    // getIt<ChatProvider>().fireBSendMessage(
    //   id: const Uuid().v4(),
    //   roomId: 'widget.appId',
    //   type: 'Text',
    //   msg: message.text,
    //   imageUrl: null,
    //   userID: _user.id,
    // );
  }

  void getNewMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      // double maxWidth = constraints.maxWidth;
      // double h1p = maxHeight * 0.01;
      // double h10p = maxHeight * 0.1;
      // double w10p = maxWidth * 0.1;
      // double w1p = maxWidth * 0.01;
      // double widthOfWid = w10p * 3;

      return Consumer<ChatProvider>(
        builder: (context, mgr, child) {
          return Container(
            height: maxHeight * 0.75,
            decoration: BoxDecoration(
              color: clrF3F3F3,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      Text(
                        "ChatBot",
                        style: t700_16.copyWith(color: clr444444),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close_rounded, color: clr444444),
                        // child: SizedBox(height: h1p * 10, child: SvgPicture.asset("assets/images/back-arrow.svg")),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Chat(
                    inputOptions: const InputOptions(
                      sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                    ),
                    // customBottomWidget: true == false
                    //     ? InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (_) => DoctorProfileScreen(
                    //                         specialityId: null,
                    //                         docId: widget.docId!,
                    //                       )));
                    //         },
                    //         child: Container(
                    //             width: w10p * 10,
                    //             color: Colours.boxblue,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(18.0),
                    //               child: Center(
                    //                   child: Text(
                    //                 "Book Again",
                    //                 style: t500_14.copyWith(color: clr444444, height: 1),
                    //               )),
                    //             )))
                    //     : null,
                    messages: mgr.messagesInChat.reversed
                        .map((e) => types.Message.fromJson(e.toJson()))
                        .toList(),
                    // onAttachmentPressed: _handleAttachmentPressed,
                    onMessageTap: _handleMessageTap,
                    onPreviewDataFetched: _handlePreviewDataFetched,
                    onSendPressed: _handleSendPressed,
                    showUserAvatars: false,
                    isAttachmentUploading: mgr.chatUploadingLoader,
                    showUserNames: false,
                    isLastPage: true,
                    user: _user,
                    onEndReached: () async {},
                    l10n: const ChatL10nEn(
                      // inputPlaceholder: "Tell me about your problem",
                      inputPlaceholder:
                          "Ask your doubts and take care your health",
                    ),
                    theme: DefaultChatTheme(
                      backgroundColor: clrF3F3F3,
                      inputBorderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      inputMargin: const EdgeInsets.all(8),
                      inputContainerDecoration: BoxDecoration(
                        color: clrFFFFFF,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(color: clr202020, width: .5),
                      ),
                      inputTextColor: clr2D2D2D,
                      secondaryColor: clr202020,
                      inputPadding: const EdgeInsets.all(4),
                      inputTextDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: t400_14.copyWith(color: clr2D2D2D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class ChatBotArguments {
  String appId;
  int? bookId;
  bool isCallAvailable;
  bool? isDirectToCall;
  bool? isPipModeActive;
  String? roomId;
  int? docId;
  bool? isfinished;
  ChatBotArguments({
    required this.appId,
    required this.docId,
    required this.isCallAvailable,
    this.isPipModeActive,
    this.isDirectToCall,
    required this.bookId,
  });
}
