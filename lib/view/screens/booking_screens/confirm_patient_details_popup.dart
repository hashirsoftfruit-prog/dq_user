// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/psychology_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/booking_request_data_model.dart';
import 'package:dqapp/view/screens/booking_screens/apply_coupons_screen.dart';
import 'package:dqapp/view/screens/booking_screens/booking_success_screen.dart';
import 'package:dqapp/view/screens/booking_screens/patient_details_form_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../model/core/available_doctors_response_model.dart';
import '../../../model/core/booking_validation_models.dart';
import '../../../model/core/coupons_model.dart';
import '../../../model/core/other_patients_response_model.dart';
import '../../../model/core/package_list_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../home_screen.dart';
import 'booking_screen_widgets.dart';
import 'questionare_screen.dart';

class ConfirmPatientDetails extends StatefulWidget {
  final double maxHeight;
  final double maxWidth;
  final UserDetails userData;
  // BillResponseModel currentBill;
  final BookingDetailsItem? dataForInstantBooking;
  final SaveScheduledBookingModel? dataForScheduledBooking;
  final PsychologyInstantBookingData? dataForPsychologyInstantBooking;
  final bool isScheduledBooking;
  // bool isPsychologyChoosed ;

  // double ma
  const ConfirmPatientDetails({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.userData,
    // required this.currentBill,
    required this.dataForInstantBooking,
    required this.dataForScheduledBooking,
    required this.dataForPsychologyInstantBooking,
    required this.isScheduledBooking,
    // required this.isPsychologyChoosed
  });

  @override
  State<ConfirmPatientDetails> createState() => _ConfirmPatientDetailsState();
}

class _ConfirmPatientDetailsState extends State<ConfirmPatientDetails> {
  bool agreeTerms = true;

  @override
  void dispose() {
    // getIt<BookingManager>().disposeBillScreen();
    super.dispose();
  }

  // @override
  // void initState() {
  //   getIt<BookingManager>().getBillDetails(
  //     isSeniorCitizenConsultation: widget.isScheduledBooking
  //         ? widget.dataForScheduledBooking?.seniorCitizenFreeConsultation
  //         : widget.dataForInstantBooking?.seniorCitizenFreeConsultation,
  //     packageDetails: widget.isScheduledBooking
  //         ? widget.dataForScheduledBooking!.packageDetails
  //         : widget.dataForInstantBooking!.packageDetails,
  //     spID: widget.isScheduledBooking == true
  //         ? widget.dataForScheduledBooking!.specialityId!
  //         : widget.dataForInstantBooking!.specialityId!,
  //     type: widget.isScheduledBooking == true ? 1 : 2,
  //     doctorId: widget.isScheduledBooking
  //         ? widget.dataForScheduledBooking!.doctorId
  //         : null,
  //     subSpecialityID: widget.isScheduledBooking
  //         ? null
  //         : widget.dataForInstantBooking != null
  //         ? null
  //         : widget.dataForPsychologyInstantBooking!.subSpecialityId!,
  //   );
  //   super.initState();
  // }

  // Future<void> _saveAndNavigate(
  //   int tempBookingId,
  //   Future<BookingSaveResponseModel> Function(int tempBookingId) saveBooking,
  //   bool isFree,
  // ) async {
  //   final currentContext =
  //       getIt<NavigationService>().navigatorkey.currentContext!;
  //   final saveResult = await saveBooking(tempBookingId);
  //   log("message is from save and navigate ${saveResult.status!}");
  //   final overlay = Overlay.of(currentContext);
  //   log("message is from save and navigate overlay is mouted ${overlay.mounted}");
  //   if (saveResult.status!) {
  //     // showTopSnackBar(
  //     //   Overlay.of(currentContext),
  //     //   ErrorToast(message: saveResult.message ?? "Save failed"),
  //     // );

  //     showTopSnackBar(
  //       overlay,
  //       ErrorToast(message: saveResult.message ?? "Save failed"),
  //     );
  //     return;
  //   }

  //   final bres =
  //       await getIt<NavigationService>().navigatorkey.currentState!.push(
  //             MaterialPageRoute(
  //               builder: (_) => BookingSuccessScreen(
  //                 bookingSuccessData: saveResult,
  //                 isFree: isFree,
  //               ),
  //             ),
  //           );

