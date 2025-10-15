// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/model/helper/service_locator.dart';
import 'package:dqapp/view/screens/pro/pro_home_vm.dart';
import 'package:dqapp/view/screens/pro/pro_widgets/app_bar_widget.dart';
import 'package:dqapp/view/screens/pro/pro_widgets/search_bar_widget.dart';
import 'package:dqapp/view/screens/pro/pro_tabs/consultation_tab/consultation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../theme/constants.dart';
import '../../theme/text_styles.dart';
import '../drawer_menu_screens/menu_drawer_screen.dart';
import 'pro_tabs/ayur_homeo_tab/ayur_homeo_tab.dart';
import 'pro_tabs/counselling_tab/counselling_tab.dart';
import 'pro_tabs/dq_future_tab/dq_future_tab.dart';
import 'pro_tabs/pet_tab/pet_tab.dart';
import 'pro_widgets/chat_bot.dart';

class ProHomeTab extends StatefulWidget {
  final int indexFromHome;

  const ProHomeTab({super.key, required this.indexFromHome});

  @override
  State<ProHomeTab> createState() => _ProHomeTabState();
}

class _ProHomeTabState extends State<ProHomeTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int tabIndex = 0;
  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    tabController.addListener(tabListener);
    tabIndex = widget.indexFromHome;
    getIt<ProHomeVm>().proBeginFns();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  tabListener() {
    tabIndex = tabController.index;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    showChatBot() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return const ChatBot();
        },
      );
    }

    var chatBotIcon = GestureDetector(
      onTap: () {
        showChatBot();
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatBot()));
        // var res = await showModalBottomSheet(
        //     elevation: 0,
        //     isDismissible: true,
        //     backgroundColor: Colors.transparent,
        //     context: context,
        //     builder: (context) {
        //       return const SpeechToTextWidget();
        //     });
        // if (res != null) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => SearchResultScreen(
        //                 title: AppLocalizations.of(context)!.onlineConsultations,
        //                 type: 2,
        //                 searchquery: res,
        //               )));
        // }
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: clrFFFFFF,
          image: const DecorationImage(
            image: AssetImage('assets/images/chatbot_icon.gif'),
            fit: BoxFit.cover,
          ),
        ),
        // radius: 25,
        // foregroundImage: const AssetImage('assets/images/chatbot_icon.gif'),
        // child: SizedBox(
        //   width: 50,
        //   height: 50,
        // child: Image.asset('assets/images/chatbot_icon.gif'),
        // ),
      ),
    );
    return DefaultTabController(
      length: 6,
      // controller: tabController,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          //   double h10p = maxHeight * 0.1;
          //   double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;
          return Consumer<ProHomeVm>(
            builder: (context, vm, _) {
              return Scaffold(
                key: key,
                endDrawer: MenuDrawerScreen(w1p: w1p, h1p: h1p),
                endDrawerEnableOpenDragGesture: false,
                floatingActionButton: chatBotIcon,
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 42, bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: appBarGradient(tabIndex),
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        //   borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ProAppBarWidget(
                            menuKey: key,
                            isUnread:
                                (vm.specialities?.unreadNotificationCount ??
                                    0) >
                                0,
                          ),
                          verticalSpace(8),
                          ProSearchBar(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                          ),
                          verticalSpace(6),
                          TabBar(
                            controller: tabController,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            indicatorColor: Colors.transparent,
                            indicatorPadding: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            physics: const ClampingScrollPhysics(),
                            tabAlignment: TabAlignment.start,

                            // indicator: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                            // labelColor: Colors.black,
                            // unselectedLabelColor: Colors.white,
                            tabs: [
                              // tabContainer(title: 'All', icon: Icons.home_filled, index: 0),
                              tabContainer(
                                title: 'Consultation',
                                image: 'assets/images/tab_consult_img.png',
                                index: 0,
                              ),
                              tabContainer(
                                title: 'Counselling',
                                image: 'assets/images/tab_counselling_img.png',
                                index: 1,
                              ),
                              // tabContainer(title: 'Pet Care', icon: Icons.pets_rounded, index: 4),
                              tabContainer(
                                title: 'Ayurvedic',
                                image: 'assets/images/tab_ayurvedic_img.png',
                                index: 2,
                              ),
                              tabContainer(
                                title: 'Homeopathic',
                                image: 'assets/images/tab_homeo_img.png',
                                index: 3,
                              ),
                              tabContainer(
                                title: 'DQ Future',
                                image: 'assets/images/tab_dqfuture_img.png',
                                index: 4,
                              ),
                              tabContainer(
                                title: 'Pet care',
                                image: 'assets/images/tab_pet_img.png',
                                index: 5,
                              ),
                              // Tab(text: 'Consultation'),
                              // Tab(text: 'Pet care'),
                              // Tab(text: 'Counselling'),
                              // Tab(text: 'Ayurvedic'),
                              // Tab(text: 'Homeopathic'),
                              // Tab(text: 'DQ Future'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          ProConsultationTab(),
                          ProCounsellingScreen(),
                          ProAyurHomeoTab(isAyurvedic: true),
                          ProAyurHomeoTab(isAyurvedic: false),
                          ProDQFutureTab(),
                          ProPetScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Color> appBarGradient(tabIndex) {
    switch (tabIndex) {
      case 0:
        return [const Color(0xff3b82f6), const Color(0xffF0F5FF), clrFFFFFF];
      case 1:
        return [const Color(0xffFFCB9F), clrFFFFFF];
      case 2:
        return [const Color(0xff02B05C), const Color(0xffF0F5FF), clrFFFFFF];
      case 3:
        return [const Color(0xffFFE995), const Color(0xffF0F5FF), clrFFFFFF];
      case 4:
        return [const Color(0xff0F83B8), const Color(0xffF0F5FF), clrFFFFFF];
      case 5:
        return [const Color(0xffFFAA49), const Color(0xffF0F5FF), clrFFFFFF];
      default:
        return [clr7361A8, clrFFFFFF];
    }
  }

  Color tabColor(tabIndex) {
    switch (tabIndex) {
      case 0:
        return const Color(0xff66A0FF);
      case 1:
        return const Color(0xffFFA358).withAlpha(150);
      case 2:
        return const Color(0xff02B05C).withAlpha(120);
      case 3:
        return const Color(0xffEEC221).withAlpha(120);
      case 4:
        return const Color(0xff0E5299).withAlpha(100);
      case 5:
        return const Color(0xffFFAA49).withAlpha(120);
      default:
        return clrFFFFFF;
    }
  }

  Color tabBorderColor(tabIndex) {
    switch (tabIndex) {
      case 0:
        return clrFFFFFF;
      case 1:
        return clr4138B8;
      case 2:
        return clrFF4444;
      case 3:
        return clrFF6623;
      case 4:
        return clr202020;
      case 5:
        return clr127700;
      case 6:
        return clrFF6623;
      default:
        return clrFFFFFF;
    }
  }

  Widget tabContainer({
    required String title,
    required String image,
    required int index,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 60,
              width: 70,
              // margin: const EdgeInsets.all(8),
              // key: _tabKeys[index],
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              // decoration: BoxDecoration(color: clrFFFFFF.withOpacity(.38), borderRadius: BorderRadius.circular(20)),
              decoration: BoxDecoration(
                color: index != tabIndex ? clrFFFFFF : tabColor(index),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: index != tabIndex
                    ? Border.all(color: clr868686, width: 1)
                    : null,
                // image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain),
                // gradient: LinearGradient(colors: tabColor(tabIndex), end: Alignment.centerLeft, begin: Alignment.centerRight),
              ),
              // child: Image.asset(image)
            ),
            Positioned(
              bottom: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: SizedBox(
                  width: 70,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(image),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          title,
          style: index == tabIndex
              ? t600_14.copyWith(color: tabColor(index))
              : t400_12.copyWith(color: clr202020),
          maxLines: 1,
        ),
      ],
    );
  }
}
