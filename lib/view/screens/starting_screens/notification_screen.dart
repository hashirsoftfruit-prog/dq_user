//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../model/helper/service_locator.dart';
// import '../../theme/constants.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // List<NotificationList> notificationList = Provider.of<UserManager>(context).notificationList;
//     return LayoutBuilder(builder: (context, constraints) {
//       double maxHeight = constraints.maxHeight;
//       double maxWidth = constraints.maxWidth;
//       double h1p = maxHeight * 0.01;
//       double h10p = maxHeight * 0.1;
//       double w10p = maxWidth * 0.1;
//
//
//       return ProgressHUD(
//         child: Builder(
//           builder: (context) {
//             final progress = ProgressHUD.of(context);
//
//             return SafeArea(
//               child: Scaffold(
//                   body: Container(child: Text("dfkdjfjjfjdkjfkdjkfjkd"),)),
//             );
//           }
//         ),
//       );
//     });
//   }
// }
