// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/other_patients_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/constants.dart';

import 'booking_screen_widgets.dart';

class PatientForm extends StatefulWidget {
  final double maxHeight;
  final double maxWidth;
  final String? relation;
  final String? appBarTitle;
  final bool? isUserIsPatient;
  final UserDetails user;
  // double ma
  const PatientForm({
    super.key,
    required this.maxHeight,
    this.relation,
    required this.user,
    required this.appBarTitle,
    this.isUserIsPatient,
    required this.maxWidth,
  });

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  var fnameC = TextEditingController();
  var lnameC = TextEditingController();
  var ageC = TextEditingController();
  var genderC = TextEditingController();
  var relationC = TextEditingController();

  var heightC = TextEditingController();
  var weightC = TextEditingController();
  var bGroupC = TextEditingController();

  var bSugarC = TextEditingController();
  var bpC = TextEditingController();
  var serumC = TextEditingController();

  @override
  void initState() {
    super.initState();

    fnameC.text = widget.user.firstName ?? "";
    lnameC.text = widget.user.lastName ?? "";
    ageC.text = widget.user.dateOfBirth ?? "";
    genderC.text = widget.user.gender ?? "";
    relationC.text = widget.relation != null
        ? widget.relation!
        : widget.user.relation ?? "";
    heightC.text = widget.user.height ?? "";
    weightC.text = widget.user.weight ?? "";
    bGroupC.text = widget.user.bloodGroup ?? "";
    bSugarC.text = widget.user.bloodSugar ?? "";
    bpC.text = widget.user.bloodPressure ?? "";
    serumC.text = widget.user.serumCreatinine ?? "";

    Future.delayed(Duration.zero, () async {
      getIt<BookingManager>().updateGnder(widget.user.gender ?? "");
      // getIt<BookingManager>().setMaritalStatus(widget.user.maritalStatus ?? "");
    });
  }

  @override
  void dispose() {
    super.dispose();
    getIt<BookingManager>().disposePatientForm();
  }

