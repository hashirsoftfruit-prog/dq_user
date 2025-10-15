import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';

final _noScreenshot = NoScreenshot.instance;

class ScreenshotHelper {
  Future<void> disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  //work on android only
  Future<void> secureScreen() async {
    // await ScreenProtector.preventScreenshotOn();
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }
}
