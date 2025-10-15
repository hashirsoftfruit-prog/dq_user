import 'package:dqapp/view/screens/home_screen.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  const PdfViewerPage(this.url, {super.key});
  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfControllerPinch? pdfController;
  int pageNo = 0;
  int? totalPage;
  late File pFile;
  bool isLoading = false;

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.url;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(file.path),
      );
      // pFile = file;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // double maxHeight = constraints.maxHeight;
          // double maxWidth = constraints.maxWidth;
          // double h1p = maxHeight * 0.01;
          // double h10p = maxHeight * 0.1;
          // double w10p = maxWidth * 0.1;

          return ProgressHUD(
            child: Builder(
              builder: (context) {
                final progress = ProgressHUD.of(context);

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            progress!.show();
                            String ur = widget.url;
                            final fileurl = Uri.parse(ur);
                            final response = await http.get(fileurl);
                            Directory docDir =
                                await getApplicationDocumentsDirectory();
                            var fl = await File(
                              path.join(docDir.path, path.basename(ur)),
                            ).writeAsBytes(response.bodyBytes);
                            var xfl = XFile(fl.path);
                            await Share.shareXFiles([xfl], text: '');
                            progress.dismiss();
                          },
                          icon: const Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  body: pdfController == null
                      ? const Center(child: AppLoader(size: 30))
                      : Center(child: PdfViewPinch(controller: pdfController!)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
