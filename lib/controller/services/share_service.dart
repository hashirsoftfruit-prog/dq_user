import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareTextWithImage(String text, String imageUrl) async {
    try {
      // Step 1: Download image from URL
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      // Step 2: Save image to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_image.png').create();
      await file.writeAsBytes(bytes);

      // Step 3: Share text and image
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: text),
      );
    } catch (e) {
      debugPrint('Error sharing text & image: $e');
    }
  }
}
