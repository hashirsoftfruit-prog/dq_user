import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/forum_screens/forum_search_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../controller/managers/home_manager.dart';
import '../../../../controller/managers/state_manager.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../model/core/forum_list_model.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/constants.dart';
import '../home_screen.dart';
import 'forum_details_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({super.key});

  // int forumId;
  // ForumListScreen(this.forumId);
  @override
  State<ForumListScreen> createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  // AvailableDocsModel docsData;
  int index = 1;

  //
  // @override
  // void initState() {

  //
  // }
  @override
  void initState() {
    getIt<HomeManager>().getForumList();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // index++;
      getIt<HomeManager>().getForumList();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var responseConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return SafeArea(
              child: Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.forum,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                  trailWidget: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForumSearchScreen(2),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.search,
                      style: t400_14.copyWith(color: clr2D2D2D),
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    getIt<HomeManager>().getForumList(isRefresh: true);
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      verticalSpace(h1p),

                      // Padding(
                      //   padding:  EdgeInsets.symmetric(horizontal: w1p*5,vertical:h1p*2 ),
                      //   child: Text("Answer the patients questions to show your expertise.",style: TextStyles.medicalRecTxt1,),
                      // ),
                      mgr.forumLoader == true
                          ? const Entry(
                              yOffset: -100,
                              // scale: 20,
                              delay: Duration(milliseconds: 0),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                              child: Padding(
                                padding: EdgeInsets.all(28.0),
                                child: LogoLoader(),
                              ),
                            )
                          : Entry(
                              xOffset: -1000,
                              // scale: 20,
                              delay: const Duration(milliseconds: 0),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease,
                              child: Entry(
                                opacity: .5,
                                // angle: 3.1415,
                                delay: const Duration(milliseconds: 0),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.decelerate,
                                child:
                                    mgr.publicForumListModel?.publicForums !=
                                            null &&
                                        mgr
                                            .publicForumListModel!
                                            .publicForums!
                                            .isNotEmpty
                                    ? Column(
                                        children: mgr.publicForumListModel!.publicForums!.map((
                                          e,
                                        ) {
                                          var i = mgr
                                              .publicForumListModel!
                                              .publicForums!
                                              .indexOf(e);

                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ForumDetailsScreen(
                                                            forumId: e.id!,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: ForumListItem2(
                                                  isVetinary: false,
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  pf: e,
                                                ),
                                              ),
                                              i ==
                                                          mgr
                                                                  .publicForumListModel!
                                                                  .publicForums!
                                                                  .length -
                                                              1 &&
                                                      mgr
                                                              .publicForumListModel!
                                                              .next !=
                                                          null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 5,
                                                              color: Colours
                                                                  .primaryblue
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
                                                            ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          );
                                        }).toList(),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: Center(
                                          child: Text(
                                            "Forums not available",
                                            style:
                                                TextStyles.notAvailableTxtStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VetinaryForumListScreen extends StatefulWidget {
  const VetinaryForumListScreen({super.key});

  // int forumId;
  // VetinaryForumListScreen(this.forumId);
  @override
  State<VetinaryForumListScreen> createState() =>
      _VetinaryForumListScreenState();
}

class _VetinaryForumListScreenState extends State<VetinaryForumListScreen> {
  // AvailableDocsModel docsData;

  //
  // @override
  // void initState() {

  //
  // }
  @override
  void initState() {
    getIt<HomeManager>().getVetinaryForumList();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      getIt<HomeManager>().getVetinaryForumList();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var responseConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            List<PublicForums>? forumLists =
                mgr.publicForumVeterinaryListModel?.publicForums;

            return SafeArea(
              child: Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.forum,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                  trailWidget: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForumSearchScreen(1),
                        ),
                      );
                    },
                    child: const Text("Search"),
                  ),
                ),

                body: RefreshIndicator(
                  onRefresh: () async {
                    getIt<HomeManager>().getVetinaryForumList(isRefresh: true);
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      verticalSpace(h1p),

                      // Padding(
                      //   padding:  EdgeInsets.symmetric(horizontal: w1p*5,vertical:h1p*2 ),
                      //   child: Text("Answer the patients questions to show your expertise.",style: TextStyles.medicalRecTxt1,),
                      // ),
                      mgr.forumLoader == true
                          ? const Entry(
                              yOffset: -100,
                              // scale: 20,
                              delay: Duration(milliseconds: 0),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                              child: Padding(
                                padding: EdgeInsets.all(28.0),
                                child: LogoLoader(),
                              ),
                            )
                          : Entry(
                              xOffset: -1000,
                              // scale: 20,
                              delay: const Duration(milliseconds: 0),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease,
                              child: Entry(
                                opacity: .5,
                                // angle: 3.1415,
                                delay: const Duration(milliseconds: 0),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.decelerate,
                                child:
                                    forumLists != null && forumLists.isNotEmpty
                                    ? Column(
                                        children: [
                                          ...forumLists.map((e) {
                                            var i = forumLists.indexOf(e);

                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ForumDetailsScreen(
                                                              forumId: e.id!,
                                                              isVetinary: true,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: ForumListItem2(
                                                    isVetinary: false,
                                                    h1p: h1p,
                                                    w1p: w1p,
                                                    pf: e,
                                                  ),
                                                ),
                                                i == forumLists.length - 1 &&
                                                        mgr
                                                                .publicForumVeterinaryListModel!
                                                                .next !=
                                                            null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 5,
                                                                color: Colours
                                                                    .primaryblue
                                                                    .withOpacity(
                                                                      0.8,
                                                                    ),
                                                              ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            );
                                          }).toList(),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: Center(
                                          child: Text(
                                            "Forums not available",
                                            style:
                                                TextStyles.notAvailableTxtStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ForumListItem2 extends StatelessWidget {
  final double w1p;
  final double h1p;
  final bool isVetinary;
  final PublicForums pf;
  const ForumListItem2({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.isVetinary,
    required this.pf,
  });

  @override
  Widget build(BuildContext context) {
    String name = '${pf.fullName}';
    name = name.length > 20
        ? "${name.substring(0, 14)}...${name.substring(name.length - 5, name.length)}"
        : name;

    // String age = 'pf.';
    // String place = 'pf.';
    String date = pf.forumCreatedDate != null
        ? getIt<StateManager>().convertStringDateToyMMMMd(pf.forumCreatedDate!)
        : "";
    String title = pf.title ?? "";
    String image = pf.userImage ?? "";
    String subtitle = pf.description ?? "";
    int count = pf.responsesCount ?? 0;

    return Container(
      margin: EdgeInsets.only(
        top: h1p,
        bottom: h1p,
        right: w1p * 5,
        left: w1p * 5,
      ),
      decoration: BoxDecoration(
        boxShadow: isVetinary ? null : [boxShadow8],
        borderRadius: BorderRadius.circular(8),
        color: isVetinary ? const Color(0x1a000000) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // fit: widget.fit,
                      imageUrl: '${StringConstants.baseUrl}$image',
                      placeholder: (context, url) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                    ),
                  ),
                ),

                horizontalSpace(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getIt<StateManager>().capitalizeFirstLetter(name),
                      style: isVetinary
                          ? TextStyles.textStyle77e
                          : TextStyles.textStyle77,
                    ),
                    Text(
                      date,
                      style: isVetinary
                          ? TextStyles.textStyle78c
                          : TextStyles.textStyle78b,
                    ),

                    // Text("$age, $place",style: TextStyles.textStyle78,),
                  ],
                ),
                // Spacer(),
                // Text(date,style: TextStyles.textStyle78b,)
              ],
            ),
          ),
          verticalSpace(4),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isVetinary
                        ? TextStyles.textStyle79b
                        : TextStyles.textStyle79,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: isVetinary
                        ? TextStyles.textStyle80b
                        : TextStyles.textStyle80,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isVetinary ? Colors.transparent : Colours.lightBlu,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w1p * 5,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isVetinary
                        ? Text(
                            "$count ${AppLocalizations.of(context)!.answers}",
                            style: TextStyles.textStyle81b,
                          )
                        : Text(
                            "$count ${AppLocalizations.of(context)!.answers}",
                            style: TextStyles.textStyle81,
                          ),
                    isVetinary
                        ? Text(
                            AppLocalizations.of(context)!.reply,
                            style: TextStyles.textStyle81c,
                          )
                        : SizedBox(
                            height: 18,
                            child: SvgPicture.asset(
                              "assets/images/forward-arrow.svg",
                            ),
                          ),
                    // Icon(Icons.navigate_next_outlined)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
