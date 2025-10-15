import 'package:dqapp/controller/routes/routnames.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/view/screens/News%20and%20Tips/news_and_tips_list_screen.dart';
import 'package:dqapp/view/screens/News%20and%20Tips/news_and_tips_screen.dart';
import 'package:dqapp/view/screens/booking_screens/instant_booking_screen.dart';
import 'package:dqapp/view/screens/chat_screen.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/screens/starting_screens/splash_scren.dart';
import 'package:flutter/material.dart';

import '../../view/screens/drawer_menu_screens/upcoming_appoinments_screen.dart';
import '../../view/screens/search_choose_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.appoinments:
        return MaterialPageRoute(
          builder: (_) => const UpcomingAppointmentsScreen(),
        );
      case RouteNames.searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchChooseScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.chatScreen:
        final args = settings.arguments as ChatPageArguments;

        return MaterialPageRoute(
          builder: (_) => ChatPage(
            appId: args.appId,
            docId: args.docId,
            isCallAvailable: args.isCallAvailable,
            bookId: args.bookId!,
            isDirectToCall: args.isDirectToCall,
            isPipModeActive: args.isPipModeActive,
          ),
        );
      case RouteNames.bookingScreen:
        final args = settings.arguments as BookingScreenArguments;

        return MaterialPageRoute(
          builder: (_) => BookingScreen(
            itemName: args.itemName,
            subCatId: args.subCatId,
            psychologyType: args.psychologyType,
            subspecialityId: args.subspecialityId,
            specialityId: args.specialityId,
          ),
        );
      // case "Join": return MaterialPageRoute(builder: (context) => const JoinScreen());
      //  case "Intro": return MaterialPageRoute(builder: (context) => const IntroScreen());

      // case '/coursePage':
      // return MaterialPageRoute(builder: (_) => CoursePage());
      // case '/enquiryScreen':
      //   SingleCourse data = settings.arguments as SingleCourse;
      //
      //   return MaterialPageRoute(
      //       settings: settings,
      //       builder: (_) => EnquiryScreen(data));

      case RouteNames.newsAndTips:
        final args = settings.arguments as NewsAndTipsScreenArguments;

        // Notice: no branching here, we let the factory handle it
        if (args.tip != null) {
          return MaterialPageRoute(
            builder: (_) => NewsAndTipsScreen.tip(args.tip!),
          );
        } else if (args.news != null) {
          return MaterialPageRoute(
            builder: (_) => NewsAndTipsScreen.news(args.news!),
          );
        } else {
          throw Exception("Invalid arguments for NewsAndTipsScreen");
        }

      case RouteNames.newsAndTipsList:
        final args = settings.arguments as NewsAndTipsListScreenArguments;

        return MaterialPageRoute(
          builder: (_) => NewsAndTipsListScreen(
            type: args.type!,
            tips: args.tips,
            news: args.news,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

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

class BookingScreenArguments {
  int specialityId;
  int? subCatId;
  int? subspecialityId;
  int? psychologyType;
  String itemName;
  // bool? pkgAvailability;

  BookingScreenArguments({
    required this.specialityId,
    required this.itemName,
    required this.subCatId,
    this.subspecialityId,
    this.psychologyType,
  });
}
