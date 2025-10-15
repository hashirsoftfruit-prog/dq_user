// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../controller/managers/booking_manager.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../chat_screen.dart';
import '../home_screen.dart';

enum DirectionOption { oneDirection, twoDirection }

class TimerWidget extends StatefulWidget {
  final String appoinmentId;
  final int bookingId;
  final Function fn;
  const TimerWidget({
    super.key,
    required this.appoinmentId,
    required this.bookingId,
    required this.fn,
  });
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  // static const int initialTime = 600; // 5 minutes in seconds
  // int _currentTime = initialTime;
  // Timer? _timer;
  // final ScrollController _scrollController = ScrollController();

  bool timout = true;

  @override
  void initState() {
    super.initState();
    checkAnyoneAcceptedReq();
    // _startScrolling();

    // startTimer();
  }

  // void _startScrolling() {
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     _scrollController
  //         .animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(seconds: 200), // Adjust speed here
  //       curve: Curves.linear,
  //     )
  //         .then((_) {
  //       // Reset position to the start when scrolling reaches the end
  //       _scrollController.jumpTo(0);
  //       _startScrolling();
  //     });
  //   });
  // }

  @override
  void dispose() {
    // _scrollController.dispose;
    isDisposed = true; // Set to true when the widget is disposed

    super.dispose();
  }

  bool isDisposed = false; // Add this at the top of your StatefulWidget

  checkAnyoneAcceptedReq() async {
    if (isDisposed) return; // Stop execution if the screen is closed

    var result = await getIt<BookingManager>().getConnectionStatus(
      widget.bookingId,
    );
    if (isDisposed) return; // Check again after awaiting result

    if (result.status == true) {
      widget.fn;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            docId: result.userId,
            isDirectToCall: true,
            appId: widget.appoinmentId,
            isCallAvailable: true,
            bookId: widget.bookingId,
          ),
        ),
      );
      // if (isDisposed) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (result.isTimeLeft == false) {
      if (isDisposed) return;
      setState(() {
        timout = false;
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));
      checkAnyoneAcceptedReq(); // Recursive call
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeartBeatLoader(),

        verticalSpace(8),
        Text(
          timout == true
              ? AppLocalizations.of(context)!.connectingDoctor
              : AppLocalizations.of(context)!.noDoctorsAvailable,
          style: t700_20,
        ),
        // verticalSpace(8),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: timout != true
                ?
                  //     ? Text(
                  //   '${(_currentTime ~/ 60).toString().padLeft(2, '0')}:${(_currentTime % 60).toString().padLeft(2, '0')}',
                  //
                  //   style: TextStyle(fontSize: 28),
                  // )
                  //     :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //   ElevatedButton(
                      //                 onPressed: startTimer,
                      //                 child: Text('Reconnect'),
                      //               ),
                      // horizontalSpace(8),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (ff) => false,
                          );
                        },
                        child: ButtonContainer(
                          txt: AppLocalizations.of(context)!.cancelBooking,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}
// }

class ButtonContainer extends StatelessWidget {
  final String txt;
  const ButtonContainer({super.key, required this.txt});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 18,
      ), // Padding to mimic button size
      decoration: BoxDecoration(
        color: Colours.toastRed, // Background color of the container
        borderRadius: BorderRadius.circular(18), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4), // Shadow offset
            blurRadius: 6, // Shadow blur radius
          ),
        ],
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.cancelBooking,
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 16, // Text size
            fontWeight: FontWeight.w600, // Text weight
          ),
        ),
      ),
    );
  }
}

class HeartBeatLoader extends StatefulWidget {
  final Color? beatColor;
  final double? width;
  final double? height;

  const HeartBeatLoader({super.key, this.beatColor, this.width, this.height});

  @override
  State<HeartBeatLoader> createState() => _HeartBeatLoaderState();
}

class _HeartBeatLoaderState extends State<HeartBeatLoader> {
  final ScrollController _scrollController = ScrollController();
  bool isDisposed = false; // Add this at the top of your StatefulWidget

  bool timout = true;

  @override
  void initState() {
    super.initState();
    // startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  // void _startScrolling() {
  //   if (_scrollController.hasClients) {
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       if (_scrollController.position.maxScrollExtent > 0) {
  //         _scrollController
  //             .animateTo(
  //           _scrollController.position.maxScrollExtent,
  //           duration: const Duration(seconds: 200),
  //           curve: Curves.linear,
  //         )
  //             .then((_) {
  //           _scrollController.jumpTo(0);
  //           _startScrolling();
  //         });
  //       }
  //     });
  //   }
  // }

  void _startScrolling() {
    if (!mounted || !_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || !_scrollController.hasClients) return;

      final maxExtent = _scrollController.position.maxScrollExtent;
      if (maxExtent > 0) {
        _scrollController
            .animateTo(
              maxExtent,
              duration: const Duration(seconds: 200),
              curve: Curves.linear,
            )
            .then((_) {
              if (!mounted || !_scrollController.hasClients) return;

              _scrollController.jumpTo(0);
              _startScrolling(); // Recursively restart
            });
      }
    });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   isDisposed = true; // Set to true when the widget is disposed

  //   super.dispose();
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<String> _imageList = [
    "assets/images/heartbeat-loader-white.png",
    "assets/images/heartbeat-loader-white.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 100,
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            _imageList.length * 10, // Repeating images for a seamless effect
        itemBuilder: (context, index) {
          return Image.asset(
            _imageList[index % _imageList.length], // Repeat images infinitely
            width: 200, // Adjust image width
            fit: BoxFit.cover,
            color: widget.beatColor,
          );
        },
      ),
    );
  }
}
