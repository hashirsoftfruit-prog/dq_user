// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../model/core/forum_general_detail_model.dart';
import '../../theme/constants.dart';

class AskFreeQuestionScreen extends StatefulWidget {
  final bool? isVetinary;
  final TextEditingController? titleController;
  const AskFreeQuestionScreen({
    super.key,
    this.isVetinary,
    this.titleController,
  });
  @override
  State<AskFreeQuestionScreen> createState() => _AskFreeQuestionScreenState();
}

class _AskFreeQuestionScreenState extends State<AskFreeQuestionScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;
  var titleC = TextEditingController();
  var descrtiptnC = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  // Uint8List? _imageBytes;

  Future<List<XFile>?> _getImage() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 50);

    if (images.isNotEmpty) {
      return images;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.titleController != null) {
      titleC.text = widget.titleController!.text;
    }
    getIt<HomeManager>().getForumGeneralTerms(isVetenary: widget.isVetinary);
    // _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    getIt<HomeManager>().disposeForumAsk();
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
  final _formKey = GlobalKey<FormState>();

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

        title(title) {
          return Padding(
            padding: EdgeInsets.only(
              left: w1p * 5,
              bottom: h1p,
              top: h1p * 1.5,
            ),
            child: Text(
              title,
              style: t500_13.copyWith(color: const Color(0xff474747)),
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.askQuestion,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: pad(
                child: ListView(
                  // controller: _controller,
                  children: [
                    // verticalSpace(h1p*1),
                    mgr.forumLoader == true ||
                            mgr.forumGeneralDatamodel?.treatments == null
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
                            yOffset: -100,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.isVetinary == true
                                      ? const SizedBox()
                                      : title(
                                          AppLocalizations.of(
                                            context,
                                          )!.problemAndTreatment,
                                        ),
                                  widget.isVetinary == true
                                      ? const SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 5,
                                          ),
                                          child: ForumDropdown(
                                            mgr
                                                .forumGeneralDatamodel!
                                                .treatments!,
                                          ),
                                        ),
                                  // verticalSpace(h1p),
                                  title(AppLocalizations.of(context)!.title),

                                  ForumTextField(
                                    maxLines: 1,
                                    controller: titleC,
                                    label: AppLocalizations.of(context)!.title,
                                    w1p: w1p,
                                    h1p: h1p,
                                  ),
                                  // verticalSpace(h1p),
                                  title(
                                    AppLocalizations.of(context)!.description,
                                  ),

                                  ForumTextField(
                                    maxLines: 6,
                                    controller: descrtiptnC,
                                    label: AppLocalizations.of(
                                      context,
                                    )!.description,
                                    w1p: w1p,
                                    h1p: h1p,
                                  ),

                                  title(
                                    "${AppLocalizations.of(context)!.images} ${AppLocalizations.of(context)!.optional}",
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 5,
                                    ),
                                    child: SizedBox(
                                      height: 90,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colours.lightGrey,
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    List<XFile>? images =
                                                        await _getImage();
                                                    for (var img in images!) {
                                                      // final bytes = await img.readAsBytes();
                                                      // final String imageBase64 = base64Encode(bytes);
                                                      getIt<HomeManager>()
                                                          .addImages(img.path);

                                                      // base64Images.add(imageBase64);
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    height: 70,
                                                    width: 70,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                              ),
                                                          child: SizedBox(
                                                            width: 25,
                                                            child: SvgPicture.asset(
                                                              "assets/images/icon-attachment-line.svg",
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Add",
                                                          style: t400_12
                                                              .copyWith(
                                                                color:
                                                                    const Color(
                                                                      0xff474747,
                                                                    ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                ...mgr.forumImages
                                                    .map(
                                                      (e) =>
                                                          ImageBox(e, 80, () {
                                                            getIt<HomeManager>()
                                                                .removeImage(e);
                                                          }),
                                                    )
                                                    .toList()
                                                    .reversed,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton: InkWell(
                onTap: () async {
                  String title = titleC.text;
                  String descriptn = descrtiptnC.text;
                  int? treatmentId = mgr.selectedForumTreatmentItem?.id;

                  if (_formKey.currentState!.validate() &&
                      treatmentId != null) {
                    var res = await getIt<HomeManager>().submitNewForum(
                      title: title,
                      description: descriptn,
                      treatmentId: treatmentId,
                      imgs: mgr.forumImages,
                    );

                    if (res.status == true) {
                      Navigator.pop(context, true);
                      showTopSnackBar(
                        Overlay.of(context),
                        SuccessToast(maxLines: 3, message: res.message ?? ""),
                      );
                    } else {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          backgroundColor: Colours.toastRed,
                          maxLines: 2,
                          message: res.message ?? "",
                        ),
                      );
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colours.toastRed,
                        maxLines: 2,
                        message: "All fields are mandatory",
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow7],
                    color: Colours.primaryblue,
                    shape: BoxShape.circle,
                  ),
                  width: w10p * 1.7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/images/send-fill.png"),
                  ),
                ),
              ),
              // Container(margin: EdgeInsets.symmetric(vertical: 18),
              //
              //   decoration: BoxDecoration(
              //       boxShadow: [boxShadow7],
              //       borderRadius: BorderRadius.circular(100),
              //
              //       color:Colors.white
              //       // color:Color(0xffF0F0F0)
              //   ),
              //   child: Column(mainAxisSize: MainAxisSize.min,
              //     children: [
              //
              //       // Padding(
              //       //   padding: const EdgeInsets.symmetric(vertical: 18),
              //       //   child: InkWell(onTap: ()async{
              //       //     List<XFile>? images = await _getImage();
              //       //     for (var img in images!) {
              //       //
              //       //
              //       //       // final bytes = await img.readAsBytes();
              //       //       // final String imageBase64 = base64Encode(bytes);
              //       //       getIt<HomeManager>().addImages(img.path);
              //       //
              //       //       // base64Images.add(imageBase64);
              //       //     }
              //       //
              //       //
              //       //
              //       //   },
              //       //       child: Column(
              //       //         children: [
              //       //           Padding(
              //       //             padding: const EdgeInsets.symmetric(horizontal: 8),
              //       //
              //       //             child: SizedBox(
              //       //                 width: 25,
              //       //                 child: SvgPicture.asset("assets/images/icon-attachment-line.svg")),
              //       //           ),
              //       //           Text("Photos",style: TextStyles.lstItemTxt,)
              //       //         ],
              //       //       )),
              //       // ),
              //
              //       // verticalSpace(h1p*1),
              //       InkWell(
              //         onTap: ()async{
              //
              //           String title = titleC.text;
              //           String descriptn = descrtiptnC.text;
              //           int? treatmentId = mgr.selectedForumTreatmentItem?.id;
              //
              //
              //           if(_formKey.currentState!.validate() && treatmentId !=null ) {
              //             var res = await getIt<HomeManager>().submitNewForum(
              //                 title: title,
              //                 description: descriptn,
              //                 treatmentId: treatmentId,
              //                 imgs: mgr.forumImages);
              //
              //             if(res.status==true){
              //   Navigator.pop(context,true);
              //               showTopSnackBar(
              //                   Overlay.of(context),
              //                   SuccessToast(maxLines:3,
              //                     message:
              //                     res.message ?? "",
              //                   ));
              //             }else{
              //
              //               showTopSnackBar(
              //                   Overlay.of(context),
              //                   CustomSnackBar.success(backgroundColor:Colours.toastRed,maxLines:2,
              //                     message:
              //                     res.message ?? "",
              //                   ));
              //             }
              //           }else{
              //             showTopSnackBar(
              //                 Overlay.of(context),
              //                 CustomSnackBar.success(backgroundColor:Colours.toastRed,maxLines:2,
              //                   message:
              //                   "All fields are mandatory",
              //                 ));
              //           }
              //
              //           },
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color:Colours.primaryblue,
              //               shape: BoxShape.circle),
              //           width: w10p*1.7,
              //           child: Padding(
              //             padding: const EdgeInsets.all(20.0),
              //             child: Image.asset("assets/images/send-fill.png"),
              //           ),),
              //       ),
              //     ],
              //   ),
              // ),
            );
          },
        );
      },
    );
  }
}

class ForumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final double w1p;
  final double h1p;
  const ForumTextField({
    super.key,
    required this.controller,
    required this.maxLines,
    required this.label,
    required this.w1p,
    required this.h1p,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w1p * 5),
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [ BoxShadow(color: Colors.grey.shade200,spreadRadius: 1.5,blurRadius: 1)]
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        textCapitalization: TextCapitalization
            .sentences, // Automatically capitalizes the first letter of each sentence

        style: t500_14.copyWith(color: const Color(0xff474747)),
        textInputAction: TextInputAction.next,
        cursorColor: Colours.primaryblue.withOpacity(0.5),
        maxLines: maxLines,
        minLines: maxLines,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          hintText: label,
          hintStyle: t400_14.copyWith(color: clr757575),
          border: InputBorder.none,

          // fillColor: Color(0xff),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
        ),

        controller: controller,
      ),
    );
  }
}

class ForumDropdown extends StatelessWidget {
  final List<Treatments> list;
  const ForumDropdown(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: w1p*5),
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [ BoxShadow(color: Colors.grey.shade200,spreadRadius: 1.5,blurRadius: 1)],
      ),
      child: CustomDropdown<Treatments>(
        decoration: CustomDropdownDecoration(
          closedFillColor: Colors.transparent,
          listItemStyle: t500_14.copyWith(color: clr444444),
          headerStyle: t500_14.copyWith(color: const Color(0xff474747)),
          hintStyle: t400_13.copyWith(color: const Color(0xff474747)),
          // closedBorder:Border.all(color: Colours.lightBlu)
        ),
        hintText: AppLocalizations.of(context)!.selectTreatmentType,
        closedHeaderPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 18,
        ),
        items: list,
        listItemBuilder: (context, item, isSelected, onItemSelect) {
          return GestureDetector(
            onTap: () {
              onItemSelect(); // Trigger the selection
            },
            child: Container(
              color: isSelected ? Colors.grey[300] : Colors.transparent,
              padding: const EdgeInsets.all(2),
              child: Text(
                item.title ??
                    'No title', // Assuming `Treatments` has a `title` property
                style: isSelected
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : t400_14.copyWith(color: clr757575),
              ),
            ),
          );
        },
        headerBuilder: (co0ntext, item, selected) {
          return Container(
            padding: const EdgeInsets.all(2),
            child: Text(
              item.title ??
                  'No title', // Assuming `Treatments` has a `title` property
              style: t500_14.copyWith(color: const Color(0xff474747)),
            ),
          );
        },
        // .map((e)=>e.title!).toList(),
        // initialItem: list[0],
        onChanged: (value) {
          // print("changed");
          if (value != null) {
            getIt<HomeManager>().selectForumTreatmentItem(value);
          }
        },
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  final String imagePath;
  final double size;
  final Function() removeFn;
  const ImageBox(this.imagePath, this.size, this.removeFn, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xffECECEC),
              ),
              width: size,
              height: size,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.close, size: 10, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                removeFn();
              },
              child: SizedBox(width: size / 2, height: size / 2),
            ),
          ),
        ],
      ),
    );
  }
}
