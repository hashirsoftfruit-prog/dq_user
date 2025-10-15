import 'package:dqapp/controller/managers/questionare_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../model/core/questionare_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../screens/booking_screens/booking_screen_widgets.dart';
import 'popup_with_scroll_list.dart';
import '../theme/constants.dart';

class RadioButtonQuestion extends StatelessWidget {
  final double w1p;
  final double h1p;
  final PageController pgCntrl;
  final bool isLastQn;
  final bool isFirstQn;
  final bool isMandatoryQn;
  final Questionnaires data;
  final Function elseFn;
  const RadioButtonQuestion({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pgCntrl,
    required this.isLastQn,
    required this.isFirstQn,
    required this.isMandatoryQn,
    required this.elseFn,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.question ?? "", style: t500_20.copyWith(color: clr2D2D2D)),
        verticalSpace(h1p * 3),
        Expanded(
          child: ListView(
            children: data.options!.map((e) {
              // var i = data.options!.indexOf(e);

              return InkWell(
                onTap: () {
                  getIt<QuestionnaireManager>().saveOptionAnswer(
                    allowMultiple: data.isMultipleAnswers,
                    optionId: e.id!,
                    qnId: data.id!,
                    qnType: data.questionType!,
                  );
                },
                child: pad(
                  vertical: h1p,
                  horizontal: w1p * 2,
                  // padding:  EdgeInsets.only(left: w1p*2,),
                  child: Row(
                    children: [
                      SizedBox(
                        // width: w1p*15,
                        height: w1p * 4,
                        child: SvgPicture.asset(
                          fit: BoxFit.contain,
                          data.optionIdList.contains(e.id)
                              ? "assets/images/circle-selected.svg"
                              : "assets/images/circle-unselected.svg",
                        ),
                      ),
                      horizontalSpace(w1p * 0.5),
                      SizedBox(
                        width: w1p * 70,
                        child: Text(
                          e.option ?? "",
                          style: t500_16.copyWith(color: clr2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              //   Row(children: [
              //   Text(e.option??"")
              // ],);
            }).toList(),
          ),
        ),

        // Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(),
            !isFirstQn
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      pgCntrl.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    child: getBtn(
                      h1p,
                      w1p,
                      AppLocalizations.of(context)!.backQn,
                    ),
                  )
                : const SizedBox(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (!isLastQn) {
                  pgCntrl.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                  );
                } else {
                  elseFn();
                }
              },
              child: getBtn(
                h1p,
                w1p,
                isLastQn
                    ? AppLocalizations.of(context)!.finish
                    : AppLocalizations.of(context)!.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CheckBoxQuestion extends StatelessWidget {
  final double w1p;
  final double h1p;
  final PageController pgCntrl;
  final bool isLastQn;
  final bool isFirstQn;
  final bool isMandatoryQn;
  final Questionnaires data;
  final Function elseFn;
  const CheckBoxQuestion({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pgCntrl,
    required this.isFirstQn,
    required this.isMandatoryQn,
    required this.isLastQn,
    required this.elseFn,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.question ?? "", style: t500_22.copyWith(color: clr2D2D2D)),
        verticalSpace(h1p * 3),
        Expanded(
          child: ListView(
            children: data.options!.map((e) {
              // var i = data.options!.indexOf(e);final

              return InkWell(
                onTap: () {
                  getIt<QuestionnaireManager>().saveOptionAnswer(
                    allowMultiple: data.isMultipleAnswers,
                    optionId: e.id!,
                    qnId: data.id!,
                    qnType: data.questionType!,
                  );
                },
                child: pad(
                  vertical: h1p,
                  horizontal: w1p * 2,
                  // padding:  EdgeInsets.only(left: w1p*2,),
                  child: Row(
                    children: [
                      SizedBox(
                        // width: w1p*15,
                        height: w1p * 4,
                        child: SvgPicture.asset(
                          fit: BoxFit.contain,
                          data.optionIdList.contains(e.id)
                              ? "assets/images/checkbox-checked.svg"
                              : "assets/images/checkbox-unchecked.svg",
                        ),
                      ),
                      horizontalSpace(w1p * 0.5),
                      SizedBox(
                        width: w1p * 70,
                        child: Text(
                          e.option ?? "",
                          style: t500_16.copyWith(color: clr2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              //   Row(children: [
              //   Text(e.option??"")
              // ],);
            }).toList(),
          ),
        ),

        // Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !isFirstQn
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      pgCntrl.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    child: getBtn(
                      h1p,
                      w1p,
                      AppLocalizations.of(context)!.backQn,
                    ),
                  )
                : const SizedBox(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (!isLastQn) {
                  pgCntrl.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                  );
                } else {
                  elseFn();
                }
              },
              child: getBtn(
                h1p,
                w1p,
                isLastQn
                    ? AppLocalizations.of(context)!.finish
                    : AppLocalizations.of(context)!.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SelectQnQuestion extends StatelessWidget {
  final double w1p;
  final double h1p;
  final Questionnaires data;
  final PageController pgCntrl;
  final bool isLastQn;
  final bool isFirstQn;
  final bool isMandatoryQn;
  final Function elseFn;
  const SelectQnQuestion({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.data,
    required this.isFirstQn,
    required this.isMandatoryQn,
    required this.pgCntrl,
    required this.isLastQn,
    required this.elseFn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(h1p * 2),

        Text(data.question ?? "", style: t500_20.copyWith(color: clr2D2D2D)),
        // verticalSpace(h1p * 1),
        Expanded(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: data.options!.map((e) {
              // var i = data.options!.indexOf(e);
              return GestureDetector(
                onTap: () {
                  getIt<QuestionnaireManager>().saveOptionAnswer(
                    allowMultiple: data.isMultipleAnswers,
                    qnId: data.id!,
                    optionId: e.id!,
                  );
                },
                child: pad(
                  vertical: h1p * 0.5,
                  horizontal: h1p * 1,
                  child: GenderBox(
                    h1p: h1p,
                    w1p: w1p,
                    selected: data.optionIdList.contains(e.id),
                    txt: e.option ?? "",
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !isFirstQn
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      pgCntrl.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    child: getBtn(
                      h1p,
                      w1p,
                      AppLocalizations.of(context)!.backQn,
                    ),
                  )
                : const SizedBox(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (!isLastQn) {
                  pgCntrl.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                  );
                } else {
                  elseFn();
                }
              },
              child: getBtn(
                h1p,
                w1p,
                isLastQn
                    ? AppLocalizations.of(context)!.finish
                    : AppLocalizations.of(context)!.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TextAreaQuestion extends StatelessWidget {
  final double w1p;
  final double h1p;
  final Questionnaires data;
  final PageController pgCntrl;
  final Function elseFn;
  final bool isLastQn;
  final bool isFirstQn;
  final bool isMandatoryQn;
  const TextAreaQuestion({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pgCntrl,
    required this.elseFn,
    required this.isFirstQn,
    required this.isMandatoryQn,
    required this.isLastQn,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String answer =
        Provider.of<QuestionnaireManager>(context).questionareTextAnswer ??
        data.descriptiveAnswer;
    // var answerCntlr = TextEditingController(text: data.descriptiveAnswer);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.question ?? "", style: t500_20.copyWith(color: clr2D2D2D)),
        verticalSpace(h1p * 3),
        pad(
          vertical: h1p,
          // padding:  EdgeInsets.only(left: w1p*2,),
          child: TextField(
            readOnly: true,
            onTap: () {
              showDialog(
                // backgroundColor: Colors.white,
                // isScrollControlled: false,
                useSafeArea: true,
                // showDragHandle: true,
                context: context,
                builder: (context) => TextFieldPop(
                  // isEmail:false,
                  value: answer,
                  fn: (val) {
                    // answerCntlr.text = val;

                    getIt<QuestionnaireManager>().setQuestionareText(val);

                    // getIt<ProfileManager>().updateEmail(val);
                    // getIt<ProfileManager>().updatePersonalDetails({"email":val});
                  },
                ),
              );
            },
            style: t500_14.copyWith(color: const Color(0xff313131)),

            // controller: answerCntlr,
            // keyboardType: TextInputType.multiline,
            // minLines: 1,

            // maxLines: 4,
            decoration: InputDecoration(
              hintText: answer.isNotEmpty
                  ? answer
                  : AppLocalizations.of(context)!.answer,
              hintStyle: t500_14.copyWith(color: const Color(0xff313131)),
              enabledBorder: outLineBorder,
              border: outLineBorder,
              focusedBorder: outLineBorder,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),

        // Row(
        //   children: [
        //     Expanded(
        //       child: InkWell(
        //         onTap: () {
        //
        //         },
        //         child: Container(
        //             decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                     colors: [Colours.grad1, Colours.primaryblue]),
        //                 borderRadius: BorderRadius.circular(10)),
        //             child: pad(
        //                 horizontal: w1p * 5,
        //                 vertical: h1p * 1,
        //                 child: Text(
        //                   "Save",
        //                   style: TextStyles.textStyle4,
        //                   textAlign: TextAlign.center,
        //                 ))),
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !isFirstQn
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      pgCntrl.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    child: getBtn(
                      h1p,
                      w1p,
                      AppLocalizations.of(context)!.backQn,
                    ),
                  )
                : const SizedBox(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).unfocus();

                if (!isLastQn) {
                  if (answer.isNotEmpty) {
                    getIt<QuestionnaireManager>().saveTextAnswer(
                      txtAnswer: answer,
                      qnId: data.id!,
                      qnType: data.questionType!,
                    );
                  }

                  pgCntrl.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                  );
                } else {
                  if (answer.isNotEmpty) {
                    getIt<QuestionnaireManager>().saveTextAnswer(
                      txtAnswer: answer,
                      qnId: data.id!,
                      qnType: data.questionType!,
                    );
                  }

                  elseFn();
                }
              },
              child: getBtn(
                h1p,
                w1p,
                isLastQn
                    ? AppLocalizations.of(context)!.finish
                    : AppLocalizations.of(context)!.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

getBtn(double h1p, double w1p, String txt) {
  return pad(
    vertical: h1p * 3.4,
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colours.grad1, Colours.primaryblue],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: pad(
        horizontal: w1p * 6,
        vertical: h1p * 1.5,
        child: Text(
          txt,
          style: t500_14.copyWith(height: 1),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

class BookingCloseAlert extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String msg; // String type;
  // String? offlineTimeSlot;
  // String currentClinicAddress;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const BookingCloseAlert({
    super.key,
    // required this.w1p,
    // required this.h1p,
    required this.msg,
    // required this.experience,
    // required this.onlineTimeSlot,
    // required this.type,
    // required this.offlineTimeSlot,
    // required this.currentClinicAddress,
    // required this.bookOnlineOnClick,
    // required this.bookClinicOnClick,
  });

  @override
  Widget build(BuildContext context) {
    // String msg=msg;
    // String msg='Closing this page will interrupt your consultations';

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Message', style: TextStyles.textStyle3c),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),

              // verticalSpace(h1p),
              // Text(msg),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.toastBlue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: t500_16.copyWith(color: clr444444),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // gradient: linearGrad
            color: Colours.toastRed,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.proceed,
                style: t500_16,
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
