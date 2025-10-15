import 'package:dqapp/view/screens/pro/pro_widgets/gradient_text.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../../drawer_menu_screens/notifications_screen.dart';

class ProAppBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> menuKey;
  final bool isUnread;
  const ProAppBarWidget({
    super.key,
    required this.menuKey,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          horizontalSpace(12),
          Image.asset('assets/images/dq-logo-1.5x.png', height: 36, width: 36),
          horizontalSpace(6),
          // Text(
          //   'dq pro',
          //   style: t500_18,
          // ),
          GradientText(
            text: "dq pro",
            style: t900_20,
            gradient: const LinearGradient(
              colors: [
                Colors.red,
                Colors.purple,
                // Color(0xFFE53935), // red
                // Color(0xFF8E24AA), // purple
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          const Spacer(),
          notificationIcon(context, isUnread: isUnread),
          horizontalSpace(10),
          InkWell(
            onTap: () {
              menuKey.currentState!.openEndDrawer();
            },
            child: const Icon(Icons.menu_rounded, size: 30),
          ),
        ],
      ),
    );
  }

  notificationIcon(BuildContext context, {bool isUnread = false}) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
          child: Container(
            // height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: .4, color: clrFFFFFF.withOpacity(.2)),
            ),
            child: const Icon(Icons.notifications_none_rounded),
          ),
        ),
        isUnread
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colours.toastRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
