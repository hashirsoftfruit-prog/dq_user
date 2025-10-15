import 'dart:async';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/forum_screens/forum_list_screens.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controller/managers/home_manager.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../model/core/forum_list_model.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/constants.dart';
import '../home_screen.dart';
import 'forum_details_screen.dart';

class ForumSearchScreen extends StatefulWidget {
  final int forumType; //if veterinary forum type =1 otherwise type = 2
  const ForumSearchScreen(this.forumType, {super.key});
  @override
  State<ForumSearchScreen> createState() => _ForumSearchScreenState();
}

class _ForumSearchScreenState extends State<ForumSearchScreen> {
  // AvailableDocsModel docsData;
  int index = 1;
  unFocusFn() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
  //
  // @override
  // void initState() {

  //
  // }
  @override
  void initState() {
    // getIt<HomeManager>().getVetinaryForumList();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // print(1111111111);
      // index++;
      onSearchChanged(searchCntrlr.text);
    }
  }

  @override
  void dispose() {
    getIt<HomeManager>().disposeForumSearch();
    _controller.dispose();
    super.dispose();
  }

  var searchCntrlr = TextEditingController();

  Timer? _debounce;

  void onSearchChanged(String query, {bool? isRefresh}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Make the API call here
      getIt<HomeManager>().searchForum(
        keyword: query,
        type: widget.forumType,
        isRefresh: isRefresh,
      );
    });
  }

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
                mgr.publicForumSearchResultsModel?.publicForums;

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
                      Navigator.pop(context);
                      // getIt<HomeManager>().setEnableSearchVariable(!mgr.isSearchEnabled);
                    },
                    child: const Icon(Icons.close, key: ValueKey<int>(2)),
                  ),
                ),

                body: RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView(
                    controller: _controller,
                    children: [
                      // mgr.isSearchEnabled?
                      Entry(
                        yOffset: -100,
                        // scale: 20,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                          child: TextFormField(
                            onTapOutside: (f) {
                              unFocusFn();
                            },
                            controller: searchCntrlr,
                            autofocus: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.search),
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: outLineBorder,
                              enabledBorder: outLineBorder,
                              focusedBorder: outLineBorder,
                            ),
                            onChanged: (val) {
                              if (val.length > 2) {
                                onSearchChanged(val, isRefresh: true);
                              } else {
                                getIt<HomeManager>().resetSearchResults();
                              }
                            },
                          ),
                        ),
                      ),

                      // :SizedBox(),
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
                                                              isVetinary:
                                                                  widget
                                                                      .forumType ==
                                                                  1,
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
                                                                .publicForumSearchResultsModel!
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
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: w10p * 3,
                                                child: Image.asset(
                                                  "assets/images/forum-search.png",
                                                  color: Colours.lightBlu,
                                                ),
                                              ),
                                              Text(
                                                searchCntrlr.text.isEmpty
                                                    ? "The forums you search will appear here."
                                                    : "Sorry, we couldn't find any results",
                                                style: const TextStyle(
                                                  color: Colours.lightBlu,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      "Product Sans Medium",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
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