  //   if (bres != null) {
  //     Navigator.popUntil(currentContext, (route) => route.isFirst);
  //     Navigator.push(
  //       currentContext,
  //       MaterialPageRoute(
  //         builder: (_) => QuestionnaireScreen(
  //           bookingId: saveResult.bookingId!,
  //           appoinmentId: saveResult.appointmentId!,
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<void> _saveAndNavigate(
    int tempBookingId,
    Future<BookingSaveResponseModel> Function(int tempBookingId) saveBooking,
    bool isFree,
    String orderId,
  ) async {
    final navigatorKey = getIt<NavigationService>().navigatorkey;
    final navState = navigatorKey.currentState; // may be null
    final currentContext = navigatorKey.currentContext; // may be null

    try {
      final saveResult = await saveBooking(tempBookingId);
      log(
        "message is from save and navigate ${saveResult.status} msg:${saveResult.message}",
      );

      // safely get overlay from navigatorState (preferred) or from currentContext
      final overlay =
          navState?.overlay ??
          (currentContext == null ? null : Overlay.of(currentContext));

      // If save failed -> show error using overlay if present, else fallback to ScaffoldMessenger
      if (!saveResult.status!) {
        if (overlay != null && saveResult.message != "") {
          // ensure we show after current frame so overlay is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTopSnackBar(
              overlay,
              ErrorToast(message: saveResult.message ?? "Save failed"),
            );
          });
        } else {
          log(
            "message is No overlay available. Trying ScaffoldMessenger fallback.",
          );
          if (currentContext != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(content: Text(saveResult.message ?? "Save failed")),
              );
            });
          } else {
            log("message is No context available to show snackbar.");
          }
        }
        return;
      }

      // Success -> navigate using navigatorKey.currentState if possible
      if (navState == null) {
        log(
          "message is NavigatorState is null, cannot push BookingSuccessScreen.",
        );
        return;
      }
      final bres = await navState.push<dynamic>(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(
            bookingSuccessData: saveResult,
            isFree: isFree,
          ),
        ),
      );
      log("message is $bres");
      if (bres != null &&
          (widget.dataForInstantBooking != null ||
              widget.dataForPsychologyInstantBooking != null)) {
        // use navState (root navigator) to replace stack

        //change saveBookingCalled to false
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getIt<BookingManager>().setSaveBookingCalled(false);
        });

        navState.popUntil((route) => route.isFirst);
        navState.push(
          MaterialPageRoute(
            builder: (_) => QuestionnaireScreen(
              bookingId: saveResult.bookingId!,
              appoinmentId: saveResult.appointmentId!,
            ),
          ),
        );
      } else if (bres != null &&
          (widget.dataForScheduledBooking != null ||
              widget.dataForPsychologyInstantBooking != null)) {
        navState.popUntil((route) => route.isFirst);
        navState.push(MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e, st) {
      log("Exception in _saveAndNavigate: $e\n$st");
      // Optionally show a fallback toast/snackbar so you know an exception happened
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text("Unexpected error: ${e.toString()}")),
          );
        });
      }
    }
  }

  Future<void> _handleBookingFlow<T>({
    required Future<BookingValidationResponseData> Function() validateBooking,
    required Future<BookingSaveResponseModel> Function(int tempBookingId)
    saveBooking,
    required bool isFree,
    // required
  }) async {
    final saveBookingCalled = getIt<BookingManager>().saveBookingCalled;
    final validationResult = await validateBooking();

    if (validationResult.status != true && validationResult.message != "") {
      final navigatorKey = getIt<NavigationService>().navigatorkey;
      final navState = navigatorKey.currentState; // may be null
      final currentContext = navigatorKey.currentContext; // may be null
      final overlay =
          navState?.overlay ??
          (currentContext == null ? null : Overlay.of(currentContext));
      showTopSnackBar(
        overlay!,
        ErrorToast(message: validationResult.message ?? "Validation failed"),
      );
      return;
    }

    if (!isFree && validationResult.sdkPayload != null) {
      // --- Trigger payment and exit. Rest will be handled via Consumer
      getIt<BookingManager>().initiatePayment(
        validationResult.sdkPayload,
        tempBookingId: validationResult.temperoryBookingId!,
        saveBooking: saveBooking,
        isFree: isFree,
      );
      return;
    }

    if (!isFree && validationResult.sdkPayload == null) {
      showTopSnackBar(
        Overlay.of(context),
        const ErrorToast(message: "Something went wrong. Please try again"),
      );
      return;
    }

    if (!saveBookingCalled) {
      if (validationResult.sdkPayload != null) {
        await _saveAndNavigate(
          validationResult.temperoryBookingId!,
          saveBooking,
          isFree,
          validationResult.sdkPayload["payload"]["orderId"].toString(),
        );
      } else {
        // Free booking → save immediately
        await _saveAndNavigate(
          validationResult.temperoryBookingId!,
          saveBooking,
          isFree,
          "",
        );
      }
    } else {
      log("message already called");
    }
  }

  @override
  Widget build(BuildContext context) {
    double h1p = widget.maxHeight * 0.01;
    double h10p = widget.maxHeight * 0.1;
    double w10p = widget.maxWidth * 0.1;
    double w1p = widget.maxWidth * 0.01;

    int specialityId = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.specialityId!
        : widget.dataForInstantBooking != null
        ? widget.dataForInstantBooking!.specialityId!
        : widget.dataForPsychologyInstantBooking!.specialityId!;
    int? subSpecialityId = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.subSpecialityIdForPsychology
        : widget.dataForInstantBooking != null
        ? widget.dataForInstantBooking!.subSpecialityId
        : widget.dataForPsychologyInstantBooking!.subSpecialityId!;
    int? bookingType = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.bookingType
        : null; //1-scheduledOnline,2-Scheduled Offline,null-instantCall
    int bookingTypeForApplyCoupon =
        widget.dataForScheduledBooking?.bookingType == 2
        ? 2
        : 1; //1-online,2-offline
    SelectedPackageDetails? pkgChoosen = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.packageDetails
        : widget.dataForInstantBooking != null
        ? widget.dataForInstantBooking!.packageDetails
        : widget
              .dataForPsychologyInstantBooking!
              .packageDetails; //1-scheduledOnline,2-Scheduled Offline,null-instantCall
    int? doctorId = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.doctorId
        : widget
              .dataForPsychologyInstantBooking
              ?.doctorId; //1-scheduledOnline,2-Scheduled Offline,null-instantCall
    bool? isSeniorCitizen = widget.isScheduledBooking
        ? widget.dataForScheduledBooking!.seniorCitizenFreeConsultation
        : widget.dataForInstantBooking != null
        ? widget.dataForInstantBooking!.seniorCitizenFreeConsultation
        : widget.dataForPsychologyInstantBooking!.seniorCitizenFreeConsultation;
    int? consultationCategoryForInstatntCall = widget.isScheduledBooking
        ? null
        : widget.dataForInstantBooking?.selectedPriceCategory;
    dynamic docsData = widget.dataForPsychologyInstantBooking == null
        ? getIt<BookingManager>().docsData as BookingDataDetailsModel
        : getIt<PsychologyManager>().psychologyInstantDoctorsModel;

    var locale = AppLocalizations.of(context);

    Widget btn({required Widget child}) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: Colours.primaryblue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [pad(horizontal: w10p * 2, vertical: 8, child: child)],
        ),
      );
    }

    bool loader = Provider.of<BookingManager>(context).proceedLoader;
    UserDetails userDetails =
        Provider.of<BookingManager>(context).selectedPatientDetails ??
        UserDetails();

    applyCoupnFn(String code) async {
      var res = await getIt<BookingManager>().getBillDetails(
        spID: specialityId,
        doctorId: doctorId,
        type: bookingType,
        couponCode: code,
        packageDetails: pkgChoosen,
        isSeniorCitizenConsultation: isSeniorCitizen,
        subSpecialityID: subSpecialityId,
        consultationCategoryForInstantCall: consultationCategoryForInstatntCall,
        patientId: userDetails.appUserId,
      );

      if (res.status == true) {
        getIt<BookingManager>().setSelectedCoupon(
          Coupons(title: code, couponCode: code),
        );

        //Fluttertoast.showToast(msg: "Coupon Applied");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return CouponAppliedWidget(
              cCode: code,
              amtSaved: "0000",
              h1p: h1p,
              w1p: w1p,
              selected: false,
              txt: "",
            );
          },
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          ErrorToast(maxLines: 4, message: res.message ?? ""),
        );
      }

      // );

      //                                 showAdaptiveDialog(
      //                                   // backgroundColor: Colors.transparent,
      //                                   // isScrollControlled: true,useSafeArea: true,
      //                                   context: context,
      //                                   builder: (BuildContext context) {
      //                                     return CouponAppliedWidget(cCode:coupC.text ,amtSaved: result.couponDiscountValue??"",
      //                                         h1p: h1p,w1p: w1p,selected: false,txt: "dsf",
      // );
      //                                   },
      //                                 );
      //       }
      // else{
      //   showTopSnackBar(
      //     Overlay.of(context),
      //     ErrorToast(maxLines: 4,
      //       message:
      //       result.message??"",
      //     ),
      //   );
      // }
    }

    Widget dataColumn({
      required String? value,
      required String title,
      bool? stretch,
    }) {
      return value != null
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: t400_12.copyWith(color: clr606060)),
                  stretch == true ? const Spacer() : const SizedBox(),
                  const Text(" : "),
                  SizedBox(
                    width: stretch == true ? 50 : null,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value.length > 20
                            ? "${value.substring(0, 14)}...${value.substring(value.length - 5, value.length)}"
                            : value,
                        style: t500_12.copyWith(color: clr2D2D2D),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox();
    }

    return PopScope(
      canPop: false,

      // onPopInvokedWithResult: (d, v) async {
      //   getIt<BookingManager>().disposeBillScreen();
      //   if (Platform.isAndroid) {
      //     var backPressResult = await PaymentService.instance.hyperSDK
      //         .onBackPress();
      //     log("backpress status from instant $backPressResult");
      //     if (backPressResult.toLowerCase() == "true") {
      //       Navigator.of(context).pop();
      //     } else {
      //       // return true;
      //     }
      //   }
      // },
      child: Consumer<BookingManager>(
        builder: (context, mgr, child) {
          if (!mgr.isPaymentOnProcess && mgr.paymentMessage == "charged") {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (mgr.currentTempBookingId != null &&
                  mgr.currentSaveBookingCallback != null &&
                  !mgr.saveBookingCalled) {
                await _saveAndNavigate(
                  mgr.currentTempBookingId!,
                  mgr.currentSaveBookingCallback!,
                  mgr.isFree,
                  mgr.currentOrderId,
                );
                getIt<BookingManager>().resetPaymentState();
                // mgr.resetPaymentState();
              }
            });
          } else if (!mgr.isPaymentOnProcess && mgr.paymentMessage != "") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showTopSnackBar(
                Overlay.of(context),
                ErrorToast(message: mgr.paymentMessage),
              );
              getIt<BookingManager>().resetPaymentState();
            });
          }
          void addFilesWithValidation(
            BuildContext context,
            List<String> newFilePaths,
          ) {
            const int maxFiles = 5;
            const int maxSizeInBytes = 30 * 1024 * 1024;
            const allowedExtensions = [
              'jpg',
              'jpeg',
              'png',
              'pdf',
              'doc',
              'docx',
            ];

            List<File> validFiles = [];
            for (String path in newFilePaths) {
              final file = File(path);
              final ext = path.split('.').last.toLowerCase();
              if (file.existsSync() && allowedExtensions.contains(ext)) {
                validFiles.add(file);
              }
            }

            if (validFiles.length != newFilePaths.length) {
              showTopSnackBar(
                Overlay.of(context),
                const ErrorToast(
                  message: 'Only images, PDF, DOC, or DOCX files are allowed',
                ),
              );
              return;
            }

            int newFilesSize = validFiles.fold(
              0,
              (sum, file) => sum + file.lengthSync(),
            );

            int existingFileCount = mgr.medicReportFilesPaths.length;
            int existingFilesSize = mgr.medicReportFilesPaths.fold<int>(0, (
              sum,
              path,
            ) {
              final file = File(path);
              return sum + (file.existsSync() ? file.lengthSync() : 0);
            });

            int totalCount = existingFileCount + validFiles.length;
            int totalSize = existingFilesSize + newFilesSize;

            if (totalCount > maxFiles) {
              showTopSnackBar(
                Overlay.of(context),
                const ErrorToast(message: 'You can upload only 5 files'),
              );
            } else if (totalSize > maxSizeInBytes) {
              showTopSnackBar(
                Overlay.of(context),
                const ErrorToast(
                  message: 'Total file size should not exceed 30MB',
                ),
              );
            } else {
              mgr.addFiles(validFiles.map((f) => f.path).toList());
            }
          }

          imageBottomSheet(context) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext bc) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: clrFFFFFF,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Choose Source',
                          style: TextStyle(fontSize: 20, fontFamily: 'pr'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.5, 0.5],
                                colors: [Colors.purple, Colors.purple.shade400],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                Icons.image_outlined,
                                color: clrFFFFFF,
                              ),
                            ),
                          ),
                          title: const Text(
                            'Files',
                            style: TextStyle(fontFamily: 'pr'),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'jpg',
                                    'jpeg',
                                    'png',
                                    'pdf',
                                    'doc',
                                    'docx',
                                  ],
                                );
                            if (result != null) {
                              List<String> paths = result.files
                                  .where((file) => file.path != null)
                                  .map((file) => file.path!)
                                  .toList();
                              addFilesWithValidation(context, paths);
                            }
                          },

                          // onTap: () async {
                          //   Navigator.pop(context);
                          //   FilePickerResult? result = await FilePicker.platform.pickFiles(
                          //     allowMultiple: true,
                          //   );
                          //   if (result != null) {
                          //     // Get selected files (non-null paths)
                          //     List<PlatformFile> files = result.files.where((file) => file.path != null).toList();
                          //     // Calculate total size in bytes of selected files
                          //     int selectedFilesTotalSize = files.fold(0, (sum, file) => sum + (file.size));
                          //     // Combine with existing files (if you also want to check those)
                          //     int existingFilesSize = mgr.selectedMedicRecordsPaths.fold<int>(0, (sum, path) {
                          //       final file = File(path);
                          //       return sum + (file.existsSync() ? file.lengthSync() : 0);
                          //     });
                          //     int totalSize = existingFilesSize + selectedFilesTotalSize;
                          //     // Size limit in bytes (30MB)
                          //     const int maxSizeInBytes = 30 * 1024 * 1024;
                          //     if (mgr.selectedMedicRecordsPaths.length + files.length > 5) {
                          //       showTopSnackBar(
                          //         Overlay.of(context),
                          //         const ErrorToast(message: 'You can upload only 5 files'),
                          //         // ErrorToast(message: locale!.youCanUploadOnly5Files),
                          //       );
                          //     } else if (totalSize > maxSizeInBytes) {
                          //       showTopSnackBar(
                          //         Overlay.of(context),
                          //         const ErrorToast(message: 'Total file size should not exceed 30MB'),
                          //       );
                          //     } else {
                          //       // Extract paths and add files
                          //       List<String> paths = files.map((file) => file.path!).toList();
                          //       mgr.addFiles(paths);
                          //     }
                          //   }
                          // }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.5, 0.5],
                                colors: [Colors.pink, Colors.pink.shade400],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: clrFFFFFF,
                              ),
                            ),
                          ),
                          title: const Text(
                            'Camera',
                            style: TextStyle(fontFamily: 'pr'),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            final XFile? result = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                              imageQuality: 60,
                            );
                            if (result != null) {
                              addFilesWithValidation(context, [result.path]);
                            }
                          },

                          // onTap: () async {
                          //   Navigator.pop(context);
                          //   final XFile? result = await ImagePicker().pickImage(
                          //     source: ImageSource.camera,
                          //     imageQuality: 60,
                          //   );
                          //   if (result != null) {
                          //     String path = result.path;
                          //     mgr.addFiles([path]);
                          //   }
                          //   // avatarCamera(context);
                          // },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // initiatePayment(paymentUrl) async {
          //   String? result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => HdfcPaymentScreen(
          //                 paymentUrl: paymentUrl,
          //               )));
          //   if (result == "success") {
          //     return result;
          //   } else {
          //     showTopSnackBar(
          //         Overlay.of(context),
          //         const ErrorToast(
          //           maxLines: 4,
          //           message: "Payment failed",
          //         ));
          //     return null;
          //   }
          // }

          Future<void> confirmBooking() async {
            final isFree =
                docsData?.packageAvailability == true ||
                mgr.billModel?.amountAfterDiscount == "0" ||
                mgr.billModel?.amountAfterDiscount == "0.0";

            if (agreeTerms == false) {
              showTopSnackBar(
                Overlay.of(context),
                ErrorToast(message: locale!.youMustAgreeTermsAndConditions),
              );
              return;
            }

            getIt<BookingManager>().setProceedLoader(true);

            if (mgr.medicReportFilesPaths.isNotEmpty) {
              final result = await getIt<BookingManager>().addNewPatient(
                isUserIsPatient:
                    userDetails.userId ==
                    getIt<SharedPreferences>().getInt(StringConstants.userId),
                userId: userDetails.id ?? 0,
                firstName: userDetails.firstName ?? "",
                lastName: userDetails.lastName ?? "",
                dob: userDetails.dateOfBirth ?? "",
                gender: userDetails.gender ?? "",
                relation: userDetails.relation ?? "",
                height: userDetails.height ?? "",
                weight: userDetails.weight ?? "",
                bGroup: userDetails.bloodGroup ?? "",
                bSugar: userDetails.bloodSugar ?? "",
                bPressure: userDetails.bloodPressure ?? "",
                serumCre: userDetails.serumCreatinine ?? "",
                files: mgr.medicReportFilesPaths,
              );
              if (result?.status != true) {
                showTopSnackBar(
                  Overlay.of(context),
                  ErrorToast(message: result?.message ?? "File upload failed"),
                );
                getIt<BookingManager>().setProceedLoader(false);
                return;
              }
            }

            if (widget.isScheduledBooking) {
              await _handleBookingFlow(
                validateBooking: () =>
                    getIt<BookingManager>().scheduledBookingValidation(
                      dt: widget.dataForScheduledBooking!,
                      bill: mgr.billModel!,
                    ),
                saveBooking: (tempId) =>
                    getIt<BookingManager>().scheduledBookingSave(
                      sd: widget.dataForScheduledBooking!,
                      bill: mgr.billModel!,
                      tempBookingID: tempId,
                      currentOrderID: mgr.currentOrderId,
                    ),
                isFree: isFree,
              );
            } else if (widget.dataForInstantBooking != null) {
              await _handleBookingFlow(
                validateBooking: () =>
                    getIt<BookingManager>().instantBookingValidation(
                      widget.dataForInstantBooking!,
                      mgr.billModel!,
                    ),
                saveBooking: (tempId) =>
                    getIt<BookingManager>().instantBookingSave(
                      item: widget.dataForInstantBooking!,
                      bill: mgr.billModel!,
                      tempBookingID: tempId,
                      currentOrderID: mgr.currentOrderId,
                    ),
                isFree: isFree,
              );
            } else if (widget.dataForPsychologyInstantBooking != null) {
              await _handleBookingFlow(
                validateBooking: () =>
                    getIt<BookingManager>().psychologyInstantBookingValidation(
                      dt: widget.dataForPsychologyInstantBooking!,
                      bill: mgr.billModel!,
                    ),
                saveBooking: (tempId) =>
                    getIt<BookingManager>().psychologyInstantBookingSave(
                      sd: widget.dataForPsychologyInstantBooking!,
                      bill: mgr.billModel!,
                      tempBookingID: tempId,
                      currentOrderID: mgr.currentOrderId,
                    ),
                isFree: isFree,
              );
            }
          }

          // confirmBooking() async {
          //   bool isFree = docsData?.packageAvailability == true ||
          //       mgr.billModel?.amountAfterDiscount == "0" ||
          //       mgr.billModel?.amountAfterDiscount == "0.0";
          //   if (agreeTerms == false) {
          //     showTopSnackBar(
          //         Overlay.of(context),
          //         SuccessToast(
          //             message: agreeTerms != true
          //                 ? locale!.youMustAgreeTermsAndConditions
          //                 : locale!.selectPatientToContinue));
          //     return;
          //   }
          //   getIt<BookingManager>().setProceedLoader(true);
          //   if (mgr.medicReportFilesPaths.isNotEmpty) {
          //     var result = await getIt<BookingManager>().addNewPatient(
          //       isUserIsPatient: userDetails.userId != null &&
          //           userDetails.userId ==
          //               getIt<SharedPreferences>().getInt(StringConstants.userId),
          //       userId: userDetails.id ?? 0,
          //       firstName: userDetails.firstName ?? "",
          //       lastName: userDetails.lastName ?? "",
          //       dob: userDetails.dateOfBirth ?? "",
          //       gender: userDetails.gender ?? "",
          //       relation: userDetails.relation ?? "",
          //       height: userDetails.height ?? "",
          //       weight: userDetails.weight ?? "",
          //       bGroup: userDetails.bloodGroup ?? "",
          //       bSugar: userDetails.bloodSugar ?? "",
          //       bPressure: userDetails.bloodPressure ?? "",
          //       serumCre: userDetails.serumCreatinine ?? "",
          //       files: mgr.medicReportFilesPaths,
          //     );
          //     if (result!.status == true) {
          //     } else {
          //       showTopSnackBar(
          //           Overlay.of(context),
          //           ErrorToast(
          //             maxLines: 4,
          //             message: result.message ?? "File upload failed",
          //           ));
          //       getIt<BookingManager>().setProceedLoader(false);
          //       return;
          //     }
          //   }
          //   if (widget.isScheduledBooking) {
          //     var scheduledBookValidationResult = await getIt<BookingManager>()
          //         .scheduledBookingValidation(
          //             dt: widget.dataForScheduledBooking!, bill: mgr.billModel!);

          //     if (scheduledBookValidationResult.status == true) {
          //       //create order of hdfc
          //       // await getIt<PaymentManager>().createOrderSession();
          //       if (scheduledBookValidationResult.paymentUrl != null && !isFree) {
          //         var paymentResult = await initiatePayment(
          //             scheduledBookValidationResult.paymentUrl);
          //         if (paymentResult == null) {
          //           return;
          //         }
          //       }

          //       // else if (!isFree &&
          //       //     scheduledBookValidationResult.paymentUrl == null) {
          //       //   showTopSnackBar(
          //       //       Overlay.of(context),
          //       //       const ErrorToast(
          //       //         maxLines: 4,
          //       //         message: "Something went wrong. Please try again",
          //       //       ));
          //       //   return;
          //       // }

          //       BookingSaveResponseModel scheduledBookSaveResult =
          //           await getIt<BookingManager>().scheduledBookingSave(
          //               sd: widget.dataForScheduledBooking!,
          //               bill: mgr.billModel!,
          //               tempBookingID:
          //                   scheduledBookValidationResult.temperoryBookingId!);
          //       if (scheduledBookSaveResult.status == true) {
          //         String? bres = await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => BookingSuccessScreen(
          //                       bookingSuccessData: scheduledBookSaveResult,
          //                       isFree: isFree,
          //                     )));

          //         if (bres != null) {
          //           Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(builder: (_) => const HomeScreen()),
          //             (ff) => false,
          //           );
          //         }
          //       } else {
          //         showTopSnackBar(
          //           Overlay.of(context),
          //           ErrorToast(
          //             maxLines: 4,
          //             message: scheduledBookSaveResult.message ?? "",
          //           ),
          //         );
          //       }
          //     } else {
          //       showTopSnackBar(
          //         Overlay.of(context),
          //         ErrorToast(
          //           maxLines: 4,
          //           message: scheduledBookValidationResult.message ?? "",
          //         ),
          //       );
          //     }
          //   } else if (widget.dataForInstantBooking != null) {
          //     var validationResult = await getIt<BookingManager>()
          //         .instantBookingValidation(
          //             widget.dataForInstantBooking!, mgr.billModel!);
          //     if (validationResult.status == true) {
          //       if (validationResult.sdkPayload != null && !isFree) {
          //         // var paymentResult = await initiateHDFCPayment(
          //         //     widget.dataForInstantBooking,
          //         //     validationResult,
          //         //     mgr.billModel);

          //         // var paymentResult =
          //         //     await initiatePayment(validationResult.paymentUrl);
          //         // if (paymentResult == null) {
          //         //   return;
          //         // }

          //         // getIt<BookingManager>()
          //         //     .initiatePayment(validationResult.sdkPayload);

          //         getIt<BookingManager>().initiatePayment(
          //           validationResult.sdkPayload,
          //           tempBookingId: validationResult.temperoryBookingId!,
          //           saveBooking: (tempId) =>
          //               getIt<BookingManager>().instantBookingSave(
          //             item: widget.dataForInstantBooking!,
          //             bill: mgr.billModel!, // bill is captured here
          //             tempBookingID: tempId,
          //           ),
          //           isFree: isFree,
          //         );
          //       } else if (!isFree && validationResult.paymentUrl == null) {
          //         showTopSnackBar(
          //             Overlay.of(context),
          //             const ErrorToast(
          //               maxLines: 4,
          //               message: "Something went wrong. Please try again",
          //             ));
          //       }

          //       if (!mgr.isPaymentOnProcess && mgr.paymentMessage == "charged") {
          //         log("message is booking save happening");
          //         BookingSaveResponseModel saveResult =
          //             await getIt<BookingManager>().instantBookingSave(
          //                 item: widget.dataForInstantBooking!,
          //                 bill: mgr.billModel!,
          //                 tempBookingID: validationResult.temperoryBookingId!);
          //         if (saveResult.status == true) {
          //           String? bres = await Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (_) => BookingSuccessScreen(
          //                         bookingSuccessData: saveResult,
          //                         isFree: isFree,
          //                       )));

          //           if (bres != null) {
          //             Navigator.pop(context);
          //             Navigator.pop(context);

          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (_) => QuestionnaireScreen(
          //                           bookingId: saveResult.bookingId!,
          //                           appoinmentId: saveResult.appointmentId!,
          //                         )));

          //             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
          //           }
          //         } else {
          //           showTopSnackBar(
          //             Overlay.of(context),
          //             ErrorToast(
          //               maxLines: 4,
          //               message: saveResult.message ?? "",
          //             ),
          //           );
          //         }
          //       } else if (mgr.paymentMessage != "") {
          //         showTopSnackBar(
          //           Overlay.of(context),
          //           ErrorToast(
          //             maxLines: 4,
          //             message: mgr.paymentMessage,
          //           ),
          //         );
          //       }
          //     } else {
          //       showTopSnackBar(
          //         Overlay.of(context),
          //         ErrorToast(
          //           maxLines: 4,
          //           message: validationResult.message ?? "",
          //         ),
          //       );
          //     }
          //   }
          //   // Handling psychology Instant booking
          //   else {
          //     var validationResult = await getIt<BookingManager>()
          //         .psychologyInstantBookingValidation(
          //             dt: widget.dataForPsychologyInstantBooking!,
          //             bill: mgr.billModel!);
          //     if (validationResult.status == true) {
          //       if (validationResult.paymentUrl != null && !isFree) {
          //         var paymentResult =
          //             await initiatePayment(validationResult.paymentUrl);
          //         if (paymentResult == null) {
          //           return;
          //         }
          //       } else if (!isFree && validationResult.paymentUrl == null) {
          //         showTopSnackBar(
          //             Overlay.of(context),
          //             const ErrorToast(
          //               maxLines: 4,
          //               message: "Something went wrong. Please try again",
          //             ));
          //       }
          //       BookingSaveResponseModel saveResult =
          //           await getIt<BookingManager>().psychologyInstantBookingSave(
          //               sd: widget.dataForPsychologyInstantBooking!,
          //               bill: mgr.billModel!,
          //               tempBookingID: validationResult.temperoryBookingId!);

          //       if (saveResult.status == true) {
          //         // Navigator.pop(context);

          //         String? bres = await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => BookingSuccessScreen(
          //                       bookingSuccessData: saveResult,
          //                       isFree: isFree,
          //                     )));

          //         if (bres != null) {
          //           Navigator.pop(context);
          //           Navigator.pop(context);

          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (_) => QuestionnaireScreen(
          //                         bookingId: saveResult.bookingId!,
          //                         appoinmentId: saveResult.appointmentId!,
          //                       )));

          //           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
          //         }
          //       } else {
          //         showTopSnackBar(
          //           Overlay.of(context),
          //           ErrorToast(
          //             maxLines: 4,
          //             message: saveResult.message ?? "",
          //           ),
          //         );
          //       }
          //     } else {
          //       showTopSnackBar(
          //         Overlay.of(context),
          //         ErrorToast(
          //           maxLines: 4,
          //           message: validationResult.message ?? "",
          //         ),
          //       );
          //     }
          //   }
          // }

          return SizedBox(
            width: widget.maxWidth,
            child: pad(
              // horizontal: w1p * 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient Details",
                    style: t400_16.copyWith(color: clr2D2D2D),
                  ),
                  verticalSpace(8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffECE6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // verticalSpace(h1p*5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  dataColumn(
                                    value:
                                        "${userDetails.firstName} ${userDetails.lastName}",
                                    title: AppLocalizations.of(
                                      context,
                                    )!.patientName,
                                  ),
                                ],
                              ),
                              // Divider() ,
                              verticalSpace(4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  dataColumn(
                                    value: userDetails.age ?? "-",
                                    title: AppLocalizations.of(context)!.age,
                                  ),
                                  horizontalSpace(2),
                                  dataColumn(
                                    value: userDetails.gender ?? "-",
                                    title: AppLocalizations.of(context)!.gender,
                                  ),
                                ],
                              ),
                              const Divider(),
                              Wrap(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  dataColumn(
                                    stretch: true,
                                    value: userDetails.height,
                                    title: AppLocalizations.of(context)!.height,
                                  ),
                                  dataColumn(
                                    stretch: true,
                                    value: userDetails.weight,
                                    title: AppLocalizations.of(context)!.weight,
                                  ),
                                  dataColumn(
                                    stretch: true,
                                    value: userDetails.bloodGroup,
                                    title: AppLocalizations.of(
                                      context,
                                    )!.bloodGroup2,
                                  ),
                                ],
                              ),
                              userDetails.bloodSugar != null ||
                                      userDetails.bloodPressure != null ||
                                      userDetails.serumCreatinine != null
                                  ? Wrap(
                                      direction: Axis.horizontal,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        dataColumn(
                                          stretch: true,
                                          value: userDetails.bloodSugar,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.bloodSugar2,
                                        ),
                                        dataColumn(
                                          stretch: true,
                                          value: userDetails.bloodPressure,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.bloodPressure2,
                                        ),
                                        dataColumn(
                                          stretch: true,
                                          value: userDetails.serumCreatinine,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.serumCreatinine2,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              // Divider(),
                            ],
                          ),
                        ),
                        loader
                            ? SizedBox(height: h1p)
                            : InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.blueGrey,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) => PatientForm(
                                      appBarTitle: AppLocalizations.of(
                                        context,
                                      )!.editMember,
                                      maxWidth: widget.maxWidth,
                                      maxHeight: widget.maxHeight,
                                      user: userDetails,
                                      isUserIsPatient:
                                          userDetails.userId != null &&
                                          userDetails.userId ==
                                              getIt<SharedPreferences>().getInt(
                                                StringConstants.userId,
                                              ),
                                    ),
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: clr2E3192,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/pencil-edit-icon-white.png",
                                          width: 13,
                                          height: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  verticalSpace(h1p * 0.5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.medicalRecords,
                        style: t500_16.copyWith(color: clr444444),
                      ),
                      horizontalSpace(w1p),
                      Text(
                        AppLocalizations.of(context)!.optional,
                        style: t400_14.copyWith(color: const Color(0xffa8a8a8)),
                      ),
                    ],
                  ),
                  verticalSpace(h1p * 1),
                  Container(
                    width: widget.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colours.lightBlu,
                    ),
                    child: pad(
                      vertical: h1p * 3,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.uploadFile,
                            style: t700_16.copyWith(
                              color: const Color(0xff3d41ad),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.medicalRecordsDiagnosisReport,
                            style: t400_10.copyWith(
                              color: const Color(0xff545454),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.maxCountAndFileSize,
                            style: t400_10.copyWith(color: Colors.grey),
                          ),
                          verticalSpace(h1p * 1),
                          mgr.medicReportFilesPaths.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(w1p),
                                  child: SizedBox(
                                    width: w10p * 1.5,
                                    height: w10p * 1.5,
                                    child: Image.asset(
                                      "assets/images/uploadicon.png",
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(w1p),
                                  child: Wrap(
                                    children: mgr.medicReportFilesPaths
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              // print(e);
                                              var d = e.split(('/'));
                                              // print(d.last);

                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height: h10p * 2,
                                                    color: Colors.white,
                                                    child: pad(
                                                      vertical: h1p * 2,
                                                      horizontal: w1p * 4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    w10p * 1.5,
                                                                child: Image.asset(
                                                                  "assets/images/fileicon.png",
                                                                ),
                                                              ),
                                                              horizontalSpace(
                                                                w1p,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  d.last,
                                                                  style: t500_12
                                                                      .copyWith(
                                                                        color: const Color(
                                                                          0xff707070,
                                                                        ),
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          verticalSpace(h1p),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    // Navigator.pop(context);

                                                                    showModalBottomSheet(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      isScrollControlled:
                                                                          true,
                                                                      showDragHandle:
                                                                          true,
                                                                      barrierColor:
                                                                          Colors
                                                                              .white,
                                                                      useSafeArea:
                                                                          true,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              0,
                                                                            ),
                                                                      ),
                                                                      // showDragHandle: true,
                                                                      context:
                                                                          context,
                                                                      builder: (context) => Center(
                                                                        child:
                                                                            d.last.endsWith(
                                                                                  ".png",
                                                                                ) ||
                                                                                d.last.endsWith(
                                                                                  ".jpg",
                                                                                ) ||
                                                                                d.last.endsWith(
                                                                                  ".jpeg",
                                                                                )
                                                                            ? Image(
                                                                                image: FileImage(
                                                                                  File(
                                                                                    e,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : PdfViewPinch(
                                                                                controller: PdfControllerPinch(
                                                                                  document: PdfDocument.openFile(
                                                                                    e,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                      border: Border.all(
                                                                        color: Colors
                                                                            .black26,
                                                                      ),
                                                                    ),
                                                                    height:
                                                                        h10p *
                                                                        0.5,
                                                                    child: Center(
                                                                      child: Text(
                                                                        'View',
                                                                        // AppLocalizations.of(context)!.cancel,
                                                                        style: t500_14.copyWith(
                                                                          color:
                                                                              clr444444,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              horizontalSpace(
                                                                w1p,
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    getIt<
                                                                          BookingManager
                                                                        >()
                                                                        .deleteFile(
                                                                          e,
                                                                        );
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                                    height:
                                                                        h10p *
                                                                        0.5,
                                                                    child: Center(
                                                                      child: Text(
                                                                        AppLocalizations.of(
                                                                          context,
                                                                        )!.delete,
                                                                        style: t500_14.copyWith(
                                                                          height:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black26)),
                                                  height: w10p * 1.5,
                                                  width: w10p * 1.5,
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: h1p * 0.5,
                                                  ),
                                                  // width: h1p*3,
                                                  // color: Colors.redAccent,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Image.file(
                                                      File(e),
                                                      fit: BoxFit.fill,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => Image.asset(
                                                            "assets/images/fileicon.png",
                                                          ),
                                                    ),
                                                  ),
                                                  // child: Image.asset("assets/images/fileicon.png"),
                                                ),
                                                SizedBox(
                                                  width: w10p * 1.4,
                                                  child: Text(
                                                    e.split(('/')).last,
                                                    style: t400_12.copyWith(
                                                      color: clr444444,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                          verticalSpace(h1p * 1),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              imageBottomSheet(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerRadius,
                                ),
                                border: Border.all(
                                  color: const Color(0xff888888),
                                ),
                              ),
                              child: pad(
                                horizontal: w1p * 6,
                                vertical: h1p,
                                child: Text(
                                  "Browse",
                                  style: t500_14.copyWith(
                                    color: const Color(0xff313131),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpace(8),
                  docsData?.packageAvailability != true &&
                          mgr.selectedPkg == null &&
                          (docsData?.isFreeDoctorAvailable == false ||
                              docsData?.seniorCitizen == false)
                      ? Column(
                          children: [
                            const Divider(color: Colours.lightBlu),
                            if (mgr.selectedCoupon != null)
                              SelectedCoupon(
                                w1p: w1p,
                                h1p: h1p,
                                title: mgr.selectedCoupon!.title ?? "",
                                subTitle: "Coupon Applied",
                                fn: () {
                                  getIt<BookingManager>().setSelectedCoupon(
                                    null,
                                  );
                                  getIt<BookingManager>().getBillDetails(
                                    spID: specialityId,
                                    doctorId: doctorId,
                                    type: bookingType,
                                    couponCode: null,
                                    packageDetails: pkgChoosen,
                                    isSeniorCitizenConsultation:
                                        isSeniorCitizen,
                                    consultationCategoryForInstantCall:
                                        consultationCategoryForInstatntCall,
                                    subSpecialityID: subSpecialityId,
                                    patientId: getIt<BookingManager>()
                                        .selectedPatientDetails!
                                        .appUserId,
                                  );
                                },
                              )
                            else
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  String? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ApplyCouponScreen(
                                        speciality: specialityId,
                                        typeofBooking:
                                            bookingTypeForApplyCoupon,
                                        subSpecialityID: subSpecialityId,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    applyCoupnFn(result);
                                  }
                                },
                                child: applyCouponButton(
                                  maxWidth: MediaQuery.of(context).size.width,
                                  text: locale!.applyCoupon,
                                ),
                              ),
                            const Divider(color: Colours.lightBlu),
                            verticalSpace(8),
                            verticalSpace(8),
                          ],
                        )
                      : const SizedBox(),
                  verticalSpace(h1p * 0.5),
                  (isSeniorCitizen!)
                      ? BillBox(
                          bill: mgr.billModel,
                          isLoading: mgr.billLoader,
                          isSeniorCitizen:
                              widget
                                  .dataForInstantBooking
                                  ?.seniorCitizenFreeConsultation ??
                              widget
                                  .dataForScheduledBooking
                                  ?.seniorCitizenFreeConsultation,
                          h1p: h1p,
                          w1p: w1p,
                        )
                      : (docsData?.packageAvailability == true)
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "This appointment is covered by your current package.",
                            style: t400_14.copyWith(color: Colors.black),
                          ),
                        )
                      : (mgr.billModel != null)
                      ? BillBox(
                          bill: mgr.billModel,
                          isLoading: mgr.billLoader,
                          isSeniorCitizen:
                              widget
                                  .dataForInstantBooking
                                  ?.seniorCitizenFreeConsultation ??
                              widget
                                  .dataForScheduledBooking
                                  ?.seniorCitizenFreeConsultation,
                          h1p: h1p,
                          w1p: w1p,
                        )
                      : const Center(child: LogoLoader()),
                  verticalSpace(16),
                  const RefundPolicy(),
                  verticalSpace(16),
                  TermsAndConditions(
                    onTap: () {
                      setState(() {
                        agreeTerms = !agreeTerms;
                      });
                    },
                    isAgreed: agreeTerms,
                  ),
                  pad(
                    vertical: h1p * 1,
                    // horizontal: w1p * 4,
                    child: loader
                        ? btn(
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            ),
                          )
                        : docsData?.packageAvailability == true ||
                              mgr.billModel?.amountAfterDiscount == "0" ||
                              mgr.billModel?.amountAfterDiscount == "0.0"
                        ? ButtonWidget(
                            btnText: AppLocalizations.of(context)!.proceed,
                            ontap: confirmBooking,
                          )
                        : mgr.billModel == null
                        ? const SizedBox()
                        : PayButton(
                            btnText: AppLocalizations.of(context)!.proceed,
                            amount: docsData?.packageAvailability == true
                                ? "0"
                                : mgr.billModel?.amountAfterDiscount ?? "0",
                            ontap: confirmBooking,
                            // ontap: () async {
                            //   if (agreeTerms == false) {
                            //     showTopSnackBar(Overlay.of(context), SuccessToast(message: agreeTerms != true ? locale!.youMustAgreeTermsAndConditions : locale!.selectPatientToContinue));
                            //     return;
                            //   }
                            //   if (widget.isScheduledBooking) {
                            //     var scheduledBookValidationResult = await getIt<BookingManager>().scheduledBookingValidation(dt: widget.dataForScheduledBooking!, bill: mgr.billModel!);
                            //     if (scheduledBookValidationResult.status == true) {
                            //       BookingSaveResponseModel scheduledBookSaveResult = await getIt<BookingManager>().scheduledBookingSave(sd: widget.dataForScheduledBooking!, bill: mgr.billModel!, tempBookingID: scheduledBookValidationResult.temperoryBookingId!);
                            //       if (scheduledBookSaveResult.status == true) {
                            //         // showTopSnackBar(
                            //         //   Overlay.of(context),
                            //         //   SuccessToast(
                            //         //     message:
                            //         //     ScheduledBookSaveResult.message??"",
                            //         //   ),
                            //         // );
                            //         String? bres = await Navigator.push(context, MaterialPageRoute(builder: (_) => BookingSuccessScreen(bookingSuccessData: scheduledBookSaveResult)));
                            //         if (bres != null) {
                            //           Navigator.pushAndRemoveUntil(
                            //             context,
                            //             MaterialPageRoute(builder: (_) => const HomeScreen()),
                            //             (ff) => false,
                            //           );
                            //         }
                            //       } else {
                            //         showTopSnackBar(
                            //           Overlay.of(context),
                            //           ErrorToast(
                            //             maxLines: 4,
                            //             message: scheduledBookSaveResult.message ?? "",
                            //           ),
                            //         );
                            //       }
                            //     } else {
                            //       showTopSnackBar(
                            //         Overlay.of(context),
                            //         ErrorToast(
                            //           maxLines: 4,
                            //           message: scheduledBookValidationResult.message ?? "",
                            //         ),
                            //       );
                            //     }
                            //   } else if (widget.dataForInstantBooking != null) {
                            //     var validationResult = await getIt<BookingManager>().instantBookingValidation(widget.dataForInstantBooking!, mgr.billModel!);
                            //     if (validationResult.status == true) {
                            //       BookingSaveResponseModel saveResult = await getIt<BookingManager>().instantBookingSave(item: widget.dataForInstantBooking!, bill: mgr.billModel!, tempBookingID: validationResult.temperoryBookingId!);
                            //       if (saveResult.status == true) {
                            //         // Navigator.pop(context);
                            //         String? bres = await Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (_) => BookingSuccessScreen(
                            //                       bookingSuccessData: saveResult,
                            //                     )));
                            //         if (bres != null) {
                            //           Navigator.pop(context);
                            //           Navigator.pop(context);
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (_) => QuestionnaireScreen(
                            //                         bookingId: saveResult.bookingId!,
                            //                         appoinmentId: saveResult.appointmentId!,
                            //                       )));
                            //           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
                            //         }
                            //       } else {
                            //         showTopSnackBar(
                            //           Overlay.of(context),
                            //           ErrorToast(
                            //             maxLines: 4,
                            //             message: saveResult.message ?? "",
                            //           ),
                            //         );
                            //       }
                            //     } else {
                            //       showTopSnackBar(
                            //         Overlay.of(context),
                            //         ErrorToast(
                            //           maxLines: 4,
                            //           message: validationResult.message ?? "",
                            //         ),
                            //       );
                            //     }
                            //   }
                            //   // Handling psychology Instant booking
                            //   else {
                            //     var validationResult = await getIt<BookingManager>().psychologyInstantBookingValidation(dt: widget.dataForPsychologyInstantBooking!, bill: mgr.billModel!);
                            //     if (validationResult.status == true) {
                            //       BookingSaveResponseModel saveResult = await getIt<BookingManager>().psychologyInstantBookingSave(sd: widget.dataForPsychologyInstantBooking!, bill: mgr.billModel!, tempBookingID: validationResult.temperoryBookingId!);
                            //       if (saveResult.status == true) {
                            //         // Navigator.pop(context);
                            //         String? bres = await Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (_) => BookingSuccessScreen(
                            //                       bookingSuccessData: saveResult,
                            //                     )));
                            //         if (bres != null) {
                            //           Navigator.pop(context);
                            //           Navigator.pop(context);
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (_) => QuestionnaireScreen(
                            //                         bookingId: saveResult.bookingId!,
                            //                         appoinmentId: saveResult.appointmentId!,
                            //                       )));
                            //           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
                            //         }
                            //       } else {
                            //         showTopSnackBar(
                            //           Overlay.of(context),
                            //           ErrorToast(
                            //             maxLines: 4,
                            //             message: saveResult.message ?? "",
                            //           ),
                            //         );
                            //       }
                            //     } else {
                            //       showTopSnackBar(
                            //         Overlay.of(context),
                            //         ErrorToast(
                            //           maxLines: 4,
                            //           message: validationResult.message ?? "",
                            //         ),
                            //       );
                            //     }
                            //   }
                            // },
                          ),
                  ),
                ],
              ),
            ),

            // floatingActionButton: pad(
            //   vertical: h1p * 1,
            //   horizontal: w1p * 4,
            //   child: loader
            //       ? btn(child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1)))
            //       : PayButton(
            //           btnText: AppLocalizations.of(context)!.proceed,
            //           amount: docsData?.packageAvailability == true ? "0" : mgr.billModel!.amountAfterDiscount!,
            //           ontap: () async {
            //             if (widget.isScheduledBooking) {
            //               var scheduledBookValidationResult = await getIt<BookingManager>().scheduledBookingValidation(dt: widget.dataForScheduledBooking!, bill: mgr.billModel!);
            //               if (scheduledBookValidationResult.status == true) {
            //                 BookingSaveResponseModel scheduledBookSaveResult = await getIt<BookingManager>().scheduledBookingSave(sd: widget.dataForScheduledBooking!, bill: mgr.billModel!, tempBookingID: scheduledBookValidationResult.temperoryBookingId!);
            //                 if (scheduledBookSaveResult.status == true) {
            //                   // showTopSnackBar(
            //                   //   Overlay.of(context),
            //                   //   SuccessToast(
            //                   //     message:
            //                   //     ScheduledBookSaveResult.message??"",
            //                   //   ),
            //                   // );
            //                   String? bres = await Navigator.push(context, MaterialPageRoute(builder: (_) => BookingSuccessScreen(bookingSuccessData: scheduledBookSaveResult)));

            //                   if (bres != null) {
            //                     Navigator.pushAndRemoveUntil(
            //                       context,
            //                       MaterialPageRoute(builder: (_) => const HomeScreen()),
            //                       (ff) => false,
            //                     );
            //                   }
            //                 } else {
            //                   showTopSnackBar(
            //                     Overlay.of(context),
            //                     ErrorToast(
            //                       maxLines: 4,
            //                       message: scheduledBookSaveResult.message ?? "",
            //                     ),
            //                   );
            //                 }
            //               } else {
            //                 showTopSnackBar(
            //                   Overlay.of(context),
            //                   ErrorToast(
            //                     maxLines: 4,
            //                     message: scheduledBookValidationResult.message ?? "",
            //                   ),
            //                 );
            //               }
            //             } else if (widget.dataForInstantBooking != null) {
            //               var validationResult = await getIt<BookingManager>().instantBookingValidation(widget.dataForInstantBooking!, mgr.billModel!);
            //               if (validationResult.status == true) {
            //                 BookingSaveResponseModel saveResult = await getIt<BookingManager>().instantBookingSave(item: widget.dataForInstantBooking!, bill: mgr.billModel!, tempBookingID: validationResult.temperoryBookingId!);
            //                 if (saveResult.status == true) {
            //                   // Navigator.pop(context);

            //                   String? bres = await Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (_) => BookingSuccessScreen(
            //                                 bookingSuccessData: saveResult,
            //                               )));

            //                   if (bres != null) {
            //                     Navigator.pop(context);
            //                     Navigator.pop(context);

            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (_) => QuestionnaireScreen(
            //                                   bookingId: saveResult.bookingId!,
            //                                   appoinmentId: saveResult.appointmentId!,
            //                                 )));

            //                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
            //                   }
            //                 } else {
            //                   showTopSnackBar(
            //                     Overlay.of(context),
            //                     ErrorToast(
            //                       maxLines: 4,
            //                       message: saveResult.message ?? "",
            //                     ),
            //                   );
            //                 }
            //               } else {
            //                 showTopSnackBar(
            //                   Overlay.of(context),
            //                   ErrorToast(
            //                     maxLines: 4,
            //                     message: validationResult.message ?? "",
            //                   ),
            //                 );
            //               }
            //             }
            //             // Handling psychology Instant booking
            //             else {
            //               var validationResult = await getIt<BookingManager>().psychologyInstantBookingValidation(dt: widget.dataForPsychologyInstantBooking!, bill: mgr.billModel!);
            //               if (validationResult.status == true) {
            //                 BookingSaveResponseModel saveResult = await getIt<BookingManager>().psychologyInstantBookingSave(sd: widget.dataForPsychologyInstantBooking!, bill: mgr.billModel!, tempBookingID: validationResult.temperoryBookingId!);
            //                 if (saveResult.status == true) {
            //                   // Navigator.pop(context);

            //                   String? bres = await Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (_) => BookingSuccessScreen(
            //                                 bookingSuccessData: saveResult,
            //                               )));

            //                   if (bres != null) {
            //                     Navigator.pop(context);
            //                     Navigator.pop(context);

            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (_) => QuestionnaireScreen(
            //                                   bookingId: saveResult.bookingId!,
            //                                   appoinmentId: saveResult.appointmentId!,
            //                                 )));

            //                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: saveResult.bookingId!,appoinmentId: saveResult.appointmentId!,)));
            //                   }
            //                 } else {
            //                   showTopSnackBar(
            //                     Overlay.of(context),
            //                     ErrorToast(
            //                       maxLines: 4,
            //                       message: saveResult.message ?? "",
            //                     ),
            //                   );
            //                 }
            //               } else {
            //                 showTopSnackBar(
            //                   Overlay.of(context),
            //                   ErrorToast(
            //                     maxLines: 4,
            //                     message: validationResult.message ?? "",
            //                   ),
            //                 );
            //               }
            //             }
            //           },
            //         ),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
