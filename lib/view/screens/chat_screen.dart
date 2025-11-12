// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/chat_manager.dart';
import 'package:dqapp/view/screens/zoom_screens/call_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pip_view/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

import '../../controller/managers/state_manager.dart';
import '../../controller/services/socket_service.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';
import '../widgets/common_widgets.dart';
import 'booking_screens/booking_screen_widgets.dart';
import 'booking_screens/doctor_profile_screen.dart';
import 'drawer_menu_screens/pdf_view_screen.dart';

class ChatPage extends StatefulWidget {
  final String appId;
  final int bookId;
  final bool isCallAvailable;
  final bool? isDirectToCall;
  final bool? isPipModeActive;
  final String? roomId;
  final int? docId;
  final bool? isfinished;
  const ChatPage({
    super.key,
    required this.appId,
    required this.docId,
    required this.isCallAvailable,
    this.isPipModeActive,
    this.isDirectToCall,
    required this.bookId,
    this.roomId,
    this.isfinished,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

  final List<types.Message> _messages = [];

  final _user = types.User(
    id: '${getIt<SharedPreferences>().getInt(StringConstants.userId) ?? ''}',
  );

  late SocketService socketService;

  void connectgetSocket() {
    var data = {
      'booking_id': widget.bookId,
      'dotor_id': widget.docId,
      'app_user_id': _user.id,
      "user_type": 1,
    };

    // print('socket connect data $data');

    socketService.getMessage(data);
  }

  Future sentChat({String? message, String? file, String? type}) async {
    // _messages.add(Messages(
    //   text: message,
    //   isUserMessage: true,
    //   timestamp: DateTime.now().toString(),
    //   senderName: userSD['fullName'],
    //   avatar: userSD['avatar'] ?? '',
    //   isSent: 0,
    // ));
    // isSent = true;
    // msgController.clear();
    // if (mounted) setState(() {});
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToBottom();
    // });
    var data = {
      "booking_id": widget.bookId,
      "dotor_id": widget.docId,
      "app_user_id": _user.id,
      "user_type": 1,
      "content_type": "Text",
      "message": message,
      "file": null,
    };

    socketService.sentMessage(data);
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getIt<StateManager>().setInChatStatus(true);
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).listenToMessage(widget.appId);
    // socketService = SocketService((message) {
    //   setState(() {
    //     getIt<ChatProvider>().messagesInChat.clear();
    //     List<Messages> messagesList = [];
    //     message.map((chat) {
    //       messagesList.add(Messages.fromJson(chat));
    //     }).toList();
    //     getIt<ChatProvider>().insertMessagesIntoChat(messagesList);
    //     // loading = false;
    //     // WidgetsBinding.instance.addPostFrameCallback((_) {
    //     //   _scrollToBottom();
    //     // });
    //   });
    // });
    // socketService.connect();
    // connectgetSocket();
    _navigateToCall();
  }

  // @override
  // void dispose() {
  //   socketService.disconnect();
  //   // _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  void dispose() {
    // socketService.disconnect();
    getIt<StateManager>().setInChatStatus(false);
    getIt<ChatProvider>().disposeChat();
    super.dispose();
  }

  // @override
  // void initState() {
  //   getIt<StateManager>().setInChatStatus(true);
  //   Provider.of<ChatProvider>(context, listen: false).listenToMessage(widget.appId);
  //   _navigateToCall();
  //   super.initState();
  // }

  Future<bool> onWillPop() async {
    if (widget.isCallAvailable == true) {
      bool? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CloseAlert(msg: "Are you sure you want to close?");
        },
      );

