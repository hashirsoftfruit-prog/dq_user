// import 'dart:convert';
// import 'dart:developer';

// import 'package:dqapp/model/helper/text_to_speech.dart';
// import 'package:dqapp/view/screens/anatomy_screen.dart';
// import 'package:dqapp/view/screens/booking_screens/booking_screen_widgets.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'controller/managers/home_manager.dart';
// import 'controller/managers/state_manager.dart';
// import 'model/helper/service_locator.dart';

// /// Single, global plugin
// final FlutterLocalNotificationsPlugin _localNotifications =
//     FlutterLocalNotificationsPlugin();

// /// ANDROID CHANNELS (top-level; immutable once created)
// const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'General notifications',
//   importance: Importance.high,
// );

// const AndroidNotificationChannel medicineEn = AndroidNotificationChannel(
//   'medicine_alert_in_en',
//   'Medicine Alert in EN',
//   description: 'Medicine Alert in EN',
//   importance: Importance.high,
//   sound: RawResourceAndroidNotificationSound(
//       'medicine_en'), // today.wav/ogg in res/raw
// );

// const AndroidNotificationChannel medicineMl = AndroidNotificationChannel(
//   'medicine_alert_in_ml',
//   'Medicine Alert in EN',
//   description: 'Medicine Alert in ML',
//   importance: Importance.high,
//   sound: RawResourceAndroidNotificationSound(
//       'medicine_ml'), // today.wav/ogg in res/raw
// );

// const silentChannel = AndroidNotificationChannel(
//   'silent_channel', // id
//   'Silent Notifications', // name
//   description: 'This channel is used for notifications without sound.',
//   importance: Importance.high, // no heads-up, no sound
//   playSound: false, // disable sound
//   enableVibration: true, // disable vibration
// );

// const AndroidNotificationChannel scheduledIn10Channel =
//     AndroidNotificationChannel(
//   'booking_alert_in_10',
//   'Booking in 10 Notifications',
//   description: 'Reminders with custom sound',
//   importance: Importance.high,
//   sound:
//       RawResourceAndroidNotificationSound('today'), // today.wav/ogg in res/raw
// );

// Future<void> handleBackgroundMessaging(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // await NotificationServiceAndroid.instance.showFromMessage(message);
//   // NotificationServiceAndroid.instance.handleAction(message);
//   if (message.notification == null) {
//     await NotificationServiceAndroid.instance.showFromMessage(message);
//   }
//   NotificationServiceAndroid.instance.handleAction(message);
// }

// class NotificationServiceAndroid {
//   NotificationServiceAndroid._();
//   static final NotificationServiceAndroid instance =
//       NotificationServiceAndroid._();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   // void handleMessage(RemoteMessage? message) {
//   //   if (message == null) {
//   //     // print("playLoad :");
//   //   } else {
//   //     // print("playLoad:$message");
//   //   }
//   // }

//   Future initLocalNotification() async {
//     const iOS = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: iOS);

//     await _localNotifications.initialize(settings,
//         onDidReceiveNotificationResponse: (payload) {
//       final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
//       handleAction(message);
//     });

//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     await platform?.createNotificationChannel(defaultChannel);
//     await platform?.createNotificationChannel(medicineEn);
//     await platform?.createNotificationChannel(medicineMl);
//     await platform?.createNotificationChannel(silentChannel);
//     await platform?.createNotificationChannel(scheduledIn10Channel);
//   }

//   Future initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.instance.getInitialMessage().then((m) {
//       if (m != null) handleAction(m);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen(handleAction);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
//     FirebaseMessaging.onMessage.listen((event) async {
//       final notification = event.notification;
//       log("notification message ${event.data}");

//       if (notification == null) {
//         return;
//       } else {
//         //show normal notificaiton and play the script accordingly

//         if (event.data['type'] == "medicine_alert_in_en" ||
//             event.data['type'] == "medicine_alert_in_ml") {
//           TextToSpeech.instance
//               .playSound(event.data["medicines"], event.data["language"]);
//           showFromMessage(event, silentChannel);
//           //read message
//         } else {
//           showFromMessage(event);
//         }

//         // final MyRouteObserver myRouteObserver = MyRouteObserver();

//         // String? currentRoute = myRouteObserver.currentRoute;
// // print("currentRoute");
// // print(currentRoute);
// //         if (currentRoute != '/targetScreen') {
// //           navigatorKey.currentState?.pushNamed('/targetScreen');
// //         }

