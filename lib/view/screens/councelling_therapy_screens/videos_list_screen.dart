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
import 'councelling_videos_screen.dart';

class VideosListScreen extends StatefulWidget {
  const VideosListScreen({super.key});

  @override
  State<VideosListScreen> createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  ScrollController scCntrol = ScrollController();

  @override
  void initState() {
    getIt<PsychologyManager>().getMeditationVideoFiles();

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
    // bool availableDocsLoader = Provider.of<BookingManager>(context).bookingScreenLoader;

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
            List<VideoFiles> videos =
                mgr.meditationVideosModel?.videoFiles ?? [];

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              extendBody: true,

              // appBar: get.appBarWidget(
              //     title: widget.forScheduledBooking == true
              //         ? AppLocalizations.of(context)!.findDoctorsClinic
              //         :AppLocalizations.of(context)!.liveVideoConsult2,
              //     height: h10p,
              //     width: w10p,
              //     fn: () {
              //       Navigator.pop(context);
              //     })
              // ,
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
                          floating: true,
                          pinned: false,
                          collapsedHeight: 112,
                          expandedHeight: 301,
                          flexibleSpace: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/images/meditation-video-main-image.png",
                                    ),
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                  // gradient:LinearGradient(
                                  // begin: Alignment.topLeft,end: Alignment.bottomRight,
                                  // colors:
                                  //
                                  // [Color(0xff8467A6),
                                  //     Color(0xff8467A6),
                                  //     Color(0xff5D5AAB),
                                  //     ])
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                  // color: Color(0xff2E3192).withOpacity(0.15),
                                  // gradient:LinearGradient(
                                  // begin: Alignment.topCenter,end: Alignment.bottomCenter,
                                  //
                                  // colors:
                                  //
                                  // [
                                  //   Colors.transparent,
                                  //     // Color(0xff8467A6),
                                  //     Color(0xff3176AD),
                                  //     ])
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
                                                "Relax, breathe, and find your peace.",
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
                                    const VideosListLoader(),
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
                        if (videos.isNotEmpty) ...[
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w1p * 4,
                            ), // Optional spacing
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                String? title = videos[index].title;
                                // String? subTitle = videos[index].subTitle ?? videos[index].title;
                                String? thumbnail =
                                    videos[index].thumbnailImage ?? "";
                                String? duration = videos[index].mediaDuration;
                                bool? isYoutubeUrl =
                                    videos[index].mediaSource == 2;
                                String fileUrl = videos[index].file ?? "";

                                return VideoItem(
                                  w1p: w1p,
                                  h1p: h1p,
                                  title: title ?? "",
                                  duration: duration,
                                  img: thumbnail,
                                  onClick: () async {
                                    if (isYoutubeUrl) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => YoutubePlayerScreen(
                                            videoUrl: fileUrl,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VideoPlayerScreen(
                                            videoUrl: fileUrl,
                                            title: title ?? "",
                                          ),
                                        ),
                                      );
                                    }
                                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoPlayingScreen(
                                    //   isYoutubeUrl: isYoutubeUrl,thumbUrl: thumbnail,videoUrl: fileUrl,data: Data(title: title,
                                    // duration:duration ,description: subTitle,thumbnailImage: thumbnail,),
                                    //
                                    // )));
                                  },
                                );
                              }, childCount: videos.length),
                            ),
                          ),
                        ],
                      ],
                    ),
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