      if (result != null) {
        getIt<BookingManager>().onLeaveSession(true);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  _navigateToCall() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (widget.isDirectToCall == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            displayName:
                getIt<SharedPreferences>().getString(
                  StringConstants.userName,
                ) ??
                "Unknown",
            role: "0",
            isJoin: true,
            sessionIdleTimeoutMins: "40",
            sessionName: widget.appId,
            sessionPwd: 'Qwerty123',
            bookingId: widget.bookId,
          ),
        ),
      );
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).listenToMessage(widget.appId);
    }
  }

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

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleCameraSelection();
              },
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_outlined),
                    horizontalSpace(8),
                    const Text('Camera'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleImageSelection();
              },
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined),
                    horizontalSpace(8),
                    const Text('Gallery'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleFileSelection();
              },
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    const Icon(Icons.file_copy_outlined),
                    horizontalSpace(8),
                    const Text('File'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined),
                    horizontalSpace(8),
                    const Text('Cancel'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      var res = await getIt<ChatProvider>().saveChatFile(
        filePath: result.files.single.path!,
      );
      // print("result.files.single.path");
      // print(result.files.single.path);
      String fileName = result.files.single.path?.split('/').last ?? "File";
      if (res.status == true) {
        getIt<ChatProvider>().fireBSendMessage(
          id: const Uuid().v4(),
          roomId: widget.appId,
          type: 'File',
          msg: null,
          imageUrl: res.file,
          userID: _user.id,
          fileName: fileName,
          fileSize: result.files.single.size,
        );
      } else {
        Fluttertoast.showToast(msg: res.message ?? "");
      }
      // final filemsg = types.FileMessage(
      //   author: _user,
      //   createdAt: DateTime.now().millisecondsSinceEpoch,
      //   id: const Uuid().v4(),
      //   mimeType: lookupMimeType(result.files.single.path!),
      //   name: result.files.single.name,
      //   size: result.files.single.size,
      //   uri: result.files.single.path!,
      // );
      //
      // // _addMessage(message);
    }

    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );
    //
    // if (result != null && result.files.single.path != null) {
    //   final message = types.FileMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     id: const Uuid().v4(),
    //     mimeType: lookupMimeType(result.files.single.path!),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: result.files.single.path!,
    //   );
    //
    //   _addMessage(message);
    // }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      var res = await getIt<ChatProvider>().saveChatFile(filePath: result.path);
      if (res.status == true) {
        getIt<ChatProvider>().fireBSendMessage(
          id: const Uuid().v4(),
          roomId: widget.appId,
          type: 'Image',
          msg: null,
          imageUrl: res.file,
          userID: _user.id,
        );
      }
    }
  }

  void _handleCameraSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 60,
      maxWidth: 1440,
      source: ImageSource.camera,
    );

    if (result != null) {
      var res = await getIt<ChatProvider>().saveChatFile(filePath: result.path);
      if (res.status == true) {
        getIt<ChatProvider>().fireBSendMessage(
          id: const Uuid().v4(),
          roomId: widget.appId,
          type: 'Image',
          msg: null,
          imageUrl: res.file,
          userID: _user.id,
        );
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerPage(message.uri)),
      );
    }
    //   var localPath = message.uri;
    //
    //   print("message.uri");
    //   print(message.uri);
    //
    //   if (message.uri.startsWith('http')) {
    //     try {
    //       final index =
    //       _messages.indexWhere((element) => element!.id == message.id);
    //       final updatedMessage =
    //       (_messages[index] as types.FileMessage).copyWith(
    //         isLoading: true,
    //       );
    //
    //       setState(() {
    //         _messages[index] = updatedMessage;
    //       });
    //
    //       final client = http.Client();
    //       final request = await client.get(Uri.parse(message.uri));
    //       final bytes = request.bodyBytes;
    //       final documentsDir = (await getApplicationDocumentsDirectory()).path;
    //       localPath = '$documentsDir/${message.name}';
    //
    //       if (!File(localPath).existsSync()) {
    //         final file = File(localPath);
    //         await file.writeAsBytes(bytes);
    //       }
    //     } finally {
    //       final index =
    //       _messages.indexWhere((element) => element.id == message.id);
    //       final updatedMessage =
    //       (_messages[index] as types.FileMessage).copyWith(
    //         isLoading: null,
    //       );
    //
    //       setState(() {
    //         _messages[index] = updatedMessage;
    //       });
    //     }
    //   }
    //
    //   // await OpenFilex.open(localPath);
    // }
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
    getIt<ChatProvider>().fireBSendMessage(
      id: const Uuid().v4(),
      roomId: widget.appId,
      type: 'Text',
      msg: message.text,
      imageUrl: null,
      userID: _user.id,
    );

    // final textMessage = types.TextMessage(
    //   author: _user,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: const Uuid().v4(),
    //   text: message.text,
    // );
    // _addMessage(textMessage);

    // sentChat(message: message.text, file: null, type: 'Text');
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

  // void _loadMessages() async {
  //   final response = await rootBundle.loadString('assets/messages.json');
  //   final messages = (jsonDecode(response) as List).map((e) => types.Message.fromJson(e as Map<String, dynamic>)).toList();
  //   setState(() {
  //     _messages = messages;
  //   });
  // }
  // Widget stack = Stack(
  //   children: [
  //     Container(
  //       height: 100,
  //       width: 70,
  //       decoration: BoxDecoration(
  //         color: const Color(0xff232323),
  //         border: Border.all(
  //           color: const Color(0xff666666),
  //           width: 1,
  //         ),
  //         borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       ),
  //       alignment: Alignment.center,
  //       // child: FlutterZoomView.View(key: Key(sharing.toString()), creationParams: creationParams),
  //     ),
  //
  //     Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //           alignment: Alignment.center,
  //           child: Column(mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Image(
  //                 image: AssetImage("assets/icons/default-avatar.png"),
  //               ),
  //               // Text("Active",style: TextStyles.textStyle11b,)
  //
  //             ],
  //           )),
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      // double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      // double widthOfWid = w10p * 3;

      return Consumer<BookingManager>(
        builder: (context, bmgr, child) {
          return WillPopScope(
            onWillPop: onWillPop,
            child: Consumer<ChatProvider>(
              builder: (context, mgr, child) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.white, // background color
                      statusBarIconBrightness: Brightness.dark, // Android
                      statusBarBrightness: Brightness.light, // iOS
                    ),

                    flexibleSpace: Container(
                      padding: const EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: w1p * 2),
                          GestureDetector(
                            onTap: () async {
                              if (widget.isPipModeActive == true) {
                                PIPView.of(context)?.stopFloating();
                                // print("clicked 200");
                                log("here");
                              } else {
                                bool result = await onWillPop();
                                if (result) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: SizedBox(
                              height: h1p * 10,
                              width: 30,
                              child: Image.asset(
                                "assets/images/back-cupertino.png",
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: w1p * 1),
                          Text(
                            "Chat",
                            style: t500_14.copyWith(color: clr444444),
                          ),
                          const Expanded(child: SizedBox()),
                          // GestureDetector(
                          //   onTap: (){

                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => AnatomyScreen(bookingId: widget.bookId,),
                          //
                          //   );
                          //
                          //
                          // },
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right:8.0),
                          //     child: Icon(Icons.man),
                          //   ),
                          // ),
                          widget.isCallAvailable == true
                              ? SizedBox(
                                  child: bmgr.callingLoader
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: CircularProgressIndicator(
                                              color: Colours.toastBlue,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            var res =
                                                await getIt<BookingManager>()
                                                    .initiateCall(
                                                      bookingId: widget.bookId,
                                                    );
                                            if (res.status == true) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => CallScreen(
                                                    displayName:
                                                        getIt<
                                                              SharedPreferences
                                                            >()
                                                            .getString(
                                                              StringConstants
                                                                  .userName,
                                                            ) ??
                                                        "No Name",
                                                    role: "0",
                                                    isJoin: true,
                                                    sessionIdleTimeoutMins:
                                                        "40",
                                                    sessionName: widget.appId,
                                                    sessionPwd: 'Qwerty123',
                                                    bookingId: widget.bookId,
                                                  ),
                                                ),
                                              );

                                              Provider.of<ChatProvider>(
                                                context,
                                                listen: false,
                                              ).listenToMessage(widget.appId);
                                            } else {
                                              showTopSnackBar(
                                                snackBarPosition:
                                                    SnackBarPosition.top,
                                                padding: const EdgeInsets.all(
                                                  30,
                                                ),
                                                Overlay.of(context),
                                                SuccessToast(
                                                  maxLines: 3,
                                                  message: res.message ?? "",
                                                ),
                                              );
                                            }
                                          },
                                          child: const Icon(
                                            Icons.video_camera_front_outlined,
                                          ),
                                        ),
                                )
                              : const SizedBox(),
                          SizedBox(width: w1p * 5),
                        ],
                      ),
                    ),
                  ),
                  body: Builder(
                    builder: (context) {
                      //                       final messages = mgr.messagesQ
                      //                           .map((e) => types.Message.fromJson(e.toJson()))
                      //                           .toList();
                      // print(messages);
                      //                       // setState(() {
                      //                       _messages = messages;
                      return Chat(
                        inputOptions: const InputOptions(
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.always,
                        ),
                        customBottomWidget: true == false
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorProfileScreen(
                                        // specialityId: widget.specialityId,
                                        specialityId: null,
                                        docId: widget.docId!,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: w10p * 10,
                                  // width: 343,height:32,
                                  color: Colours.boxblue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Center(
                                      child: Text(
                                        "Book Again",
                                        style: t500_14.copyWith(
                                          color: clr444444,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        messages: mgr.messagesInChat.reversed
                            .map((e) => types.Message.fromJson(e.toJson()))
                            .toList(),
                        onAttachmentPressed: _handleAttachmentPressed,
                        onMessageTap: _handleMessageTap,
                        onPreviewDataFetched: _handlePreviewDataFetched,
                        onSendPressed: _handleSendPressed,
                        showUserAvatars: false,
                        isAttachmentUploading: mgr.chatUploadingLoader,
                        showUserNames: false,
                        isLastPage: true,
                        user: _user,
                        onEndReached: () async {
                          // await getIt<ChatProvider>().loadMessages(roomId: 12);
                        },
                        theme: const DefaultChatTheme(
                          // seenIcon: Text(
                          //   'read',
                          //   style: TextStyle(
                          //     fontSize: 10.0,
                          //   ),
                          // ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // ),
          );
        },
      );
    },
  );
}

// class MiniCallWidget extends StatefulWidget {
//   ZoomVideoSdkUser user;
//   CallCred? cred;
//   MiniCallWidget(this.user,this.cred);
//
//   @override
//   State<MiniCallWidget> createState() => _MiniCallWidgetState();
// }
//
// class _MiniCallWidgetState extends State<MiniCallWidget> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // var cred  = Provider.of<BookingManager>(context).callCredentials;
//
//     // var eventListener = ZoomVideoSdkEventListener();
//     // var isInSession = useState(false);
//     // var sessionName = useState('');
//     // var sessionPassword = useState('');
//     // var users = useState(<ZoomVideoSdkUser>[]);
//     // var fullScreenUser = useState<ZoomVideoSdkUser?>(null);
//     // var isMuted = useState(true);
//     // var isVideoOn = useState(false);
//     // var isSpeakerOn = useState(false);
//     // var isMounted = useIsMounted();
//     // var audioStatusFlag = useState(false);
//     // var videoStatusFlag = useState(false);
//     //
//     //
//     // var zoom  = Provider.of<BookingManager>(context).zoom;
//     //
//     //
//     // useEffect(() {
//     //   Future<void>.microtask(() async {
//     //     var token = generateJwt(widget.cred!.sessionName, widget.cred!.role);
//     //     try {
//     //       Map<String, bool> SDKaudioOptions = {"connect": true, "mute": false, "autoAdjustSpeakerVolume": false};
//     //       Map<String, bool> SDKvideoOptions = {
//     //         "localVideoOn": true,
//     //       };
//     //       JoinSessionConfig joinSession = JoinSessionConfig(
//     //         sessionName: widget.cred!.sessionName,
//     //         sessionPassword: widget.cred!.sessionPwd,
//     //         token: token,
//     //         userName: widget.cred!.displayName,
//     //         audioOptions: SDKaudioOptions,
//     //         videoOptions: SDKvideoOptions,
//     //         sessionIdleTimeoutMins: int.parse(widget.cred!.sessionIdleTimeoutMins),
//     //       );
//     //       await zoom.joinSession(joinSession);
//     //     } catch (e) {
//     //       const AlertDialog(
//     //         title: Text("Error"),
//     //         content: Text("Failed to join the session"),
//     //       );
//     //       Future.delayed(const Duration(milliseconds: 1000))
//     //           .asStream()
//     //           .listen((event) {
//     //         // Navigator.popAndPushNamed(
//     //         //   context,
//     //         //   "Join",
//     //         //   arguments: JoinArguments(
//     //         //       widget.isJoin,
//     //         //     sessionName.value,
//     //         //     sessionPassword.value,
//     //         //     widget.displayName,
//     //         //     widget.sessionIdleTimeoutMins,
//     //         //     widget.role
//     //         //   ),
//     //         // );
//     //       });
//     //     }
//     //   });
//     //   return null;
//     // }, []);
//     //
//     // useEffect(() {
//     //   eventListener.addEventListener();
//     //   EventEmitter emitter = eventListener.eventEmitter;
//     //
//     //   final sessionJoinListener =
//     //   emitter.on(EventType.onSessionJoin, (sessionUser) async {
//     //     isInSession.value = true;
//     //     zoom.session
//     //         .getSessionName()
//     //         .then((value) => sessionName.value = value!);
//     //     sessionPassword.value = await zoom.session.getSessionPassword();
//     //     ZoomVideoSdkUser mySelf =
//     //     ZoomVideoSdkUser.fromJson(jsonDecode(sessionUser.toString()));
//     //     List<ZoomVideoSdkUser>? remoteUsers =
//     //     await zoom.session.getRemoteUsers();
//     //     var muted = await mySelf.audioStatus?.isMuted();
//     //     var videoOn = await mySelf.videoStatus?.isOn();
//     //     var speakerOn = await zoom.audioHelper.getSpeakerStatus();
//     //     fullScreenUser.value = mySelf;
//     //     remoteUsers?.insert(0, mySelf);
//     //     isMuted.value = muted!;
//     //     isSpeakerOn.value = speakerOn;
//     //     isVideoOn.value = videoOn!;
//     //     users.value = remoteUsers!;
//     //
//     //   });
//     //
//     //   final sessionLeaveListener =
//     //   emitter.on(EventType.onSessionLeave, (data) async {
//     //     isInSession.value = false;
//     //     users.value = <ZoomVideoSdkUser>[];
//     //     fullScreenUser.value = null;
//     //     Navigator.pop(context);
//     //     //   context,
//     //     //   "Join",
//     //     //   arguments: JoinArguments(
//     //     //       widget.isJoin,
//     //     //       sessionName.value,
//     //     //       sessionPassword.value,
//     //     //       widget.displayName,
//     //     //       widget.sessionIdleTimeoutMins,
//     //     //       widget.role
//     //     //   ),
//     //     // );
//     //   });
//     //
//     //   final sessionNeedPasswordListener =
//     //   emitter.on(EventType.onSessionNeedPassword, (data) async {
//     //     showDialog<String>(
//     //       context: context,
//     //       builder: (BuildContext context) => AlertDialog(
//     //         title: const Text('Session Need Password'),
//     //         content: const Text('Password is required'),
//     //         actions: <Widget>[
//     //           TextButton(onPressed: (){},
//     //             // onPressed: () async => {
//     //             //   Navigator.popAndPushNamed(
//     //             //     context,
//     //             //     'Join',
//     //             //     arguments: JoinArguments(
//     //             //         widget.isJoin,
//     //             //         widget.sessionName,
//     //             //         "",
//     //             //         widget.displayName,
//     //             //         widget.sessionIdleTimeoutMins,
//     //             //         widget.role
//     //             //     )),
//     //             //   await zoom.leaveSession(false),
//     //             // },
//     //             child: const Text('OK'),
//     //           ),
//     //         ],
//     //       ),
//     //     );
//     //   });
//     //
//     //   final sessionPasswordWrongListener =
//     //   emitter.on(EventType.onSessionPasswordWrong, (data) async {
//     //     showDialog<String>(
//     //       context: context,
//     //       builder: (BuildContext context) => AlertDialog(
//     //         title: const Text('Session Password Incorrect'),
//     //         content: const Text('Password is wrong'),
//     //         actions: <Widget>[
//     //           TextButton(onPressed: (){},
//     //             // onPressed: () async => {Navigator.popAndPushNamed(
//     //             //     context,
//     //             //     'Join',
//     //             //     arguments: JoinArguments(
//     //             //         widget.isJoin,
//     //             //         widget.sessionName,
//     //             //         "",
//     //             //         widget.displayName,
//     //             //         widget.sessionIdleTimeoutMins,
//     //             //         widget.role
//     //             //     )),
//     //             //   await zoom.leaveSession(false),
//     //             // },
//     //             child: const Text('OK'),
//     //           ),
//     //         ],
//     //       ),
//     //     );
//     //   });
//     //
//     //   final userVideoStatusChangedListener =
//     //   emitter.on(EventType.onUserVideoStatusChanged, (data) async {
//     //     data = data as Map;
//     //     ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //     var userListJson = jsonDecode(data['changedUsers']) as List;
//     //     List<ZoomVideoSdkUser> userList = userListJson
//     //         .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
//     //         .toList();
//     //     for (var user in userList) {
//     //       {
//     //         if (user.userId == mySelf?.userId) {
//     //           mySelf?.videoStatus?.isOn().then((on) => isVideoOn.value = on);
//     //         }
//     //       }
//     //     }
//     //     videoStatusFlag.value = !videoStatusFlag.value;
//     //   });
//     //
//     //   final userAudioStatusChangedListener =
//     //   emitter.on(EventType.onUserAudioStatusChanged, (data) async {
//     //     data = data as Map;
//     //     ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //     var userListJson = jsonDecode(data['changedUsers']) as List;
//     //     List<ZoomVideoSdkUser> userList = userListJson
//     //         .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
//     //         .toList();
//     //     for (var user in userList) {
//     //       {
//     //         if (user.userId == mySelf?.userId) {
//     //           mySelf?.audioStatus
//     //               ?.isMuted()
//     //               .then((muted) => isMuted.value = muted);
//     //         }
//     //       }
//     //     }
//     //     audioStatusFlag.value = !audioStatusFlag.value;
//     //   });
//     //
//     //
//     //
//     //   final userJoinListener = emitter.on(EventType.onUserJoin, (data) async {
//     //     if (!isMounted()) return;
//     //     data = data as Map;
//     //     ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //     var userListJson = jsonDecode(data['remoteUsers']) as List;
//     //     List<ZoomVideoSdkUser> remoteUserList = userListJson
//     //         .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
//     //         .toList();
//     //     remoteUserList.insert(0, mySelf!);
//     //     users.value = remoteUserList;
//     //   });
//     //   void onLeaveSession(bool isEndSession) async {
//     //     await zoom.leaveSession(isEndSession);
//     //     // Navigator.pop(context);
//     //   }
//     //
//     //   final userLeaveListener = emitter.on(EventType.onUserLeave, (data) async {
//     //     if (!isMounted()) return;
//     //     ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //     data = data as Map;
//     //     var remoteUserListJson = jsonDecode(data['remoteUsers']) as List;
//     //     List<ZoomVideoSdkUser> remoteUserList = remoteUserListJson
//     //         .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
//     //         .toList();
//     //     var leftUserListJson = jsonDecode(data['leftUsers']) as List;
//     //     List<ZoomVideoSdkUser> leftUserLis = leftUserListJson
//     //         .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
//     //         .toList();
//     //     if (fullScreenUser.value != null) {
//     //       for (var user in leftUserLis) {
//     //         {
//     //           if (fullScreenUser.value?.userId == user.userId) {
//     //             fullScreenUser.value = mySelf;
//     //           }
//     //         }
//     //       }
//     //     } else {
//     //       fullScreenUser.value = mySelf;
//     //
//     //     }
//     //     bool val = getIt<StateManager>().getSheetOpenStatus();
//     //
//     //     if(remoteUserList.isEmpty&& val==false){
//     //       remoteUserList.add(mySelf!);
//     //       users.value = [];
//     //       // onLeaveSession(true) ;
//     //     }else{
//     //       remoteUserList.add(mySelf!);
//     //       // users.value = remoteUserList;
//     //       users.value = [];
//     //
//     //     }
//     //   });
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //   final requireSystemPermission =
//     //   emitter.on(EventType.onRequireSystemPermission, (data) async {
//     //     data = data as Map;
//     //
//     //     var permissionType = data['permissionType'];
//     //     switch (permissionType) {
//     //       case SystemPermissionType.Camera:
//     //         showDialog<String>(
//     //           context: context,
//     //           builder: (BuildContext context) => AlertDialog(
//     //             title: const Text("Can't Access Camera"),
//     //             content: const Text(
//     //                 "please turn on the toggle in system settings to grant permission"),
//     //             actions: <Widget>[
//     //               TextButton(
//     //                 onPressed: () => Navigator.pop(context, 'OK'),
//     //                 child: const Text('OK'),
//     //               ),
//     //             ],
//     //           ),
//     //         );
//     //         break;
//     //       case SystemPermissionType.Microphone:
//     //         showDialog<String>(
//     //           context: context,
//     //           builder: (BuildContext context) => AlertDialog(
//     //             title: const Text("Can't Access Microphone"),
//     //             content: const Text(
//     //                 "please turn on the toggle in system settings to grant permission"),
//     //             actions: <Widget>[
//     //               TextButton(
//     //                 onPressed: () => Navigator.pop(context, 'OK'),
//     //                 child: const Text('OK'),
//     //               ),
//     //             ],
//     //           ),
//     //         );
//     //         break;
//     //     }
//     //   });
//     //
//     //
//     //
//     //   final eventErrorListener = emitter.on(EventType.onError, (data) async {
//     //     data = data as Map;
//     //     String errorType = data['errorType'];
//     //     showDialog<String>(
//     //       context: context,
//     //       builder: (BuildContext context) => AlertDialog(
//     //         title: const Text("Error"),
//     //         content: Text(errorType),
//     //         actions: <Widget>[
//     //           TextButton(
//     //             onPressed: () => Navigator.pop(context, 'OK'),
//     //             child: const Text('OK'),
//     //           ),
//     //         ],
//     //       ),
//     //     );
//     //     if (errorType == Errors.SessionJoinFailed ||
//     //         errorType == Errors.SessionDisconncting) {
//     //       // Timer(
//     //       //     const Duration(milliseconds: 1000),
//     //       //         () => {
//     //       //       Navigator.popAndPushNamed(
//     //       //         context,
//     //       //         "Join",
//     //       //         arguments: JoinArguments(
//     //       //             widget.isJoin,
//     //       //             sessionName.value,
//     //       //             sessionPassword.value,
//     //       //             widget.displayName,
//     //       //             widget.sessionIdleTimeoutMins,
//     //       //             widget.role
//     //       //         ),
//     //       //       ),
//     //       //     });
//     //     }
//     //   });
//     //
//     //
//     //
//     //   final callCRCDeviceStatusListener =
//     //   emitter.on(EventType.onCallCRCDeviceStatusChanged, (data) async {
//     //     data = data as Map;
//     //     debugPrint('onCallCRCDeviceStatusChanged: status = ${data['status']}');
//     //   });
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //   return () => {
//     //     sessionJoinListener.cancel(),
//     //     sessionLeaveListener.cancel(),
//     //     sessionPasswordWrongListener.cancel(),
//     //     sessionNeedPasswordListener.cancel(),
//     //     userVideoStatusChangedListener.cancel(),
//     //     userAudioStatusChangedListener.cancel(),
//     //     userJoinListener.cancel(),
//     //     userLeaveListener.cancel(),
//     //     eventErrorListener.cancel(),
//     //     requireSystemPermission.cancel(),
//     //     callCRCDeviceStatusListener.cancel(),
//     //   };
//     // }, [zoom, users.value, isMounted]);
//     //
//     //
//     //
//     // void onPressAudio() async {
//     //   ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //   if (mySelf != null) {
//     //     final audioStatus = mySelf.audioStatus;
//     //     if (audioStatus != null) {
//     //       var muted = await audioStatus.isMuted();
//     //       if (muted) {
//     //         await zoom.audioHelper.unMuteAudio(mySelf.userId);
//     //       } else {
//     //         await zoom.audioHelper.muteAudio(mySelf.userId);
//     //       }
//     //     }
//     //   }
//     // }
//     //
//     // void onPressVideo() async {
//     //   ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
//     //   if (mySelf != null) {
//     //     final videoStatus = mySelf.videoStatus;
//     //     if (videoStatus != null) {
//     //       var videoOn = await videoStatus.isOn();
//     //       if (videoOn) {
//     //         await zoom.videoHelper.stopVideo();
//     //       } else {
//     //         await zoom.videoHelper.startVideo();
//     //       }
//     //     }
//     //   }
//     // }
//     //
//     //
//     //
//     //
//     //
//     //
//
//
//
//     Widget stackt = Stack(
//       children: [
//         Container(
//           height: 100,
//           width: 70,
//           decoration: BoxDecoration(
//             color: const Color(0xff232323),
//             border: Border.all(
//               color: const Color(0xff666666),
//               width: 1,
//             ),
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//           ),
//           alignment: Alignment.center,
//           // child: FlutterZoomView.View(key: Key(sharing.toString()), creationParams: creationParams),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               alignment: Alignment.center,
//               child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Image(
//                     image: AssetImage("assets/icons/default-avatar.png"),
//                   ),
//                   // Text("Active",style: TextStyles.textStyle11b,)
//
//                 ],
//               )),
//         ),
//       ],
//     );
//
//
//
//
//
//     return  Stack(
//       children: [
//         VideoView(
//           user: widget.user,
//           hasMultiCamera: false,
//           isPiPView: true,
//           sharing: false,
//           preview: false,
//           focused: false,
//           multiCameraIndex: "0",
//           videoAspect: VideoAspect.Original,
//           fullScreen: false,
//           resolution: VideoResolution.Resolution180,
//         )
//       ],
//     );
//   }
// }
//

class ChatPageArguments {
  String appId;
  int? bookId;
  bool isCallAvailable;
  bool? isDirectToCall;
  bool? isPipModeActive;

  String? roomId;
  int? docId;
  bool? isfinished;
  ChatPageArguments({
    required this.appId,
    required this.docId,
    required this.isCallAvailable,
    this.isPipModeActive,
    this.isDirectToCall,
    required this.bookId,
  });
}