//         handleAction(event);
//       }
//     });
//   }

//   Future<void> initNotification() async {
//     await _messaging.requestPermission();
//     // final _fcmToken = await _firebaseMessaging.getToken();
//     // print("FCM TOKEN$_fcmToken");
//     // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
//     initPushNotification();
//     initLocalNotification();
//   }

//   Future<void> showFromMessage(RemoteMessage message,
//       [AndroidNotificationChannel? userChannel]) async {
//     final n = message.notification;
//     if (n == null) return;

//     log(message.notification!.android!.channelId.toString());

//     final channel = userChannel ?? _pickChannel(message);
//     try {
//       await _localNotifications.show(
//         n.hashCode,
//         n.title,
//         n.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             importance: Importance.high,
//             priority: Priority.high,
//             visibility: NotificationVisibility.public,
//             playSound: channel.playSound,
//             sound: channel.sound,
//             icon: '@mipmap/ic_launcher',
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     } catch (e) {
//       if (kDebugMode) log('Local notification error: $e');
//     }
//   }

//   void handleAction(RemoteMessage event) {
//     if (event.data['type'] == 'booking_alert_in_10') {
//       // getIt<NavigationService>().pushTo(RouteNames.appoinments);
//       getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
//     } else if (event.data['type'] == 'booking_alert_on_time' ||
//         event.data['type'] == "accepting_patient_request") {
//       // getIt<NavigationService>().pushTo(RouteNames.appoinments);
//       getIt<HomeManager>().setAppointmentsTabTitle(null);

//       getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
//       // _showBottomSheetOnNotification();
//     } else if (event.data['type'] == 'active_call_alert') {
//       // getIt<NavigationService>().pushTo(RouteNames.appoinments);
//       // getIt<HomeManager>().getUpcomingAppointments(index:1);
//       bool callStatus = getIt<StateManager>().getInCallStatus();
//       bool chatStatus = getIt<StateManager>().getInChatStatus();

//       if (callStatus == false) {
//         _showcallAlert(
//             name: event.data['doctor_full_name'],
//             bookId: int.tryParse(event.data['booking_id']),
//             docId: int.tryParse(event.data['doctor_id']),
//             appoinmId: event.data['appointment_id'],
//             imag: event.data['doctor_image'],
//             qualif: event.data['doctor_professional_qualification'],
//             inChatStatus: chatStatus);
//       }
//     } else if (event.data['type'] == 'anatomy_image') {
//       _showAnatomyImage(bookingId: event.data['booking_id']);
//     }
//   }
// }

// void _showAnatomyImage(
//     {String? bookingId, String? leftPoint, String? topPoint}) {
//   // getIt<NavigationService>().navigatorkey.currentState?.push(
//   showDialog(
//     context: getIt<NavigationService>().navigatorkey.currentContext!,
//     builder: (context) => AnatomyScreen(
//         bookingId: bookingId != null ? int.parse(bookingId) : 0,
//         leftPoint: leftPoint != null ? double.tryParse(leftPoint) : null,
//         topPoint: topPoint != null ? double.tryParse(topPoint) : null),
//   );
//   // );
// }

// void _showcallAlert({
//   required String name,
//   required String appoinmId,
//   required String imag,
//   required String qualif,
//   required int? bookId,
//   required int? docId,
//   required bool inChatStatus,
// }) {
//   // getIt<NavigationService>().navigatorkey.currentState?.push(

//   showDialog(
//     context: getIt<NavigationService>().navigatorkey.currentContext!,
//     builder: (context) => CallRequestPopup(
//         name: name,
//         appoinmentId: appoinmId,
//         img: imag,
//         qualification: qualif,
//         bookingId: bookId!,
//         inChatStatus: inChatStatus,
//         docId: docId!),
//     // isDismissible: true,
//     // enableDrag: true,
//   );
//   // );
// }

// AndroidNotificationChannel _pickChannel(RemoteMessage m) {
//   if (m.data['type'] == 'booking_alert_in_10') {
//     return scheduledIn10Channel;
//   } else if (m.data['type'] == 'medicine_alert_in_ml') {
//     return medicineMl;
//   } else if (m.data['type'] == 'medicine_alert_in_en') {
//     return medicineEn;
//   }

//   return defaultChannel;
// }
