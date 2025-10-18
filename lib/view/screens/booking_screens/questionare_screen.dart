// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dqapp/controller/managers/questionare_manager.dart';
import 'package:dqapp/model/core/questionare_response_model.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../model/helper/service_locator.dart';
import '../../widgets/questionaire_widgets.dart';
import '../../widgets/common_widgets.dart';
import '../home_screen.dart';
import 'loading_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  final int bookingId;
  final String appoinmentId;
  const QuestionnaireScreen({
    super.key,
    required this.bookingId,
    required this.appoinmentId,
  });

  @override
  State<QuestionnaireScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<QuestionnaireScreen> {
  int selectedPage = 0;
  @override
  void initState() {
    getIt<QuestionnaireManager>().getQuestionnare(widget.appoinmentId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    getIt<QuestionnaireManager>().disposeQuestionare();
  }

  final _pageCntrlr = PageController();

  Future<bool> onWillPop() async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BookingCloseAlert(
          msg: AppLocalizations.of(context)!.closingMsg1,
        );
      },
    );

    if (result != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (ff) => false,
      );
      return Future.value(false);
    } else {
      return Future.value(false);
    }
  }

  bool questionareSubmitted = false;

  @override
  Widget build(BuildContext context) {
    // List<NotificationList> notificationList = Provider.of<UserManager>(context).notificationList;
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;

        submit() async {
          var result = await getIt<QuestionnaireManager>().submitQuestionnare(
            widget.bookingId,
          );
          if (result.status == true) {
            showTopSnackBar(
              Overlay.of(context),
              SuccessToast(message: result.message ?? ""),
            );

            setState(() {
              questionareSubmitted = true;
            });

            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: widget.bookingId,appoinmentId: widget.appoinmentId,)));
          } else {
            showTopSnackBar(
              Overlay.of(context),
              ErrorToast(message: result.message ?? ""),
            );
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>LoadingScreen(widget.appointmentId)));
          }
        }

        return Consumer<QuestionnaireManager>(
          builder: (context, mgr, child) {
            return WillPopScope(
              onWillPop: onWillPop,
              child: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                // appBar: getIt<SmallWidgets>().appBarWidget(hideBackBtn: true, height: h10p*0.9, width: w10p,
                //     title: "Connecting...",fn: (){
                //       Navigator.pop(context);
                //     }),
                body: mgr.questionnaireModel == null
                    ? Center(
                        child: myLoader(
                          width: maxWidth,
                          height: maxHeight,
                          visibility: true,
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff6C6EB8), Color(0xffFE9297),
                              // Color(0xff83BCEA),
                              // Color(0xff4E8DBF),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  mgr.questionareLoader == true
                                      ? Center(
                                          child: myLoader(
                                            width: 100,
                                            height: 100,
                                            visibility: true,
                                          ),
                                        )
                                      : TimerWidget(
                                          appoinmentId: widget.appoinmentId,
                                          bookingId: widget.bookingId,
                                          onBackPress: onWillPop,
                                          fn: () async {
                                            if (questionareSubmitted == false) {
                                              await getIt<
                                                    QuestionnaireManager
                                                  >()
                                                  .submitQuestionnare(
                                                    widget.bookingId,
                                                  );
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                            questionareSubmitted == false
                                ? (mgr.questionnaireModel == null ||
                                          mgr
                                                  .questionnaireModel!
                                                  .questionnaires ==
                                              null)
                                      ? const SizedBox()
                                      : Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: clrFFFFFF,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(30),
                                                  ),
                                              boxShadow: [boxShadow7],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: w10p * 0.4,
                                                vertical: 8,
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: PageView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      controller: _pageCntrlr,
                                                      onPageChanged: (val) {
                                                        setState(() {
                                                          selectedPage = val;
                                                        });
                                                      },
                                                      padEnds: true,
                                                      itemCount: mgr
                                                          .questionnaireModel!
                                                          .questionnaires!
                                                          .length,
                                                      itemBuilder: (context, index) {
                                                        Questionnaires qn = mgr
                                                            .questionnaireModel!
                                                            .questionnaires![index];
                                                        return Container(
                                                          child:
                                                              qn.questionType ==
                                                                  StringConstants
                                                                      .qnTypeRadio
                                                              ? SelectQnQuestion(
                                                                  isMandatoryQn:
                                                                      qn.isMandatory ==
                                                                      true,
                                                                  elseFn: () {
                                                                    submit();
                                                                  },
                                                                  isFirstQn:
                                                                      index ==
                                                                      0,
                                                                  isLastQn:
                                                                      index ==
                                                                      mgr.questionnaireModel!.questionnaires!.length -
                                                                          1,
                                                                  pgCntrl:
                                                                      _pageCntrlr,
                                                                  w1p:
                                                                      w10p *
                                                                      0.1,
                                                                  h1p: h1p,
                                                                  data: qn,
                                                                )
                                                              : qn.questionType ==
                                                                    StringConstants
                                                                        .qnTypeSelect
                                                              ? SelectQnQuestion(
                                                                  isMandatoryQn:
                                                                      qn.isMandatory ==
                                                                      true,
                                                                  isFirstQn:
                                                                      index ==
                                                                      0,
                                                                  elseFn: () {
                                                                    submit();
                                                                  },
                                                                  isLastQn:
                                                                      index ==
                                                                      mgr.questionnaireModel!.questionnaires!.length -
                                                                          1,
                                                                  pgCntrl:
                                                                      _pageCntrlr,
                                                                  w1p:
                                                                      w10p *
                                                                      0.1,
                                                                  h1p: h1p,
                                                                  data: qn,
                                                                )
                                                              : qn.questionType ==
                                                                    StringConstants
                                                                        .qnTypeCheckBx
                                                              ? CheckBoxQuestion(
                                                                  isMandatoryQn:
                                                                      qn.isMandatory ==
                                                                      true,
                                                                  isFirstQn:
                                                                      index ==
                                                                      0,
                                                                  elseFn: () {
                                                                    submit();
                                                                  },
                                                                  isLastQn:
                                                                      index ==
                                                                      mgr.questionnaireModel!.questionnaires!.length -
                                                                          1,
                                                                  pgCntrl:
                                                                      _pageCntrlr,
                                                                  w1p:
                                                                      w10p *
                                                                      0.1,
                                                                  h1p: h1p,
                                                                  data: qn,
                                                                )
                                                              : qn.questionType ==
                                                                    StringConstants
                                                                        .qnTypeTxtBox
                                                              ? TextAreaQuestion(
                                                                  isMandatoryQn:
                                                                      qn.isMandatory ==
                                                                      true,
                                                                  isFirstQn:
                                                                      index ==
                                                                      0,
                                                                  elseFn: () {
                                                                    submit();
                                                                  },
                                                                  isLastQn:
                                                                      index ==
                                                                      mgr.questionnaireModel!.questionnaires!.length -
                                                                          1,
                                                                  pgCntrl:
                                                                      _pageCntrlr,
                                                                  w1p:
                                                                      w10p *
                                                                      0.1,
                                                                  h1p: h1p,
                                                                  data: qn,
                                                                )
                                                              : qn.questionType ==
                                                                    StringConstants
                                                                        .qnTypeTxtArea
                                                              ? TextAreaQuestion(
                                                                  isMandatoryQn:
                                                                      qn.isMandatory ==
                                                                      true,
                                                                  isFirstQn:
                                                                      index ==
                                                                      0,
                                                                  elseFn: () {
                                                                    submit();
                                                                  },
                                                                  isLastQn:
                                                                      index ==
                                                                      mgr.questionnaireModel!.questionnaires!.length -
                                                                          1,
                                                                  pgCntrl:
                                                                      _pageCntrlr,
                                                                  w1p:
                                                                      w10p *
                                                                      0.1,
                                                                  h1p: h1p,
                                                                  data: qn,
                                                                )
                                                              : SizedBox(
                                                                  width: 200,
                                                                  height: 200,
                                                                  child: Text(
                                                                    mgr
                                                                            .questionnaireModel!
                                                                            .questionnaires![index]
                                                                            .question ??
                                                                        "",
                                                                  ),
                                                                ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
    );
  }
}
