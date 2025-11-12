import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dqapp/model/helper/text_to_speech.dart';
import 'package:dqapp/view/screens/anatomy_screen.dart';
import 'package:dqapp/view/screens/booking_screens/booking_screen_widgets.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'controller/managers/home_manager.dart';
import 'controller/managers/state_manager.dart';
import 'model/helper/service_locator.dart';

/// Single, global plugin
final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

//we are using multiple notification channel to show different type of notification and sound (sounds are stored on android/app/src/main/res/raw)
/// ANDROID CHANNELS
const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'General notifications',
  importance: Importance.high,
);

const AndroidNotificationChannel medicineEn = AndroidNotificationChannel(
  'medicine_alert_in_en',
  'Medicine Alert in EN',
  description: 'Medicine Alert in EN',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('medicine_en'),
);

const AndroidNotificationChannel medicineMl = AndroidNotificationChannel(
  'medicine_alert_in_ml',
  'Medicine Alert in ML',
  description: 'Medicine Alert in ML',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('medicine_ml'),
);

const AndroidNotificationChannel silentChannel = AndroidNotificationChannel(
  'silent_channel',
  'Silent Notifications',
  description: 'This channel is used for notifications without sound.',
  importance: Importance.high,
  playSound: false,
  enableVibration: true,
);

const AndroidNotificationChannel scheduledIn10Channel =
    AndroidNotificationChannel(
      'booking_alert_in_10',
      'Booking in 10 Notifications',
      description: 'Reminders with custom sound',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('today'),
    );

// iOS Channels
const DarwinNotificationDetails defaultDarwinDetails =
    DarwinNotificationDetails(
      categoryIdentifier: 'default_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

const DarwinNotificationDetails scheduledIn10DarwinDetails =
    DarwinNotificationDetails(
      categoryIdentifier: 'booking_alert_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'booking_alert_in_10.aiff',
    );

/// Background isolate handler
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  if (message.notification == null) {
    await NotificationService.instance.showFromMessage(message);
  }
  NotificationService.instance.handleAction(message);
}

