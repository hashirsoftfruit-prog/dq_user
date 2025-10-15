// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/model/core/basic_response_model.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/pdf_view_screen.dart';
import 'package:entry/entry.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

import '../../widgets/photo_view_widget.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  // AvailableDocsModel docsData;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<HomeManager>().getMedicalRecordsUsers();
    });
    // _controller.addListener(_scrollListener);
  }
  //
  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getUpcomingAppointments(index:index );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          // List<String> users = ["ramees","amid","havu"];

          return Consumer<HomeManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.medicalRecords,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: pad(
                  horizontal: w1p * 5,
                  child: ListView(
                    // controller: _controller,
                    children: [
                      verticalSpace(h1p * 2),
                      mgr.medicalRecsLoader == true &&
                              mgr.medicalRecordUsers.isEmpty
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
                          : mgr.medicalRecordUsers.isNotEmpty
                          ? Entry(
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
                                child: Column(
                                  children: mgr.medicalRecordUsers.map((item) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: h1p * 2),
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  MedicalRecordsListScreen(
                                                    maxH: maxHeight,
                                                    maxW: maxWidth,
                                                    userid: item.id!,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.1,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(1, 1),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 32.0,
                                              horizontal: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  child: Image.asset(
                                                    "male".toUpperCase() ==
                                                            "MALE"
                                                        ? "assets/images/person-man.png"
                                                        : "assets/images/person-women.png",
                                                    color: const Color(
                                                      0xff797979,
                                                    ),
                                                  ),
                                                ),
                                                horizontalSpace(8),
                                                SizedBox(
                                                  width: w10p * 4,
                                                  child: Text(
                                                    getIt<StateManager>()
                                                        .capitalize(
                                                          '${item.firstName ?? ""} ${item.lastName ?? ""}',
                                                        ),
                                                    style: t500_16.copyWith(
                                                      color: const Color(
                                                        0xff3E41AD,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Text(
                                                  "${item.medicalRecordsCount} Files",
                                                  style: t500_14.copyWith(
                                                    color: const Color(
                                                      0xff797979,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noRecords,
                                  style: TextStyles.notAvailableTxtStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MedicalRecordsListScreen extends StatefulWidget {
  final double maxH;
  final double maxW;
  final int userid;

  const MedicalRecordsListScreen({
    super.key,
    required this.maxH,
    required this.maxW,
    required this.userid,
  });

  @override
  State<MedicalRecordsListScreen> createState() =>
      _MedicalRecordsListScreenState();
}

class _MedicalRecordsListScreenState extends State<MedicalRecordsListScreen> {
  @override
  void dispose() {
    getIt<HomeManager>().disposeMedicalRecords();
    super.dispose();
  }

  @override
  void initState() {
    getIt<HomeManager>().getMedicalRecords(widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = widget.maxH;
    double maxWidth = widget.maxW;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    imageContainer(String url) {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.black12,
            isScrollControlled: true,
            useSafeArea: true,
            // showDragHandle: true,
            context: context,
            builder: (context) =>
                PhotoViewContainer(w1p: w1p, h1p: h1p, url: url),
          );
        },
        child: Container(
          width: maxWidth,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: Colours.lightBlu),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(url),
            ),
          ),
        ),
      );
    }

    pdfContainer(String url) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PdfViewerPage(url)),
          );
        },
        child: Container(
          width: maxWidth,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: Colours.lightBlu),
            image: const DecorationImage(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              image: AssetImage("assets/images/placeholder-pdf.png"),
            ),
          ),
        ),
      );
    }

    return Consumer<HomeManager>(
      builder: (context, mgr, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: getIt<SmallWidgets>().appBarWidget(
              title: AppLocalizations.of(context)!.medicalRecords,
              height: h10p,
              width: w10p,
              fn: () {
                Navigator.pop(context);
              },
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getIt<HomeManager>().getMedicalRecords(widget.userid);
              },
              child: mgr.medicalRecsLoader == true && mgr.medicalRecords.isEmpty
                  ? const Entry(
                      yOffset: -50,
                      // scale: 20,
                      delay: Duration(milliseconds: 0),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(28.0),
                          child: LogoLoader(),
                        ),
                      ),
                    )
                  : mgr.medicalRecords.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noRecords,
                          style: TextStyles.notAvailableTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView(
                      children: mgr.medicalRecords.map((e) {
                        var indx = mgr.medicalRecords.indexOf(e);

                        return e.file != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                  bottom: mgr.medicalRecords.length - 1 == indx
                                      ? h1p * 10
                                      : 16.0,
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      e.file!.endsWith('.pdf')
                                          ? pdfContainer(
                                              StringConstants.baseUrl + e.file!,
                                            )
                                          : imageContainer(
                                              '${StringConstants.baseUrl}${e.file}',
                                            ),
                                      verticalSpace(2),
                                      Container(
                                        width: maxWidth,
                                        decoration: const BoxDecoration(
                                          // border: Border.all(color: Colours.lightBlu),
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(8),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.typeOfRecord ?? "",
                                                style: t500_14.copyWith(
                                                  color: clr444444,
                                                ),
                                              ),
                                              Text(
                                                e.createdDate ?? "",
                                                style: t400_12.copyWith(
                                                  color: clr444444,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }).toList(),
                    ),
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 12),
              child: ButtonWidget(
                btnText: AppLocalizations.of(context)!.upload,
                ontap: () async {
                  BasicResponseModel? result = await showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return MedicalRecordUploadScreen(
                        maxH: maxHeight,
                        maxW: maxWidth,
                        userid: widget.userid,
                      );
                    },
                  );

                  if (result != null) {
                    getIt<HomeManager>().getMedicalRecordsUsers();
                    getIt<HomeManager>().getMedicalRecords(widget.userid);

                    showTopSnackBar(
                      snackBarPosition: SnackBarPosition.top,
                      padding: const EdgeInsets.all(30),
                      Overlay.of(context),
                      SuccessToast(maxLines: 3, message: result.message ?? ""),
                    );
                  }
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}

class MedicalRecordUploadScreen extends StatefulWidget {
  final double maxH;
  final double maxW;
  final int userid;

  const MedicalRecordUploadScreen({
    super.key,
    required this.maxH,
    required this.maxW,
    required this.userid,
  });

  @override
  State<MedicalRecordUploadScreen> createState() =>
      _MedicalRecordUploadScreenState();
}

class _MedicalRecordUploadScreenState extends State<MedicalRecordUploadScreen> {
  @override
  void dispose() {
    getIt<HomeManager>().disposeFileUpload();
    super.dispose();
  }

  var txtCntr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double maxHeight = widget.maxH;
    double maxWidth = widget.maxW;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    // floatBtn(String url) {
    //   return Padding(
    //     padding: const EdgeInsets.all(18.0),
    //     child: Container(
    //       width: maxWidth,
    //       height: h1p * 5,
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colours.primaryblue),
    //       child: Center(
    //         child: Text(
    //           "Upload",
    //           style: t700_16.copyWith(color: const Color(0xffffffff)),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Builder(
      builder: (context) {
        // final  progress = ProgressHUD.of(context);
        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
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

              int existingFileCount = mgr.selectedMedicRecordsPaths.length;
              int existingFilesSize = mgr.selectedMedicRecordsPaths.fold<int>(
                0,
                (sum, path) {
                  final file = File(path);
                  return sum + (file.existsSync() ? file.lengthSync() : 0);
                },
              );

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
                                  colors: [
                                    Colors.purple,
                                    Colors.purple.shade400,
                                  ],
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
                              FilePickerResult? result = await FilePicker
                                  .platform
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
                              final XFile? result = await ImagePicker()
                                  .pickImage(
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

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.medicalRecords,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.typeOfRecord,
                          style: t400_12.copyWith(color: clr444444),
                        ),
                        TextField(
                          decoration: lineDec(hnt: "fd"),
                          controller: txtCntr,
                          style: t400_14.copyWith(color: clr202020),
                        ),
                        verticalSpace(h1p * 2),

                        Container(
                          width: maxWidth,
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
                                  AppLocalizations.of(
                                    context,
                                  )!.maxCountAndFileSize,
                                  style: t400_10.copyWith(color: Colors.grey),
                                ),
                                verticalSpace(h1p * 1),
                                mgr.selectedMedicRecordsPaths.isEmpty
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
                                          children: mgr
                                              .selectedMedicRecordsPaths
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
                                                                          w10p *
                                                                          1.5,
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
                                                                        style: t500_12.copyWith(
                                                                          color: const Color(
                                                                            0xff707070,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                verticalSpace(
                                                                  h1p,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          // Navigator.pop(context);

                                                                          showModalBottomSheet(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            isScrollControlled:
                                                                                true,
                                                                            showDragHandle:
                                                                                true,
                                                                            barrierColor:
                                                                                Colors.white,
                                                                            useSafeArea:
                                                                                true,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                0,
                                                                              ),
                                                                            ),
                                                                            // showDragHandle: true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) => Center(
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
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                            border: Border.all(
                                                                              color: Colors.black26,
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
                                                                                color: clr444444,
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
                                                                          mgr.deleteFile(
                                                                            e,
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(
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
                                                                                height: 1,
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
                                                        margin:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  h1p * 0.5,
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
                                                          style: t400_12
                                                              .copyWith(
                                                                color:
                                                                    clr444444,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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

                        //   mgr.selectedMedicRecordsPaths.isNotEmpty
                        //       ? Padding(
                        //           padding: EdgeInsets.all(w1p),
                        //           child: Wrap(
                        //               children: mgr.selectedMedicRecordsPaths
                        //                   .map((e) => InkWell(
                        //                         onTap: () async {
                        //                           var d = e.split(('/'));
                        //                           // print(d.last);
                        //                           bool? result = await showModalBottomSheet(
                        //                               context: context,
                        //                               builder: (context) {
                        //                                 return Container(
                        //                                   height: h10p * 2,
                        //                                   color: Colors.white,
                        //                                   child: pad(
                        //                                     vertical: h1p * 2,
                        //                                     horizontal: w1p * 4,
                        //                                     child: Column(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       children: [
                        //                                         Row(
                        //                                           children: [
                        //                                             SizedBox(
                        //                                               height: w10p * 1.5,
                        //                                               // width: h1p*3,
                        //                                               // color: Colors.redAccent,
                        //                                               child: Image.asset("assets/images/fileicon.png"),
                        //                                             ),
                        //                                             horizontalSpace(w1p),
                        //                                             Expanded(child: Text(d.last, style: t500_12.copyWith(color: const Color(0xff707070))))
                        //                                           ],
                        //                                         ),
                        //                                         verticalSpace(h1p),
                        //                                         Row(
                        //                                           children: [
                        //                                             Expanded(
                        //                                                 child: InkWell(
                        //                                               onTap: () {
                        //                                                 Navigator.pop(context);
                        //                                               },
                        //                                               child: Container(
                        //                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                        //                                                 height: h10p * 0.5,
                        //                                                 child: Center(
                        //                                                   child: Text(
                        //                                                     AppLocalizations.of(context)!.cancel,
                        //                                                     style: t500_14.copyWith(color: clr444444),
                        //                                                   ),
                        //                                                 ),
                        //                                               ),
                        //                                             )),
                        //                                             horizontalSpace(w1p),
                        //                                             Expanded(
                        //                                                 child: InkWell(
                        //                                               onTap: () {
                        //                                                 Navigator.pop(context, true);
                        //                                               },
                        //                                               child: Container(
                        //                                                 decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        //                                                 height: h10p * 0.5,
                        //                                                 child: Center(
                        //                                                   child: Text(
                        //                                                     AppLocalizations.of(context)!.delete,
                        //                                                     style: t500_14.copyWith(height: 1),
                        //                                                   ),
                        //                                                 ),
                        //                                               ),
                        //                                             ))
                        //                                           ],
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 );
                        //                               });
                        //                           if (result == true) {
                        //                             getIt<HomeManager>().deleteFile(e);
                        //                           }
                        //                         },
                        //                         child: SizedBox(
                        //                           height: w10p * 1.5,
                        //                           // width: h1p*3,
                        //                           // color: Colors.redAccent,
                        //                           child: Image.asset("assets/images/fileicon.png"),
                        //                         ),
                        //                       ))
                        //                   .toList()),
                        //         )
                        //       : const SizedBox(),
                        //   verticalSpace(h1p * 2),
                        //   Container(
                        //     width: maxWidth,
                        //     decoration: const BoxDecoration(
                        //       color: Colours.lightBlu,
                        //     ),
                        //     child: pad(
                        //         vertical: h1p * 3,
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               AppLocalizations.of(context)!.uploadFile,
                        //               style: t700_16.copyWith(color: const Color(0xff3d41ad)),
                        //             ),
                        //             Text(
                        //               AppLocalizations.of(context)!.medicalRecordsDiagnosisReport,
                        //               style: t400_10.copyWith(color: const Color(0xff545454)),
                        //             ),
                        //             verticalSpace(h1p * 1),
                        //             Padding(
                        //               padding: EdgeInsets.all(w1p),
                        //               child: SizedBox(width: w10p * 1.5, height: w10p * 1.5, child: Image.asset("assets/images/uploadicon.png")),
                        //             ),
                        //             verticalSpace(h1p * 1),
                        //             InkWell(
                        //               highlightColor: Colors.transparent,
                        //               splashColor: Colors.transparent,
                        //               onTap: () async {
                        //                 FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, allowedExtensions: ['jpg', 'pdf'], type: FileType.custom);
                        //                 if (result != null) {
                        //                   List<String> paths = result.paths.map((path) => path!).toList();
                        //                   getIt<HomeManager>().addFiles(paths);
                        //                 } else {
                        //                   // User canceled the picker
                        //                 }
                        //               },
                        //               child: Container(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(containerRadius),
                        //                       border: Border.all(
                        //                         color: const Color(0xff888888),
                        //                       )),
                        //                   child: pad(
                        //                       horizontal: w1p * 6,
                        //                       vertical: h1p,
                        //                       child: Text(
                        //                         "Browse",
                        //                         style: t500_14.copyWith(color: const Color(0xff313131)),
                        //                       ))),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                      ],
                    ),
                  ),
                  myLoader(visibility: mgr.medicalRecsLoader == true),
                ],
              ),
              floatingActionButton: mgr.selectedMedicRecordsPaths.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w1p * 4,
                        vertical: 12,
                      ),
                      child: ButtonWidget(
                        isLoading: mgr.medicalRecsLoader,
                        btnText: AppLocalizations.of(context)!.upload,
                        ontap: () async {
                          if (txtCntr.text.trim().isNotEmpty) {
                            var result = await getIt<HomeManager>()
                                .uploadMedicalRecord(
                                  userid: widget.userid,
                                  typeOfRecord: txtCntr.text,
                                  files: mgr.selectedMedicRecordsPaths,
                                );

                            // print(result.toJson());

                            if (result.status == true) {
                              Navigator.pop(context, result);
                            }
                          } else {
                            showTopSnackBar(
                              snackBarPosition: SnackBarPosition.bottom,
                              padding: const EdgeInsets.all(30),
                              Overlay.of(context),
                              ErrorToast(
                                maxLines: 2,
                                message: AppLocalizations.of(
                                  context,
                                )!.pleaseProvideTypeofRec,
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }
}
