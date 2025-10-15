import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/model/core/meditation_videos_list_model.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/psychology_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

import '../../theme/text_styles.dart';
import '../booking_screens/redacted_loaders.dart';
import 'audio_player_screen.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  State<MusicListScreen> createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  ScrollController scCntrol = ScrollController();

  // int hhht = 4;
  // late double ht;
  //   void _scrollListener()async {
  //
  //     if (
  //     // scCntrol.position.userScrollDirection==ScrollDirection.forward&&
  //         scCntrol.position.pixels>100
  //     ) {
  //       // print();
  //       getIt<StateManager>().changeHeight(1.8);
  //
  //     }else if(scCntrol.position.pixels<100){
  //       getIt<StateManager>().changeHeight(4);
  //
  //     }
  //   }

  @override
  void initState() {
    getIt<PsychologyManager>().getMeditationAudioFiles();

    // scCntrol.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fn({
    //   required int specialityId,
    //   int? subCatList,
    //   required String specialityTitle,
    // }) async {}
    // var get = getIt<SmallWidgets>();
    bool availableDocsLoader = Provider.of<BookingManager>(
      context,
    ).bookingScreenLoader;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<PsychologyManager>(
          builder: (context, mgr, child) {
            List<AudioFile> musicsList =
                mgr.meditationAudiosModel?.audioFiles ?? [];

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              extendBody: true,
              body: Stack(
                children: [
                  Entry(
                    xOffset: 1000,
                    // scale: 20,
                    delay: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.ease,
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          foregroundColor: Colors.white,
                          // backgroundColor:clrFFEDEE,
                          floating: true,
                          pinned: false,
                          // toolbarHeight: 136,
                          collapsedHeight: 112,
                          expandedHeight: 301,

                          flexibleSpace: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/images/meditation-video-main-image-2.png",
                                    ),
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: SafeArea(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 4,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: SizedBox(
                                                height: 40,
                                                child: SvgPicture.asset(
                                                  "assets/images/back-arrow.svg",
                                                  colorFilter: ColorFilter.mode(
                                                    clrFFFFFF,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const Spacer(),
                                            // SizedBox(
                                            //     height: 25,
                                            //     child: Image.asset("assets/images/location-icon.png")),
                                            // horizontalSpace(2),
                                            // Text("Kozhikode",style: t700_14.copyWith(color: clr2D2D2D),)
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: maxWidth * 0.7,
                                              child: Text(
                                                "Listen, relax, and unwind.",
                                                style: t700_24.copyWith(
                                                  height: 1,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        verticalSpace(8),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        mgr.listLoader
                            ? SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    const AudiosListLoader(),
                                  ]),
                                ),
                              )
                            : SliverPadding(
                                padding: EdgeInsets.zero,
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    const SizedBox(),
                                  ]),
                                ),
                              ),
                        if (musicsList.isNotEmpty) ...[
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w1p * 4,
                            ), // Optional spacing
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                String? title = musicsList[index].title;
                                String? artist = musicsList[index].artist;
                                String? thumbnail =
                                    musicsList[index].thumbnailImage;
                                int? mediaSource =
                                    musicsList[index].mediaSource;
                                String? file = musicsList[index].file;
                                String? duration =
                                    musicsList[index].mediaDuration;

                                return MusicItem(
                                  artist: artist,
                                  duration: duration,
                                  w1p: w1p,
                                  h1p: h1p,
                                  title: title ?? "",
                                  img: thumbnail ?? "",
                                  onClick: () async {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AudioPlayerScreen(
                                          fileUrl: file!,
                                          thumbnail: thumbnail,
                                          artist: artist,
                                          title: title,
                                          isExternalUrl: mediaSource == 2,
                                        );
                                      },
                                    );

                                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>));
                                  },
                                );
                              }, childCount: musicsList.length),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  myLoader(
                    width: maxWidth,
                    height: maxHeight,
                    visibility: availableDocsLoader,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
