import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dqapp/model/helper/service_locator.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextToSpeech {
  //using singleton for better experience
  TextToSpeech._();
  static final TextToSpeech instance = TextToSpeech._();

  FlutterTts flutterTts = FlutterTts();

  Future<void> init() async {
    if (Platform.isIOS) {
      await flutterTts.setSharedInstance(true);
    }
    await flutterTts.setSpeechRate(0.4); // adjust as needed
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true); // Ensure completion

    // final langCode =
    //     getIt<SharedPreferences>().getString(StringConstants.language);
    await flutterTts.setLanguage("en-IN"); // Example language
  }

  //language code will get from notification payload
  void playSound(data, langCode) async {
    try {
      List<dynamic> medicines = jsonDecode(data);

      //if language code is not present on notificaiton we can get it from local storage
      langCode ??= getIt<SharedPreferences>().getString(
        StringConstants.language,
      );
      // Set language only, avoid setVoice due to potential binding issues
      await flutterTts.setLanguage("$langCode-IN");

      //text for speaking
      String toSpeak = langCode == "ml"
          ? "നിങ്ങൾക്ക് "
          : "It's time for you to take ";

      //medicines are stored in list, so using loop for adding to text
      for (var item in medicines) {
        double dose = double.parse(item['count'].toString());
        String name = item['name'].toString();
        final doseCount = langCode == "ml"
            ? medicineMapMl[dose]
            : medicineMapEn[dose];

        if (doseCount != null) {
          toSpeak += "$doseCount $name \n";
        } else {
          toSpeak += "$name \n";
        }
      }

      //last part of text
      toSpeak += medicines.length > 1
          ? (langCode == "ml" ? "എന്നിവ കഴിക്കാനുള്ള സമയമായി." : "")
          : (langCode == "ml" ? "കഴിക്കാനുള്ള സമയമായി." : "");

      log(toSpeak);
      await flutterTts.setVoice({
        // "name": "$langCode-in-x-mle-local",
        "locale": "$langCode-IN",
      });
      await flutterTts.speak(toSpeak);
    } catch (e, s) {
      if (kDebugMode) {
        print("TextToSpeech Error: $e\n$s");
      }
    }
  }

  //medicine dose map for malayalam
  Map<double, String> medicineMapMl = {
    0.25: "കാൽ", // quarter
    0.5: "അര", // half
    0.75: "മുക്കാൽ", // three-quarter
    1.0: "ഒരു",
    1.25: "ഒന്നേകാൽ",
    1.5: "ഒന്നര",
    1.75: "ഒന്നേ മുക്കാൽ",
    2.0: "രണ്ട്",
    2.25: "രണ്ടേകാൽ",
    2.5: "രണ്ടര",
    2.75: "രണ്ടേമുക്കാൽ",
    3.0: "മൂന്ന്",
    3.25: "മൂന്നേകാൽ",
    3.5: "മൂന്നര",
    3.75: "മൂന്നേമുക്കാൽ",
    4.0: "നാല്",
    5.0: "അഞ്ച്",
    6.0: "ആറ്",
    7.0: "ഏഴ്",
    8.0: "എട്ട്",
    9.0: "ഒമ്പത്",
    10.0: "പത്ത്",
  };

  //medicine dose map for english
  Map<double, String> medicineMapEn = {
    0.25: "Quarter",
    0.5: "Half",
    0.75: "Three-quarter",
    1.0: "One",
    1.25: "One and a quarter",
    1.5: "One and a half",
    1.75: "One and three-quarters",
    2.0: "Two",
    2.25: "Two and a quarter",
    2.5: "Two and a half",
    2.75: "Two and three-quarters",
    3.0: "Three",
    3.25: "Three and a quarter",
    3.5: "Three and a half",
    3.75: "Three and three-quarters",
    4.0: "Four",
    5.0: "Five",
    6.0: "Six",
    7.0: "Seven",
    8.0: "Eight",
    9.0: "Nine",
    10.0: "Ten",
  };
}
