import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/appoinment_detail_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/packages_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/reminder_screen.dart';
import 'package:dqapp/view/screens/forum_screens/forum_details_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/home_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/notification_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // DateTime _selectedDate = DateTime.now();
  int index = 1;

  @override
  void initState() {
    getIt<HomeManager>().getNotifications(isRefresh: true);
    getIt<HomeManager>().notificationStatusChange();

    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      index++;
      getIt<HomeManager>().getNotifications();
    }
  }

  navigateNotification(Notifications notif) {
    if (notif.moduleId != null && notif.moduleId != 0) {
      switch (notif.module) {
        case 'Booking':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookingDetailsScreen(bookingId: notif.moduleId),
            ),
          );
          break;
        case 'Public forum':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ForumDetailsScreen(forumId: notif.moduleId!),
            ),
          );
          break;
        case 'Package':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PackagesScreen()),
          );
        case 'Reminder':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReminderScreen()),
          );
          break;
        // case 'dashboard':
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => DashboardScreen()),
        //   );
        //   break;
        default:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          return Consumer<HomeManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: "Notifications",
                  height: h10p * 0.9,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    index = 1;
                    getIt<HomeManager>().getNotifications(isRefresh: true);
                  },
                  child: Entry(
                    yOffset: -100,
                    // opacity: .5,
                    // angle: 3.1415,
                    delay: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                    child: ListView(
                      controller: _controller,
                      children: [
                        // mgr.consultations!=null && mgr.consultations!.isNotEmpty?
                        // pad(horizontal: w1p*4,vertical: h1p,
                        //     child: Text("Recent patients",style: TextStyles.textStyle6,)):SizedBox(),
                        verticalSpace(h1p),
                        mgr.notificationLoader == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: h10p),
                                child: const Center(child: LogoLoader()),
                              )
                            : mgr.notificationsModel?.notifications != null &&
                                  mgr.notificationsModel!.notifications!.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: h10p),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noNotifications,
                                    style: TextStyles.notAvailableTxtStyle,
                                  ),
                                ),
                              )
                            : mgr.notificationsModel?.notifications != null &&
                                  mgr
                                      .notificationsModel!
                                      .notifications!
                                      .isNotEmpty
                            ? pad(
                                horizontal: w1p * 4,
                                child: Column(
                                  children: mgr.notificationsModel!.notifications!.map((
                                    e,
                                  ) {
                                    String time = getIt<StateManager>()
                                        .getTimeFromDTime(
                                          DateTime.parse(e.dateTime!),
                                        );
                                    String date = getIt<StateManager>()
                                        .getMonthDay(
                                          DateTime.parse(e.dateTime!),
                                        );

                                    var indx = mgr
                                        .notificationsModel!
                                        .notifications!
                                        .indexOf(e);

                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            navigateNotification(e);
                                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: 'temporary',bookingId: 0000,isCallAvailable: false,)));
                                          },
                                          child: NotificationItem(
                                            h1p: h1p,
                                            title: e.title ?? "",
                                            subtitle: e.body ?? "",
                                            w1p: w1p,
                                            img: e.image ?? "",
                                            date: date,
                                            sheduledTime: time,
                                          ),
                                        ),
                                        mgr
                                                            .notificationsModel!
                                                            .notifications!
                                                            .length -
                                                        1 ==
                                                    indx &&
                                                mgr
                                                        .notificationsModel!
                                                        .notifications !=
                                                    null &&
                                                mgr.notificationsModel!.next !=
                                                    null
                                            ? const Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colours.boxblue,
                                                      ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String date;
  // int? bookingID;
  final String title;
  final String subtitle;
  // String appoinmentId;
  final String img;
  // bool isOnline;
  // String gender;
  // String age;
  final String sheduledTime;
  // String patienttitle;
  // DateTime? startTime;
  // DateTime? endTime;
  const NotificationItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.sheduledTime,
    // required this.bookingID,
    // required this.appoinmentId,
    required this.date,
    // required this.gender,
    // required this.age,
    // required this.isOnline,
    // required this.patienttitle,
    // required this.isApplicable,
    required this.title,
    required this.subtitle,
    // required this.startTime,
    // required this.endTime,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffFfFfFf),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 3),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colours.primaryblue.withOpacity(0.1),
                            // gradient: linearGrad3,

                            //   boxShadow: [
                            //   BoxShadow(spreadRadius: 5, blurRadius: 11,color: Colors.grey.withOpacity(0.2),
                            //   offset: Offset(-2,2)
                            //   )
                            //
                            // ],
                            //     borderRadius: BorderRadius.circular(20),
                            // shape: BoxShape.circle
                          ),

                          // child: Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(12.0),
                          //     child: SvgPicture.asset("assets/images/appicon.svg"),
                          //   ),
                          // ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            // fit: widget.fit,
                            imageUrl: StringConstants.baseUrl + img,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/notification-image.png",
                              ),
                            ),
                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/notification-image.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                      horizontalSpace(w1p * 2),
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(title, style: TextStyles.notif1),
                              // Text(subtitle??"",style: TextStyles.notif2,maxLines: 2,overflow:TextOverflow.ellipsis ,),
                              GenericExpandableText(
                                textAlign: TextAlign.start,
                                subtitle,
                                style: t400_12.copyWith(color: clr2D2D2D),
                                readlessColor: Colours.primaryblue,
                                readmoreColor: Colours.primaryblue,
                                hasReadMore: true,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(date, style: t400_10.copyWith(color: clr757575)),
                        horizontalSpace(w1p),
                        Text(
                          sheduledTime,
                          style: t400_10.copyWith(color: clr757575),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0.5, color: Colours.lightBlu),
        ],
      ),
    );
  }
}