/// Notification tap handler (terminated state)
@pragma('vm:entry-point')
Future<void> notificationTapBackgroundHandler(
  NotificationResponse response,
) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  final payload = response.payload;
  if (payload != null) {
    final msg = RemoteMessage.fromMap(jsonDecode(payload));
    NotificationService.instance.handleAction(msg);
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await Firebase.initializeApp();
    final settings = await _messaging.requestPermission();
    if (kDebugMode) {
      log('Authorization status: ${settings.authorizationStatus}');
    }
    await _initLocal();
    await _initPush();
  }

  Future<void> _initLocal() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) async {
        final msg = RemoteMessage.fromMap(jsonDecode(payload.payload!));

        /// Performs the appropriate action depending on the notification type.
        handleAction(msg);
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackgroundHandler,
    );

    final android = localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    //we are using multiple notification channel to show different type of notification and sound (sounds are stored on android/app/src/main/res/raw)
    await android?.createNotificationChannel(defaultChannel);
    await android?.createNotificationChannel(medicineEn);
    await android?.createNotificationChannel(medicineMl);
    await android?.createNotificationChannel(silentChannel);
    await android?.createNotificationChannel(scheduledIn10Channel);

    final ios = localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _initPush() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // Tapped from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) handleAction(m);
    });

    // Tapped from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleAction);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((m) async {
      log("notification message ${m.data}");

      if (m.notification == null) return;
      
      //medicine alert
      if (m.data['type'] == "medicine_alert_in_en" ||
          m.data['type'] == "medicine_alert_in_ml") {
        TextToSpeech.instance.playSound(
          m.data["medicines"],
          m.data["language"],
        );
        await showFromMessage(m, silentChannel);
      } else {
        await showFromMessage(m);
      }

      handleAction(m);
    });

    // iOS: wait for APNs token
    try {
      if (Platform.isIOS) {
        //not work on simulator, use real device for testing
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          log('APNs token: $apnsToken');
          final token = await _messaging.getToken();
          log('FCM token: $token');
        } else {
          log("APNs token not ready yet.");
        }
      } else {
        final token = await FirebaseMessaging.instance.getToken();
        log('FCM token: $token');
      }
    } catch (e) {
      log('Unable to get FCM token: $e');
    }
  }

  Future<void> showFromMessage(
    RemoteMessage message, [
    AndroidNotificationChannel? userChannel,
  ]) async {
    final n = message.notification;
    if (n == null) return;


    //pick the channel on the basis of notification type
    final channel = userChannel ?? _pickChannel(message);


    //show the notification on the basis of the channel
    try {
      await localNotifications.show(
        n.hashCode,
        n.title,
        n.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            visibility: NotificationVisibility.public,
            playSound: channel.playSound,
            sound: channel.sound,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: channel.id,
            presentAlert: true,
            presentBadge: true,
            presentSound: channel.playSound,
            sound: channel.sound?.sound ?? "default",
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    } catch (e, s) {
      log('Local notification error: $e $s');
    }
  }

  void handleAction(RemoteMessage event) {
    //triggering actions on the basis of notification type
    log("event data ${event.data}");
    switch (event.data['type']) {
      case 'booking_alert_in_10':
        getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
        break;
      case 'call_rejected_after_initiation':
        //this case handles if the doctor cancel the call, and redierct to home screen
        log("reached here");
        Navigator.of(
          getIt<NavigationService>().navigatorkey.currentContext!,
        ).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 'booking_alert_on_time':
      case 'accepting_patient_request':
        getIt<HomeManager>().setAppointmentsTabTitle(null);
        getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
        break;
      case 'active_call_alert':
        bool callStatus = getIt<StateManager>().getInCallStatus();
        bool chatStatus = getIt<StateManager>().getInChatStatus();
        log("call status is $callStatus");
        if (!callStatus) {
          _showCallAlert(
            name: event.data['doctor_full_name'],
            bookId: int.tryParse(event.data['booking_id']),
            docId: int.tryParse(event.data['doctor_id']),
            appoinmId: event.data['appointment_id'],
            imag: event.data['doctor_image'],
            qualif: event.data['doctor_professional_qualification'],
            inChatStatus: chatStatus,
            tempBookingId: int.tryParse(event.data['temperory_booking_id']),
          );
        }
        break;
      case 'anatomy_image':
        _showAnatomyImage(
          bookingId: event.data['booking_id'],
          leftPoint: event.data['left_point'],
          topPoint: event.data['top_point'],
        );
        break;
      default:
        log("Unknown notification type: ${event.data['type']}");
    }
  }
}


//showing anatomy images on video call
void _showAnatomyImage({
  String? bookingId,
  String? leftPoint,
  String? topPoint,
}) {
  showDialog(
    context: getIt<NavigationService>().navigatorkey.currentContext!,
    builder: (context) => AnatomyScreen(
      bookingId: bookingId != null ? int.parse(bookingId) : 0,
      leftPoint: leftPoint != null ? double.tryParse(leftPoint) : null,
      topPoint: topPoint != null ? double.tryParse(topPoint) : null,
    ),
  );
}


//call alert shows when a doctor call the patient
void _showCallAlert({
  required String name,
  required String appoinmId,
  required String imag,
  required String qualif,
  required int? bookId,
  required int? docId,
  required bool inChatStatus,
  required int? tempBookingId,
}) {
  showDialog(
    context: getIt<NavigationService>().navigatorkey.currentContext!,
    builder: (context) => CallRequestPopup(
      name: name,
      appoinmentId: appoinmId,
      img: imag,
      qualification: qualif,
      bookingId: bookId!,
      inChatStatus: inChatStatus,
      docId: docId!,
      tempBookingId: tempBookingId!,
    ),
  );
}

AndroidNotificationChannel _pickChannel(RemoteMessage m) {
  switch (m.data['type']) {
    case 'booking_alert_in_10':
      return scheduledIn10Channel;
    case 'medicine_alert_in_ml':
      return medicineMl;
    case 'medicine_alert_in_en':
      return medicineEn;
    default:
      return defaultChannel;
  }
}