  unFocusFn() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  _showBottomSheet(BuildContext context) {
    // bGroupC.text = bloodGroups[index];
    final List<String> bloodGroups = [
      "A+",
      "A-",
      "B+",
      "B-",
      "AB+",
      "AB-",
      "O+",
      "O-",
    ];
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: bloodGroups.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colours.lightBlu,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                bloodGroups[index],
                style: t500_14.copyWith(color: clr444444),
              ),
            ),
            onTap: () {
              // Update selection
              Navigator.pop(
                context,
                bloodGroups[index],
              ); // Close the bottom sheet
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isExistingUser = widget.user.id != null;
    String selectedGender = Provider.of<BookingManager>(context).selectedGender;
    String errorMsg = Provider.of<StateManager>(context).validatonErrorTxt;
    // String files =  Provider.of<BookingManager>(context).selectedGnder;

    double maxHeight = widget.maxHeight;
    double maxWidth = widget.maxWidth;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    List<String> genders = ["Male", "Female", "Other"];
    return SafeArea(
      child: Consumer<BookingManager>(
        builder: (context, mgr, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: getIt<SmallWidgets>().appBarWidget(
              title: widget.appBarTitle ?? '',
              height: h10p * 0.9,
              width: w10p,
              fn: () {
                Navigator.pop(context);
              },
            ),
            // extendBody: true,
            // backgroundColor: Colors.r=tr,
            body: GestureDetector(
              onTap: () {
                unFocusFn();
              },
              child: SizedBox(
                // height: maxHeight,
                width: maxWidth,
                child: Stack(
                  children: [
                    pad(
                      horizontal: w1p * 4,
                      child: Form(
                        key: _formKey,
                        child: Entry(
                          yOffset: 100,
                          // scale: 20,
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                          child: ListView(
                            children: [
                              IgnorePointer(
                                ignoring: widget.user.id != null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // verticalSpace(h1p * 5),
                                    widget.user.id != null
                                        ? const SizedBox()
                                        : Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.allFieldsAreRequiredUnless,
                                            style: t400_14.copyWith(
                                              color: const Color(0xffa8a8a8),
                                            ),
                                          ),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.personalInfo,
                                      // style: TextStyles.textStyle41,
                                      style: t500_16.copyWith(
                                        color: isExistingUser
                                            ? Colors.grey
                                            : clr444444,
                                      ),
                                    ),
                                    horizontalSpace(w1p),

                                    verticalSpace(h1p * 2),

                                    SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        cntrolr: fnameC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.firstname,
                                        readOnly: isExistingUser,
                                        type: "char",
                                      ),
                                    ),
                                    verticalSpace(h1p * 1),
                                    SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        cntrolr: lnameC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.lastName,
                                        readOnly: isExistingUser,
                                        type: "char",
                                      ),
                                    ),
                                    verticalSpace(h1p * 1),
                                    SizedBox(
                                      height: h1p * 6,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        controller: ageC,
                                        style: t500_14.copyWith(
                                          color: isExistingUser == true
                                              ? Colors.grey.withOpacity(0.5)
                                              : const Color(0xFF1E1E1E),
                                        ),
                                        readOnly: true,
                                        decoration: inputDec4(
                                          isEmpty: ageC.text.isEmpty,
                                          hnt: AppLocalizations.of(
                                            context,
                                          )!.dateOfBirth,
                                        ),
                                        onTap: () async {
                                          if (!isExistingUser) {
                                            var tday = DateTime.now();
                                            DateTime?
                                            pickedDate = await showDatePicker(
                                              // barrierColor: Colors.transparent,
                                              context: context,
                                              initialDate: DateTime(
                                                tday.year - 10,
                                              ),
                                              firstDate: DateTime(
                                                tday.year - 120,
                                              ),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: tday,
                                            );

                                            if (pickedDate != null) {
                                              // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                              String formattedDate = DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(pickedDate);
                                              // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                              setState(() {
                                                ageC.text =
                                                    formattedDate; //set output date to TextField value.
                                              });
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                            } else {}
                                          }
                                        },
                                      ),
                                    ),
                                    verticalSpace(h1p * 2),
                                    SizedBox(
                                      height: h1p * 6,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: genders.map((e) {
                                          // var i = cnts.indexOf(e);
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                getIt<BookingManager>()
                                                    .updateGnder(e);
                                              },
                                              child: GenderBox(
                                                h1p: h1p,
                                                w1p: w1p,
                                                selected: e == selectedGender,
                                                txt: e,
                                                isReadOnly: isExistingUser,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    verticalSpace(h1p * 2),

                                    Row(
                                      children: [
                                        Visibility(
                                          visible:
                                              widget.isUserIsPatient != true,
                                          child: Expanded(
                                            child: SizedBox(
                                              height: h1p * 6,
                                              child: AddPersonTextField(
                                                type: "char",
                                                cntrolr: relationC,
                                                hnt: AppLocalizations.of(
                                                  context,
                                                )!.relationWithPatient,
                                                readOnly:
                                                    isExistingUser ||
                                                    widget.relation != null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpace(h1p * 2),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.medicalInfo,
                                        style: t500_16.copyWith(
                                          color: clr444444,
                                        ),
                                      ),
                                      horizontalSpace(w1p),
                                      Text(
                                        AppLocalizations.of(context)!.optional,
                                        style: t400_14.copyWith(
                                          color: clr444444,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //
                                  //     child: Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                              verticalSpace(h1p * 1),

                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        type: "height",
                                        cntrolr: heightC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.height,
                                        isNumber: true,
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(w1p * 2),
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        type: "weight",
                                        cntrolr: weightC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.weight,
                                        isNumber: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(h1p * 1),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        type: "char",
                                        readOnly: true,
                                        ontap: () async {
                                          // print("dfsfds");

                                          var res = await showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _showBottomSheet(context);
                                            },
                                          );

                                          if (res != null) {
                                            bGroupC.text = res;
                                          }
                                        },
                                        cntrolr: bGroupC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.bloodGroup2,
                                        isNumber: true,
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(w1p * 2),
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        type: "double",
                                        cntrolr: bSugarC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.bloodSugar,
                                        isNumber: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(h1p * 1),

                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        cntrolr: bpC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.bloodPressure,
                                        type: "bloodPressure",
                                        isNumber: false,
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(w1p * 2),
                                  Expanded(
                                    child: SizedBox(
                                      height: h1p * 6,
                                      child: AddPersonTextField(
                                        type: "double",
                                        cntrolr: serumC,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.serumCreatinine,
                                        isNumber: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // horizontalSpace(w1p*2),
                              // verticalSpace(h1p * 2),

                              // Row(
                              //   children: [
                              //     Text(
                              //       AppLocalizations.of(context)!.medicalRecords,
                              //       style: t500_16.copyWith(color: clr444444),
                              //     ),
                              //     horizontalSpace(w1p),
                              //     Text(
                              //       AppLocalizations.of(context)!.optional,
                              //       style: t400_14.copyWith(color: const Color(0xffa8a8a8)),
                              //     ),
                              //   ],
                              // ),
                              // verticalSpace(h1p * 1),

                              // Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(13),
                              //     color: Colours.lightBlu,
                              //   ),
                              //   child: pad(
                              //       vertical: h1p * 3,
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             AppLocalizations.of(context)!.uploadFile,
                              //             style: t700_16.copyWith(color: const Color(0xff3d41ad)),
                              //           ),
                              //           Text(
                              //             AppLocalizations.of(context)!.medicalRecordsDiagnosisReport,
                              //             style: t400_10.copyWith(color: const Color(0xff545454)),
                              //           ),
                              //           verticalSpace(h1p * 1),
                              //           mgr.medicReportFilesPaths.isEmpty
                              //               ? Padding(
                              //                   padding: EdgeInsets.all(w1p),
                              //                   child: SizedBox(width: w10p * 1.5, height: w10p * 1.5, child: Image.asset("assets/images/uploadicon.png")),
                              //                 )
                              //               : Padding(
                              //                   padding: EdgeInsets.all(w1p),
                              //                   child: Wrap(
                              //                       children: mgr.medicReportFilesPaths
                              //                           .map((e) => InkWell(
                              //                                 onTap: () {
                              //                                   // print(e);
                              //                                   var d = e.split(('/'));
                              //                                   // print(d.last);
                              //                                   showModalBottomSheet(
                              //                                       context: context,
                              //                                       builder: (context) {
                              //                                         return Container(
                              //                                           height: h10p * 2,
                              //                                           color: Colors.white,
                              //                                           child: pad(
                              //                                             vertical: h1p * 2,
                              //                                             horizontal: w1p * 4,
                              //                                             child: Column(
                              //                                               crossAxisAlignment: CrossAxisAlignment.center,
                              //                                               children: [
                              //                                                 Row(
                              //                                                   children: [
                              //                                                     SizedBox(
                              //                                                       height: w10p * 1.5,
                              //                                                       // width: h1p*3,
                              //                                                       // color: Colors.redAccent,
                              //                                                       child: Image.asset("assets/images/fileicon.png"),
                              //                                                     ),
                              //                                                     horizontalSpace(w1p),
                              //                                                     Expanded(child: Text(d.last, style: t500_12.copyWith(color: const Color(0xff707070))))
                              //                                                   ],
                              //                                                 ),
                              //                                                 verticalSpace(h1p),
                              //                                                 Row(
                              //                                                   children: [
                              //                                                     Expanded(
                              //                                                         child: InkWell(
                              //                                                       onTap: () {
                              //                                                         Navigator.pop(context);
                              //                                                       },
                              //                                                       child: Container(
                              //                                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                              //                                                         height: h10p * 0.5,
                              //                                                         child: Center(
                              //                                                           child: Text(
                              //                                                             AppLocalizations.of(context)!.cancel,
                              //                                                             style: t500_14.copyWith(color: clr444444),
                              //                                                           ),
                              //                                                         ),
                              //                                                       ),
                              //                                                     )),
                              //                                                     horizontalSpace(w1p),
                              //                                                     Expanded(
                              //                                                         child: InkWell(
                              //                                                       onTap: () {
                              //                                                         Navigator.pop(context);
                              //                                                         getIt<BookingManager>().deleteFile(e);
                              //                                                       },
                              //                                                       child: Container(
                              //                                                         decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              //                                                         height: h10p * 0.5,
                              //                                                         child: Center(
                              //                                                           child: Text(
                              //                                                             AppLocalizations.of(context)!.delete,
                              //                                                             style: t500_14.copyWith(height: 1),
                              //                                                           ),
                              //                                                         ),
                              //                                                       ),
                              //                                                     ))
                              //                                                   ],
                              //                                                 )
                              //                                               ],
                              //                                             ),
                              //                                           ),
                              //                                         );
                              //                                       });
                              //                                 },
                              //                                 child: SizedBox(
                              //                                   height: w10p * 1.5,
                              //                                   // width: h1p*3,
                              //                                   // color: Colors.redAccent,
                              //                                   child: Image.asset("assets/images/fileicon.png"),
                              //                                 ),
                              //                               ))
                              //                           .toList()),
                              //                 ),
                              //           verticalSpace(h1p * 1),
                              //           InkWell(
                              //             highlightColor: Colors.transparent,
                              //             splashColor: Colors.transparent,
                              //             onTap: () async {
                              //               FilePickerResult? result = await FilePicker.platform.pickFiles(
                              //                 allowMultiple: true,
                              //                 // allowedExtensions: ['jpg', 'pdf', 'doc'],
                              //               );
                              //               if (result != null) {
                              //                 List<String> paths = result.paths.map((path) => path!).toList();
                              //                 getIt<BookingManager>().addFiles(paths);
                              //               } else {
                              //                 // User canceled the picker
                              //               }
                              //             },
                              //             child: Container(
                              //                 decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(containerRadius),
                              //                     border: Border.all(
                              //                       color: const Color(0xff888888),
                              //                     )),
                              //                 child: pad(
                              //                     horizontal: w1p * 6,
                              //                     vertical: h1p,
                              //                     child: Text(
                              //                       "Browse",
                              //                       style: t500_14.copyWith(color: const Color(0xff313131)),
                              //                     ))),
                              //           ),
                              //         ],
                              //       )),
                              // ),
                              verticalSpace(h1p * 6),

                              pad(
                                horizontal: w1p * 2,
                                vertical: h1p,
                                child: ButtonWidget(
                                  btnText: AppLocalizations.of(context)!.submit,
                                  isLoading: mgr.bookingScreenLoader,
                                  ontap: () async {
                                    final isValid = _formKey.currentState!
                                        .validate();

                                    if (isValid) {
                                      var result = await getIt<BookingManager>()
                                          .addNewPatient(
                                            isUserIsPatient:
                                                widget.isUserIsPatient == true,
                                            userId: widget.user.id,
                                            firstName: fnameC.text,
                                            lastName: lnameC.text,
                                            dob: ageC.text,
                                            gender: selectedGender,
                                            relation: relationC.text,
                                            height: heightC.text,
                                            weight: weightC.text,
                                            bGroup: bGroupC.text,
                                            bSugar: bSugarC.text,
                                            bPressure: bpC.text,
                                            serumCre: serumC.text,
                                            files: mgr.medicReportFilesPaths,
                                          );
                                      if (result!.status == true) {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          SuccessToast(
                                            message: result.message ?? "",
                                          ),
                                        );
                                        Navigator.pop(context, result.userId);
                                      } else {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          ErrorToast(
                                            maxLines: 4,
                                            message: result.message ?? "",
                                          ),
                                        );
                                      }
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        ErrorToast(message: errorMsg),
                                      );
                                    }
                                  },
                                ),
                              ),
                              verticalSpace(h1p * 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    myLoader(
                      width: maxWidth,
                      height: maxHeight,
                      visibility: mgr.bookingScreenLoader,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
