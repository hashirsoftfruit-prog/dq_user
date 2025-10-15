import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class PhotoViewContainer extends StatelessWidget {
  final String url;
  final double h1p;
  final double w1p;
  const PhotoViewContainer(
      {super.key, required this.url, required this.h1p, required this.w1p});
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(builder: (context) {
        final progress = ProgressHUD.of(context);

        return Scaffold(
            extendBody: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              actions: [
                Container(
                    margin: const EdgeInsets.only(top: 5.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                        onPressed: () async {
                          progress!.show();
                          String ur = url;
                          final fileurl = Uri.parse(ur);
                          final response = await http.get(fileurl);
                          Directory docDir =
                              await getApplicationDocumentsDirectory();
                          var fl = await File(
                                  path.join(docDir.path, path.basename(ur)))
                              .writeAsBytes(response.bodyBytes);
                          var xfl = XFile(fl.path);
                          await Share.shareXFiles([xfl], text: '');
                          progress.dismiss();
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        )))
              ],
            ),
            body: PhotoView(
                disableGestures: true,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                imageProvider: NetworkImage(url)));
      }),
    );
  }
}
