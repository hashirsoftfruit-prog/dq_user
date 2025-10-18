import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dqapp/view/screens/zoom_screens/utils/jwt.dart';
import 'package:dqapp/view/screens/zoom_screens/video_view.dart';
import 'package:entry/entry.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pip_view/pip_view.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:provider/provider.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../chat_screen.dart';

class CallScreen extends StatefulHookWidget {
  final bool isJoin;
  final String sessionName;
  final String sessionPwd;
  final String displayName;
  final String sessionIdleTimeoutMins;
  final String role;
  final int bookingId;

  const CallScreen({
    super.key,
    required this.sessionName,
    required this.sessionPwd,
    required this.displayName,
    required this.sessionIdleTimeoutMins,
    required this.role,
    required this.bookingId,
    required this.isJoin,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  var zoom = ZoomVideoSdk();
  final FluWakeLock _fluWakeLock = FluWakeLock();

  // static TextEditingController changeNameController = TextEditingController();
  double opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  void dispose() {
    _fluWakeLock.disable();

    // zoom.leaveSession(true);
    getIt<StateManager>().setInCallStatus(false);
    // getIt<BookingManager>().onLeaveSession(true,fromCall: true);
    super.dispose();
  }

  Map<String, List<Permission>> platformPermissions = {
    "ios": [Permission.camera, Permission.microphone],
    "android": [Permission.camera, Permission.microphone],
  };

  Future<void> requestFilePermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {}
    List<Permission>? notGranted = [];
    List<Permission>? permissions = Platform.isAndroid
        ? platformPermissions["android"]
        : platformPermissions["ios"];
    Map<Permission, PermissionStatus>? statuses = await permissions?.request();
    statuses!.forEach((key, status) {
      log("permission stats $key is $status");
      if (status.isDenied) {
      } else if (!status.isGranted) {
        notGranted.add(key);
      }
    });

    if (notGranted.isNotEmpty) {
      notGranted.request();
    }
  }

  @override
  void initState() {
    requestFilePermission();

    _fluWakeLock.enable();

    getIt<StateManager>().setInCallStatus(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCallEnded = Provider.of<StateManager>(context).showCallEnded;

    var bxDec = const BoxDecoration(
      shape: BoxShape.circle,
      color: Colours.primaryblue,
    );
    var bxDec2 = const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xfff03a14),
    );

    var eventListener = ZoomVideoSdkEventListener();
    var isInSession = useState(false);
    var sessionName = useState('');
    var sessionPassword = useState('');
    var users = useState(<ZoomVideoSdkUser>[]);
    var fullScreenUser = useState<ZoomVideoSdkUser?>(null);
    var sharingUser = useState<ZoomVideoSdkUser?>(null);
    var isSharing = useState(false);
    var isMuted = useState(true);
    var isVideoOn = useState(false);
    var isSpeakerOn = useState(false);

    var isMounted = useIsMounted();
    var audioStatusFlag = useState(false);
    var videoStatusFlag = useState(false);
    var userNameFlag = useState(false);
    var userShareStatusFlag = useState(false);
    var isReceiveSpokenLanguageContentEnabled = useState(false);

    var isPiPView = useState(false);

    var circleButtonSize = 65.0;
    useEffect(() {
      Future<void>.microtask(() async {
        var token = generateJwt(widget.sessionName, widget.role);
        try {
          Map<String, bool> sdkAudioOptions = {
            "connect": true,
            "mute": false,
            "autoAdjustSpeakerVolume": false,
          };
          Map<String, bool> sdkVideoOptions = {"localVideoOn": true};
          JoinSessionConfig joinSession = JoinSessionConfig(
            sessionName: widget.sessionName,
            sessionPassword: widget.sessionPwd,
            token: token,
            userName: widget.displayName,
            audioOptions: sdkAudioOptions,
            videoOptions: sdkVideoOptions,
            sessionIdleTimeoutMins: int.parse(widget.sessionIdleTimeoutMins),
          );
          await zoom.joinSession(joinSession);
        } catch (e) {
          const AlertDialog(
            title: Text("Error"),
            content: Text("Failed to join the session"),
          );
          Future.delayed(
            const Duration(milliseconds: 1000),
          ).asStream().listen((event) {});
        }
      });
      return null;
    }, []);

    useEffect(() {
      void onLeaveSession(bool isEndSession) async {
        await zoom.leaveSession(isEndSession);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }

      final sessionJoinListener = eventListener.eventEmitter.addListener(
        EventType.onSessionJoin,
        (sessionUser) async {
          List<ZoomVideoSdkUser>? remoteUsers = await zoom.session
              .getRemoteUsers();
          if (remoteUsers != null && remoteUsers.length > 1) {
            isInSession.value = false;
            onLeaveSession(true);
            showTopSnackBar(
              snackBarPosition: SnackBarPosition.bottom,
              padding: const EdgeInsets.all(30),
              Overlay.of(context),
              const ErrorToast(
                maxLines: 3,
                message: "You are already in the call from other device",
              ),
            );
          } else {
            isInSession.value = true;
            zoom.session.getSessionName().then(
              (value) => sessionName.value = value!,
            );
            sessionPassword.value = await zoom.session.getSessionPassword();
            ZoomVideoSdkUser mySelf = ZoomVideoSdkUser.fromJson(
              jsonDecode(sessionUser.toString()),
            );
            var muted = await mySelf.audioStatus?.isMuted();
            var videoOn = await mySelf.videoStatus?.isOn();
            var speakerOn = await zoom.audioHelper.getSpeakerStatus();
            fullScreenUser.value = mySelf;
            remoteUsers?.insert(0, mySelf);
            isMuted.value = muted!;
            isSpeakerOn.value = speakerOn;
            isVideoOn.value = videoOn!;
            users.value = remoteUsers!;
            isReceiveSpokenLanguageContentEnabled.value = await zoom
                .liveTranscriptionHelper
                .isReceiveSpokenLanguageContentEnabled();
          }
        },
      );

      final sessionLeaveListener = eventListener.eventEmitter.addListener(
        EventType.onSessionLeave,
        (data) async {
          isInSession.value = false;
          users.value = <ZoomVideoSdkUser>[];
          fullScreenUser.value = null;
          Navigator.pop(context);
        },
      );

      final sessionNeedPasswordListener = eventListener.eventEmitter
          .addListener(EventType.onSessionNeedPassword, (data) async {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Session Need Password'),
                content: const Text('Password is required'),
                actions: <Widget>[
                  TextButton(onPressed: () {}, child: const Text('OK')),
                ],
              ),
            );
          });

      final sessionPasswordWrongListener = eventListener.eventEmitter
          .addListener(EventType.onSessionPasswordWrong, (data) async {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Session Password Incorrect'),
                content: const Text('Password is wrong'),
                actions: <Widget>[
                  TextButton(onPressed: () {}, child: const Text('OK')),
                ],
              ),
            );
          });

      final userVideoStatusChangedListener = eventListener.eventEmitter
          .addListener(EventType.onUserVideoStatusChanged, (data) async {
            data = data as Map;
            ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
            var userListJson = jsonDecode(data['changedUsers']) as List;
            List<ZoomVideoSdkUser> userList = userListJson
                .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
                .toList();
            for (var user in userList) {
              {
                if (user.userId == mySelf?.userId) {
                  mySelf?.videoStatus?.isOn().then(
                    (on) => isVideoOn.value = on,
                  );
                }
              }
            }
            videoStatusFlag.value = !videoStatusFlag.value;
          });

      final userAudioStatusChangedListener = eventListener.eventEmitter
          .addListener(EventType.onUserAudioStatusChanged, (data) async {
            data = data as Map;
            ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
            var userListJson = jsonDecode(data['changedUsers']) as List;
            List<ZoomVideoSdkUser> userList = userListJson
                .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
                .toList();
            for (var user in userList) {
              {
                if (user.userId == mySelf?.userId) {
                  mySelf?.audioStatus?.isMuted().then(
                    (muted) => isMuted.value = muted,
                  );
                }
              }
            }
            audioStatusFlag.value = !audioStatusFlag.value;
          });

      final userShareStatusChangeListener = eventListener.eventEmitter
          .addListener(EventType.onUserShareStatusChanged, (data) async {
            data = data as Map;
            ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
            ZoomVideoSdkUser shareUser = ZoomVideoSdkUser.fromJson(
              jsonDecode(data['user'].toString()),
            );

            if (data['status'] == ShareStatus.Start) {
              sharingUser.value = shareUser;
              fullScreenUser.value = shareUser;
              isSharing.value = (shareUser.userId == mySelf?.userId);
            } else {
              sharingUser.value = null;
              isSharing.value = false;
              fullScreenUser.value = mySelf;
            }
            userShareStatusFlag.value = !userShareStatusFlag.value;
          });

      final userJoinListener = eventListener.eventEmitter.addListener(
        EventType.onUserJoin,
        (data) async {
          if (!isMounted()) return;
          data = data as Map;
          ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
          var userListJson = jsonDecode(data['remoteUsers']) as List;
          List<ZoomVideoSdkUser> remoteUserList = userListJson
              .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
              .toList();
          remoteUserList.insert(0, mySelf!);

          users.value = remoteUserList;
        },
      );

      final userLeaveListener = eventListener.eventEmitter.addListener(
        EventType.onUserLeave,
        (data) async {
          if (!isMounted()) return;
          ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();

          data = data as Map;
          var remoteUserListJson = jsonDecode(data['remoteUsers']) as List;
          List<ZoomVideoSdkUser> remoteUserList = remoteUserListJson
              .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
              .toList();
          var leftUserListJson = jsonDecode(data['leftUsers']) as List;
          List<ZoomVideoSdkUser> leftUserLis = leftUserListJson
              .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
              .toList();
          if (fullScreenUser.value != null) {
            for (var user in leftUserLis) {
              {
                if (fullScreenUser.value?.userId == user.userId) {
                  fullScreenUser.value = mySelf;
                }
              }
            }
          } else {
            fullScreenUser.value = mySelf;
          }
          if (remoteUserList.isEmpty) {
            users.value = [];
            await getIt<StateManager>().setCallEndedStatus();
            onLeaveSession(true);
          } else {
            remoteUserList.add(mySelf!);
            users.value = [];
          }
        },
      );

      final userNameChangedListener = eventListener.eventEmitter.addListener(
        EventType.onUserNameChanged,
        (data) async {
          if (!isMounted()) return;
          data = data as Map;
          ZoomVideoSdkUser? changedUser = ZoomVideoSdkUser.fromJson(
            jsonDecode(data['changedUser']),
          );
          int index;
          for (var user in users.value) {
            if (user.userId == changedUser.userId) {
              index = users.value.indexOf(user);
              users.value[index] = changedUser;
            }
          }
          userNameFlag.value = !userNameFlag.value;
        },
      );

      final requireSystemPermission = eventListener.eventEmitter.addListener(
        EventType.onRequireSystemPermission,
        (data) async {
          data = data as Map;
          var permissionType = data['permissionType'];
          switch (permissionType) {
            case SystemPermissionType.Camera:
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Can't Access Camera"),
                  content: const Text(
                    "please turn on the toggle in system settings to grant permission",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              break;
            case SystemPermissionType.Microphone:
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Can't Access Microphone"),
                  content: const Text(
                    "please turn on the toggle in system settings to grant permission",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              break;
          }
        },
      );

      final networkStatusChangeListener = eventListener.eventEmitter.addListener(
        EventType.onUserVideoNetworkStatusChanged,
        (data) async {
          data = data as Map;
          ZoomVideoSdkUser? networkUser = ZoomVideoSdkUser.fromJson(
            jsonDecode(data['user']),
          );

          if (data['status'] == NetworkStatus.Bad) {
            debugPrint(
              "onUserVideoNetworkStatusChanged: status: ${data['status']}, user: ${networkUser.userName}",
            );
          }
        },
      );

      final eventErrorListener = eventListener.eventEmitter.addListener(
        EventType.onError,
        (data) async {
          log("zoom error $data");
          data = data as Map;
          String errorType = data['errorType'];
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Error"),
              content: Text(errorType),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          if (errorType == Errors.SessionJoinFailed ||
              errorType == Errors.SessionDisconnecting) {}
        },
      );

      final testMicStatusListener = eventListener.eventEmitter.addListener(
        EventType.onTestMicStatusChanged,
        (data) async {
          data = data as Map;
          String status = data['status'];
          debugPrint('testMicStatusListener: status= $status');
        },
      );

      final micSpeakerVolumeChangedListener = eventListener.eventEmitter
          .addListener(EventType.onMicSpeakerVolumeChanged, (data) async {
            data = data as Map;
            int type = data['micVolume'];
            debugPrint(
              'onMicSpeakerVolumeChanged: micVolume= $type, speakerVolume',
            );
          });

      final cameraControlRequestResultListener = eventListener.eventEmitter
          .addListener(EventType.onCameraControlRequestResult, (data) async {
            data = data as Map;
            bool approved = data['approved'];
            debugPrint('onCameraControlRequestResult: approved= $approved');
          });

      return () => {
        sessionJoinListener.cancel(),
        sessionLeaveListener.cancel(),
        sessionPasswordWrongListener.cancel(),
        sessionNeedPasswordListener.cancel(),
        userVideoStatusChangedListener.cancel(),
        userAudioStatusChangedListener.cancel(),
        userJoinListener.cancel(),
        userLeaveListener.cancel(),
        userNameChangedListener.cancel(),
        userShareStatusChangeListener.cancel(),

        eventErrorListener.cancel(),

        requireSystemPermission.cancel(),
        networkStatusChangeListener.cancel(),
        testMicStatusListener.cancel(),
        micSpeakerVolumeChangedListener.cancel(),
        cameraControlRequestResultListener.cancel(),
      };
    }, [zoom, users.value, isMounted]);

    void onPressAudio() async {
      ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
      if (mySelf != null) {
        final audioStatus = mySelf.audioStatus;
        if (audioStatus != null) {
          var muted = await audioStatus.isMuted();
          if (muted) {
            await zoom.audioHelper.unMuteAudio(mySelf.userId);
          } else {
            await zoom.audioHelper.muteAudio(mySelf.userId);
          }
        }
      }
    }

    void onPressVideo() async {
      try {
        ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();

        if (mySelf != null) {
          final videoStatus = mySelf.videoStatus;
          if (videoStatus != null) {
            var videoOn = await videoStatus.isOn();
            if (videoOn) {
              await zoom.videoHelper.stopVideo();
            } else {
              final status = await zoom.videoHelper.startVideo();
              log(status);
            }
          }
        }
      } on Exception catch (e) {
        log("video on off error $e");
      }
    }

    void onLeaveSession(bool isEndSession) async {
      if (isInSession.value) {
        await zoom.leaveSession(isEndSession);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

    void showLeaveOptions() async {
      Widget leaveSession;
      Widget cancel = TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context); //close Dialog
        },
      );

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          leaveSession = TextButton(
            child: const Text('Leave Session'),
            onPressed: () => onLeaveSession(true),
          );
          break;
        default:
          leaveSession = CupertinoActionSheetAction(
            child: const Text('Leave Session'),
            onPressed: () => onLeaveSession(true),
          );
          break;
      }

      List<Widget> options = [leaveSession, cancel];

      if (Platform.isAndroid) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text("Do you want to leave this session?"),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              actions: options,
            );
          },
        );
      } else {
        options.removeAt(1);
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            message: const Text(
              'Are you sure that you want to leave the session?',
            ),
            actions: options,
            cancelButton: cancel,
          ),
        );
      }
    }

    Widget fullScreenView;
    Widget smallView;

    if (isInSession.value && users.value.isNotEmpty) {
      fullScreenUser.value = users.value.last;
      fullScreenView = AnimatedOpacity(
        opacity: opacityLevel,
        duration: const Duration(seconds: 3),
        child: VideoView(
          user: fullScreenUser.value,
          hasMultiCamera: false,
          isPiPView: isPiPView.value,
          sharing: sharingUser.value == null
              ? false
              : (sharingUser.value?.userId == fullScreenUser.value?.userId),
          preview: false,
          focused: false,
          multiCameraIndex: "0",
          videoAspect: VideoAspect.Original,
          fullScreen: true,
          resolution: VideoResolution.Resolution360,
        ),
      );
    } else {
      fullScreenView = Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "You are the only one here in this call",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
      smallView = Container(height: 110, color: Colors.transparent);
    }

    if (isInSession.value && users.value.isNotEmpty && users.value.length > 1) {
      smallView = Container(
        height: 110,
        margin: const EdgeInsets.only(left: 20, right: 20),
        // alignment: Alignment.center,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: users.value.length,
          itemBuilder: (BuildContext context, int index) {
            if (users.value[index].userId == fullScreenUser.value?.userId) {
              return const SizedBox();
            }
            return InkWell(
              onTap: () async {},
              onDoubleTap: () async {},
              child: Center(
                child: VideoView(
                  user: users.value[index],
                  hasMultiCamera: false,
                  isPiPView: false,
                  sharing: false,
                  preview: false,
                  focused: false,
                  multiCameraIndex: "0",
                  videoAspect: VideoAspect.Original,
                  fullScreen: false,
                  resolution: VideoResolution.Resolution180,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
    } else {
      fullScreenView = Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Connecting...",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
      smallView = Container(height: 110, color: Colors.transparent);
    }

    _changeOpacity;
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double w1p = maxWidth * 0.01;
        return PIPView(
          floatingWidth: w1p * 30,
          floatingHeight: w1p * 45,
          avoidKeyboard: true,
          builder: (context, isFloating) {
            return WillPopScope(
              onWillPop: () async {
                if (isFloating) {
                  PIPView.of(context)?.stopFloating(); // Close PiP mode
                  return false; // Prevent back navigation
                }
                showLeaveOptions();
                return false; // Prevent back navigation
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.black,
                body: isCallEnded == true
                    ? const CallDisconnectedScreen()
                    : Stack(
                        children: [
                          fullScreenView,
                          isFloating == true
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.only(top: 35),
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.topRight,
                                        margin: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [smallView],
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          children: [
                                            const Spacer(),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      // onPressMore,
                                                      onPressAudio,
                                                  child: SizedBox(
                                                    // color:Colors.black38,
                                                    child: isMuted.value
                                                        ? Image.asset(
                                                            "assets/zoom-icons/mic-mute.png",
                                                          )
                                                        : Image.asset(
                                                            "assets/zoom-icons/mic-unmute.png",
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            verticalSpace(8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: onPressVideo,
                                                  iconSize: circleButtonSize,
                                                  icon: Container(
                                                    height: h1p * 8,
                                                    width: h1p * 8,
                                                    padding: EdgeInsets.all(
                                                      h1p * 2.5,
                                                    ),
                                                    decoration: bxDec,
                                                    child: isVideoOn.value
                                                        ? Image.asset(
                                                            "assets/zoom-icons/video-on.png",
                                                          )
                                                        : Image.asset(
                                                            "assets/zoom-icons/video-off.png",
                                                          ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: (showLeaveOptions),
                                                  child: Container(
                                                    height: h1p * 10,
                                                    width: h1p * 10,
                                                    // padding: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(
                                                      h1p * 3,
                                                    ),
                                                    decoration: bxDec2,
                                                    child: Image.asset(
                                                      "assets/zoom-icons/rejectbtn.png",
                                                      height: h1p * 3,
                                                    ),
                                                  ),
                                                ),

                                                IconButton(
                                                  onPressed: () async {
                                                    PIPView.of(
                                                      context,
                                                    )!.presentBelow(
                                                      ChatPage(
                                                        appId:
                                                            widget.sessionName,
                                                        bookId:
                                                            widget.bookingId,
                                                        isPipModeActive: true,
                                                        isCallAvailable: false,
                                                        docId: null,
                                                      ),
                                                    );
                                                    if (users
                                                        .value
                                                        .isNotEmpty) {}
                                                  },
                                                  iconSize: circleButtonSize,
                                                  icon: Container(
                                                    height: h1p * 8,
                                                    width: h1p * 8,
                                                    padding: EdgeInsets.all(
                                                      h1p * 2.5,
                                                    ),
                                                    decoration: bxDec,
                                                    child: Image.asset(
                                                      "assets/images/chat-icon.png",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: h1p * 3),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class CallDisconnectedScreen extends StatelessWidget {
  const CallDisconnectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color(0xFF232323)),
      child: Entry(
        yOffset: 100,
        delay: const Duration(milliseconds: 1),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.ease,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              child: Image.asset(
                "assets/images/call-ended-icon.png",
                color: Colors.white,
              ),
            ),
            verticalSpace(8),
            Text(
              "Call Disconnected",
              style: t500_18.copyWith(color: const Color(0xffffffff)),
            ),
          ],
        ),
      ),
    );
  }
}
