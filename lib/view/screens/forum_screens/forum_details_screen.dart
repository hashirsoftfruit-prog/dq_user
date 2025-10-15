// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/basic_response_model.dart';
import '../../../model/core/forum_detail_model.dart';
import '../../theme/constants.dart';
import '../../widgets/images_open_widget.dart';
import '../home_screen.dart';

class ForumDetailsScreen extends StatefulWidget {
  final int forumId;
  final bool? isVetinary;
  const ForumDetailsScreen({super.key, required this.forumId, this.isVetinary});
  @override
  State<ForumDetailsScreen> createState() => _ForumDetailsScreenState();
}

class _ForumDetailsScreenState extends State<ForumDetailsScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getForumDetails(widget.forumId);
    // _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    getIt<HomeManager>().disposeForumDetails();
    super.dispose();
  }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }

  var responseConroller = TextEditingController();
  var fnode = FocusNode();
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

        Widget imageContainer({String? url, List<String>? urls, int? indx}) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w1p * 2,
              vertical: w1p * 2,
            ),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  showDragHandle: true,
                  barrierColor: Colors.white,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  // showDragHandle: true,
                  context: context,
                  builder: (context) =>
                      // PhotoViewContainer(w1p: w1p,h1p: h1p,url: url!)
                      GalleryImageViewWrapper(
                        paginationFn: () {
                          // print("jfdfahdjsfhsadjfasf");
                          // getIt<CordManager>().incrementPageIndex();
                          // getIt<CordManager>().getGalleryImages();
                        },
                        titleGallery: 'Gallery',
                        galleryItems: urls!.map((e) {
                          // var indxx = urls.indexOf(e);

                          return GalleryItemModel(
                            id: getIt<StateManager>().generateRandomString(),
                            index: indx!,
                            imageUrl: e,
                          );
                        }).toList(),
                        backgroundColor: Colors.transparent,
                        initialIndex: indx,
                        loadingWidget: null,
                        errorWidget: null,
                        maxScale: 10,
                        minScale: 0.5,
                        reverse: false,
                        showListInGalley: false,
                        showAppBar: false,
                        closeWhenSwipeUp: false,
                        closeWhenSwipeDown: true,
                        radius: 5,
                        imageList: urls,
                      ),
                );
              },
              child: SizedBox(
                width: w10p * 1.5,
                height: w10p * 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: url ?? "",
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                  //
                  // FadeInImage.assetNetwork(
                  // fit: BoxFit.fill,
                  //   placeholder: 'assets/images/imgPH.png',
                  //   image:url??"",
                  //   imageErrorBuilder: (context, url, error) => Image.asset('assets/images/imgPH.png',fit: BoxFit.fitHeight
                  //     ,),)
                ),
              ),
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.forum,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: pad(
                horizontal: w1p * 5,
                child: RefreshIndicator(
                  onRefresh: () async {
                    getIt<HomeManager>().getForumDetails(widget.forumId);
                  },
                  child: ListView(
                    // controller: _controller,
                    children: [
                      verticalSpace(h1p * 1),
                      mgr.forumDetailsLoader == true &&
                              mgr.forumDetailsModel == null
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
                          : mgr.forumDetailsModel?.forumDetails != null
                          ? Builder(
                              builder: (context) {
                                ForumDetails f =
                                    mgr.forumDetailsModel!.forumDetails!;
                                String fullName = f.fullName ?? '';
                                fullName = fullName.length > 20
                                    ? "${fullName.substring(0, 14)}...${fullName.substring(fullName.length - 5, fullName.length)}"
                                    : fullName;
                                String image = f.userImage ?? '';
                                // String age = 'f.';
                                // String place = 'f.';
                                String date = getIt<StateManager>()
                                    .convertStringDateToyMMMMd(
                                      f.forumCreatedDate!,
                                    );
                                String title = f.title ?? "";
                                String subtitle = f.description ?? "";
                                // print("title");
                                // print(title);
                                // print(subtitle);
                                List<String> images = f.files!
                                    .map((e) => e.file)
                                    .where((file) => file != null)
                                    .cast<String>()
                                    .toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [boxShadow9, boxShadow9b],
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xffFBFBFB),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      // fit: widget.fit,
                                                      imageUrl:
                                                          '${StringConstants.baseUrl}$image',
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Image.asset(
                                                            "assets/images/forum-person-placeholder.png",
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Image.asset(
                                                            "assets/images/forum-person-placeholder.png",
                                                          ),
                                                    ),
                                                  ),
                                                ),

                                                horizontalSpace(8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getIt<StateManager>()
                                                          .capitalizeFirstLetter(
                                                            fullName,
                                                          ),
                                                      style: TextStyles
                                                          .textStyle77,
                                                    ),
                                                    Text(
                                                      date,
                                                      style: TextStyles
                                                          .textStyle78b,
                                                    ),

                                                    // Text("$age, $place",style: TextStyles.textStyle78,),
                                                  ],
                                                ),
                                                // Spacer(),
                                                // Text(date,style: TextStyles.textStyle78b,)
                                              ],
                                            ),
                                            verticalSpace(4),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 18.0,
                                                    vertical: 8,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style:
                                                        TextStyles.textStyle83,
                                                  ),
                                                  Text(
                                                    subtitle,
                                                    style:
                                                        TextStyles.textStyle83b,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            f.files != null
                                                ? Wrap(
                                                    children: images.map((img) {
                                                      var i = images.indexOf(
                                                        img,
                                                      );

                                                      // imageContainer(StringContants.imageBaseUrl+f.imgName!)).toList()
                                                      return imageContainer(
                                                        url:
                                                            "${StringConstants.baseUrl}$img",
                                                        indx: i,
                                                        urls: images
                                                            .map(
                                                              (e) =>
                                                                  '${StringConstants.baseUrl}$e',
                                                            )
                                                            .toList(),
                                                      );
                                                    }).toList(),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    verticalSpace(8),
                                    mgr
                                                    .forumDetailsModel
                                                    ?.forumDetails
                                                    ?.editable ==
                                                true ||
                                            (widget.isVetinary == true &&
                                                mgr
                                                        .forumDetailsModel
                                                        ?.forumDetails
                                                        ?.selfForum !=
                                                    true &&
                                                mgr
                                                        .forumDetailsModel
                                                        ?.forumDetails
                                                        ?.isAlreadyResponded !=
                                                    true)
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(
                                                  0xff727272,
                                                ).withOpacity(0.5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              child: Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          // fit: widget.fit,
                                                          imageUrl:
                                                              '${StringConstants.baseUrl}${getIt<SharedPreferences>().getString(StringConstants.proImage)}',
                                                          placeholder:
                                                              (
                                                                context,
                                                                url,
                                                              ) => Image.asset(
                                                                "assets/images/forum-person-placeholder.png",
                                                              ),
                                                          errorWidget:
                                                              (
                                                                context,
                                                                url,
                                                                error,
                                                              ) => Image.asset(
                                                                "assets/images/forum-person-placeholder.png",
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  horizontalSpace(8),
                                                  Expanded(
                                                    child: SizedBox(
                                                      // height:50,
                                                      // width:w1p*70,
                                                      child: TextField(
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                        focusNode: fnode,
                                                        controller:
                                                            responseConroller,
                                                        decoration: InputDecoration(
                                                          hintText:
                                                              AppLocalizations.of(
                                                                context,
                                                              )!.addAComment,
                                                          hintStyle: TextStyles
                                                              .textStyle84,
                                                          border: InputBorder
                                                              .none, // No border
                                                          enabledBorder: InputBorder
                                                              .none, // No border when enabled
                                                          focusedBorder: InputBorder
                                                              .none, // No border when focused
                                                        ),
                                                        minLines: 1,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (responseConroller
                                                          .text
                                                          .isNotEmpty) {
                                                        BasicResponseModel? res;

                                                        //checking whether the textField is using for editing the response that submitted before

                                                        if (mgr
                                                                .forumDetailsModel
                                                                ?.forumDetails
                                                                ?.editable !=
                                                            true) {
                                                          res =
                                                              await getIt<
                                                                    HomeManager
                                                                  >()
                                                                  .publicForumResponse(
                                                                    widget
                                                                        .forumId,
                                                                    responseConroller
                                                                        .text,
                                                                  );
                                                        } else {
                                                          res = await getIt<HomeManager>()
                                                              .editForumResponse(
                                                                mgr
                                                                    .forumDetailsModel
                                                                    ?.forumDetails
                                                                    ?.alreadyRespondedId,
                                                                responseConroller
                                                                    .text,
                                                              );
                                                        }
                                                        // var res =await getIt<HomeManager>().publicForumResponse(widget.forumId,responseConroller.text);
                                                        if (res.status ==
                                                            true) {
                                                          responseConroller
                                                                  .text =
                                                              '';

                                                          showTopSnackBar(
                                                            Overlay.of(context),
                                                            SuccessToast(
                                                              maxLines: 2,
                                                              message:
                                                                  res.message ??
                                                                  "",
                                                            ),
                                                          );
                                                          getIt<HomeManager>()
                                                              .getForumDetails(
                                                                widget.forumId,
                                                              );
                                                        } else {
                                                          showTopSnackBar(
                                                            Overlay.of(context),
                                                            ErrorToast(
                                                              maxLines: 2,
                                                              message:
                                                                  res.message ??
                                                                  "",
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        showTopSnackBar(
                                                          Overlay.of(context),
                                                          ErrorToast(
                                                            maxLines: 2,
                                                            message:
                                                                AppLocalizations.of(
                                                                  context,
                                                                )!.oopsItLookLikeYouForgotToType,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: w1p * 2,
                                                          ),
                                                      child: SvgPicture.asset(
                                                        "assets/images/icon-send.svg",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    verticalSpace(h1p),
                                    Container(
                                      width: maxWidth,
                                      color: Colours.lightBlu,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 8,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.answers,
                                          style: t500_14.copyWith(
                                            color: clr444444,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Entry(
                                      xOffset: -1000,
                                      // scale: 20,
                                      delay: const Duration(milliseconds: 0),
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      curve: Curves.ease,
                                      child: Entry(
                                        opacity: .5,
                                        // angle: 3.1415,
                                        delay: const Duration(milliseconds: 0),
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        curve: Curves.decelerate,
                                        child:
                                            mgr
                                                        .forumDetailsModel!
                                                        .forumDetails!
                                                        .response !=
                                                    null &&
                                                mgr
                                                    .forumDetailsModel!
                                                    .forumDetails!
                                                    .response!
                                                    .isNotEmpty
                                            ? Column(
                                                children: mgr
                                                    .forumDetailsModel!
                                                    .forumDetails!
                                                    .response!
                                                    .map(
                                                      (e) => ForumResponse(
                                                        forumId: widget.forumId,
                                                        responseConroller:
                                                            responseConroller,
                                                        fNode: fnode,
                                                        h1p: h1p,
                                                        w1p: w1p,
                                                        pf: e,
                                                      ),
                                                    )
                                                    .toList(),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.all(
                                                  28.0,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.noOneAnswered,
                                                    style: TextStyles
                                                        .notAvailableTxtStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
    );
  }
}

class ForumResponse extends StatelessWidget {
  final double w1p;
  final double h1p;
  final ForumResponseModel pf;
  final TextEditingController responseConroller;
  final FocusNode fNode;
  final int forumId;
  const ForumResponse({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.fNode,
    required this.responseConroller,
    required this.pf,
    required this.forumId,
  });

  @override
  Widget build(BuildContext context) {
    bool loader = Provider.of<HomeManager>(context).forumLoader;

    Widget flagWidget({required bool helpful}) {
      return InkWell(
        onTap: () async {
          var res = await getIt<HomeManager>().forumResponseReactionSave(
            forumRespId: pf.id!,
            reaction: helpful ? 1 : 2,
          );

          if (res.status == true) {
            getIt<HomeManager>().getForumDetails(forumId);

            showTopSnackBar(
              Overlay.of(context),
              SuccessToast(maxLines: 2, message: res.message ?? ""),
            );
          } else {
            showTopSnackBar(
              Overlay.of(context),
              ErrorToast(maxLines: 2, message: res.message ?? ""),
            );
          }
          //NOT COMPLETED
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(helpful ? "Yes" : "No", style: TextStyles.textStyle85),
        ),
      );
    }

    String name = pf.appUserName ?? pf.doctorName ?? '';
    // String age = 'pf.';
    String img = pf.appUserimage ?? pf.doctorImage ?? "";
    // String place = 'pf.';
    String date = getIt<StateManager>().convertStringDateToyMMMMd(
      DateTime.now().toString(),
    );
    String subtitle = pf.response ?? "";

    return Container(
      // margin: EdgeInsets.only(top: h1p,bottom: h1p,right: 12,left: 12),
      decoration: const BoxDecoration(
        // boxShadow: [boxShadow8,boxShadow8b,],
        // borderRadius: BorderRadius.circular(8),
        border: Border(
          bottom: BorderSide(
            color: Color(0xff868686), // Border color
            width: 0.5, // Border width
          ),
        ),
        // color:
        // Color(0xffFBFBFB)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
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
                      imageUrl: '${StringConstants.baseUrl}$img',
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
                      style: TextStyles.textStyle77,
                    ),
                    Text(date, style: TextStyles.textStyle78b),

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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8,
              ),
              child: Text(
                subtitle,
                style: TextStyles.textStyle83b,
                // maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          pf.selfResponse == true
              ? GestureDetector(
                  onTap: () {
                    getIt<HomeManager>().setEditableVariable(
                      val: true,
                      responseId: pf.id,
                    );

                    responseConroller.text = pf.response ?? "";
                    fNode.requestFocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.editYourResponse,
                          style: TextStyles.textStyle85,
                        ),
                        const Icon(
                          Icons.edit_outlined,
                          color: Colors.black38,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: pf.selfResponse == true
                      ? const SizedBox()
                      : pf.isLiked == 0
                      ? Row(
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.wasThisAnswerHelpful,
                              style: TextStyles.textStyle84b,
                            ),
                            loader
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.updating,
                                      style: TextStyles.textStyle85,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      flagWidget(helpful: true),
                                      flagWidget(helpful: false),
                                    ],
                                  ),
                          ],
                        )
                      : pf.isLiked == 1
                      ? Text(
                          AppLocalizations.of(
                            context,
                          )!.youMarkedThisResponseAsHelpful,
                          style: TextStyles.textStyle84b,
                        )
                      : pf.isLiked == 2
                      ? Text(
                          AppLocalizations.of(
                            context,
                          )!.youMarkedThisResponseAsNotHelpful,
                          style: TextStyles.textStyle84b,
                        )
                      : const SizedBox(),
                ),
        ],
      ),
    );
  }
}
