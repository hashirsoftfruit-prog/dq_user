import 'dart:math';

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';

//this manager used for common functions across the app
class StateManager extends ChangeNotifier {
  int index = 0;
  int petBtNavIndex = 1;
  bool showPass = false;
  bool showLoader = false;
  String validatonErrorTxt = "Invalid input";
  String? appLang;

  String? currentLanguage;
  Locale? locale;
  bool inCallStatus = false;
  bool inChatStatus = false;
  bool showCallEnded = false;

  List<BasicListItem> addedItems = [];
  List<BasicListItem> listItems = [];

  String searchQuery = '';

  addItems(List<BasicListItem> vals, {bool? isRefresh}) {
    if (isRefresh == true) {
      addedItems = [];
    }
    addedItems.addAll(vals);
    notifyListeners();
  }

  setListItems(List<BasicListItem> vals, {bool? isRefresh}) {
    if (isRefresh == true) {
      listItems = [];
    }
    listItems = vals;
    notifyListeners();
  }

  setSearchQueryValue(String val, {bool? isDispose}) {
    searchQuery = val;
    if (isDispose != true) {
      notifyListeners();
    }
  }

  removeFromAddedItems(BasicListItem val) {
    addedItems.remove(val);
    notifyListeners();
  }

  setCallEndedStatus() async {
    showCallEnded = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    showCallEnded = false;
    notifyListeners();
  }

  changePetHomeIndex(int val, {bool? isDispose}) {
    petBtNavIndex = val;

    if (isDispose != true) {
      notifyListeners();
    }
  }

  String generateRandomString() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  setInCallStatus(bool val) {
    inCallStatus = val;
    // notifyListeners();
  }

  setInChatStatus(bool val) {
    inChatStatus = val;
    // notifyListeners();
  }
  // setSheetOpenStatus({required bool status}){
  //   sheetOpenStatus = status;
  // }
  //
  //
  // bool getSheetOpenStatus(){
  //   return sheetOpenStatus ;
  //
  // }

  bool getInCallStatus() {
    return inCallStatus;
  }

  bool getInChatStatus() {
    return inChatStatus;
  }

  void changeLocale(String newLocale) {
    Locale convertedLocale;
    getIt<SharedPreferences>().setString(StringConstants.language, newLocale);

    // currentLanguage = newLocale;

    convertedLocale = Locale(newLocale);
    locale = convertedLocale;

    notifyListeners();
  }

  String? getLocaleTxt(String s, context) {
    // String? validateFieldValues(String val, String type) {
    switch (s) {
      case StringConstants.dPrefNoPref:
        return AppLocalizations.of(context)!.noPreference;
      case StringConstants.dPrefMale:
        return AppLocalizations.of(context)!.male;
      case StringConstants.dPrefFemale:
        return AppLocalizations.of(context)!.female;
      case StringConstants.english:
        return AppLocalizations.of(context)!.english;
      case StringConstants.malayalam:
        return AppLocalizations.of(context)!.malayalam;
      // break;

      default:
        return null;
    }
  }

  // }
  List<double> generateEqualIntervals(int length) {
    if (length <= 0) {
      return []; // Return an empty list for non-positive lengths
    }

    List<double> intervals = [];
    double step = 1.0 / (length + 1); // Calculate the interval step

    for (int i = 1; i <= length; i++) {
      intervals.add(i * step); // Calculate each interval value
    }

    return intervals;
  }

  String convertSliderValueToTime(double sliderValue) {
    // Total minutes in a day
    int totalMinutes = (sliderValue * 1439)
        .round(); // Convert the slider value to total minutes

    // Get hours and minutes from total minutes
    int hours = totalMinutes ~/ 60; // Integer division to get hours
    int minutes = totalMinutes % 60; // Modulo to get remaining minutes

    // Determine AM or PM
    String period = hours >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    if (hours == 0) {
      hours = 12; // Midnight case: 12 AM
    } else if (hours > 12) {
      hours -= 12; // Convert hours greater than 12 to 12-hour format
    }

    // Format the time as HH:MM AM/PM
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }

  double convertTimeToSliderValue(String time) {
    // Split the time into hours and minutes
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]); // Extract hours
    int minutes = int.parse(parts[1].split(' ')[0]); // Extract minutes

    // Determine AM or PM
    String period = parts[1].split(' ')[1];
    if (period == 'PM') {
      hours += 12; // Add 12 hours for PM
    }
    if (hours == 24) {
      hours = 12;
    }

    // Calculate total minutes from the given time
    int totalMinutes = hours * 60 + minutes;

    // Calculate the slider value by dividing total minutes by 1440
    double sliderValue = (totalMinutes / 1439).clamp(0, 1);

    // print('sliderValue: $sliderValue');

    return sliderValue;
  }

  List<String> getEqualIntervals(
    DateTime startTime,
    DateTime endTime,
    int numberOfIntervals,
  ) {
    // Calculate the total duration between startTime and endTime
    Duration totalDuration = endTime.difference(startTime);

    // Calculate the duration for each interval
    Duration intervalDuration = totalDuration ~/ numberOfIntervals;

    // Create a list to hold the interval times
    List<DateTime> intervals = [];

    // Generate the interval times
    for (int i = 0; i <= numberOfIntervals; i++) {
      intervals.add(startTime.add(intervalDuration * i));
    }
    DateFormat timeFormat = DateFormat.jm(); // 'jm' is for 'hh:mm a'

    // Convert each DateTime to the desired time format with AM/PM
    return intervals.map((dateTime) => timeFormat.format(dateTime)).toList();
    // List<String> timeValues = convertDateTimeToTimeList(intervals);
    // return timeValues;
    // return intervals;
  }

  disposeLogin() {
    index = 0;
    showLoader = false;
    showPass = false;
    // notifyListeners();
  }

  TimeOfDay getTimeOfDayFromString(String time) {
    final DateFormat dateFormat =
        DateFormat.jm(); // Format for parsing time strings like "04:50 PM"
    final DateTime parsedTime = dateFormat.parse(time);
    return TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);
  }

  String getStringFromTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm().format(dateTime); // Format to "hh:mm a"
  }

  String convertTo24HFormat(String time12HourFormat) {
    // Parse the 12-hour format time
    DateTime parsedTime = DateFormat.jm().parse(time12HourFormat);

    // Convert it to 24-hour format with seconds (HH:mm:ss)
    return DateFormat('HH:mm:ss').format(parsedTime);
  }

  String getDayLabel(int days) {
    if (days == 1) {
      return '$days day';
    } else if (days > 1 && days < 7) {
      return '$days days';
    } else if (days == 7) {
      return '1 week';
    } else if (days == 14) {
      return '2 weeks';
    } else if (days == 30) {
      return '1 month';
    } else if (days == 60) {
      return '2 months';
    } else if (days == 180) {
      return '6 months';
    } else if (days == 365) {
      return '1 year';
    } else {
      return '$days days'; // fallback for any other values
    }
  }

  String roundDoubleV(val) {
    return double.parse(val).toStringAsFixed(1).toString();
  }

  showPwd(bool val) {
    showPass = val;
    notifyListeners();
  }

  getLoader(bool val) {
    showLoader = val;
    notifyListeners();
  }

  updateScrollIndex(int val) {
    // print("btmNavIndex changd to $val");
    index = val;
    notifyListeners();
  }

  //
  //   logout(){
  //     btmNavIndex = 2;
  //
  //   }
  //
  //
  //   showCalender(){
  // isShowCalender = !isShowCalender;
  // notifyListeners();
  //   }
  //
  //   initHomeFn(){
  //     imgError = false;
  //   }
  getTimeFromDTime(DateTime dt) {
    // Format the date using intl package
    String formattedDate = DateFormat.jm().format(dt);
    return formattedDate;
  }

  getMonthDay(DateTime dt) {
    // Format the date using intl package
    String formattedDate = DateFormat.MMMd().format(dt);
    return formattedDate;
  }

  String capitalize(String val) {
    if (val.trim().isNotEmpty) {
      return "${val[0].toUpperCase()}${val.substring(1).toLowerCase()}";
    } else {
      return "";
    }
  }

  String? validateFieldValues(String val, String type) {
    switch (type) {
      case "int":
        return int.tryParse(val) == null ? "Invalid input" : null;
      // break;
      case "double":
        return double.tryParse(val) == null ? "Invalid input" : null;
      case "height":
        return double.tryParse(val) == null ||
                (double.parse(val) < 1 || double.parse(val) > 300)
            ? "Invalid input"
            : null;
      case "weight":
        return double.tryParse(val) == null ||
                (double.parse(val) < 1 || double.parse(val) > 999)
            ? "Invalid input"
            : null;
      case "char":
        return null;

      case "bloodPressure":
        return isValidBloodPressure(val) == false ? "Invalid input" : null;
      default:
        return null;
    }
  }

  convertStringDateToddmmyy(String dt) {
    DateTime date = DateTime.parse(dt);
    // Format the date using intl package
    String formattedDate = DateFormat('dd-MMM-yy').format(date);
    // Feb 07 2025
    return formattedDate;
  }

  convertDateTimeToDDMMYYY(DateTime dt) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    return formattedDate; //01/01/2000
  }

  convertStringDateToyMMMMd(String dt) {
    DateTime date = DateTime.parse(dt);
    String formattedDate = DateFormat.yMMMMd().format(date);
    // "October 14, 2024"
    return formattedDate;
  }

  convertStringDateToyMMMd(String dt) {
    DateTime date = DateTime.parse(dt);
    String formattedDate = DateFormat.yMMMd().format(date);
    // "Oct 14, 2024"
    return formattedDate;
  }

  convertStringDateToMMMddyyyy(String dt) {
    DateTime date = DateTime.parse(dt);
    // Format the date using intl package
    String formattedDate = DateFormat('MMM dd yyyy').format(date);
    // Feb 07 2025
    return formattedDate;
  }

  DateTime? convertStringToDDMMYYY(String dt) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime? dateTime = dateFormat.tryParse(dt);
    // DateTime date = DateTime.parse(dt);
    // Format the date using intl package
    // String formattedDate = DateFormat.yMMMMd().format(date);
    return dateTime;
  }

  String? getFormattedTime(String? time) {
    if (time != null) {
      DateFormat inputFormat = DateFormat("HH:mm:ss");
      DateFormat outputFormat = DateFormat("hh:mm a");
      DateTime dateTime = inputFormat.parse(time);
      String formattedTime = outputFormat.format(dateTime);
      return formattedTime;
    } else {
      return null;
    }
  }

  int calculateDayDifference(String dateString) {
    try {
      // Parse the input date string
      DateTime inputDate = DateFormat('yyyy-MM-dd').parse(dateString);

      // Get today's date
      DateTime today = DateTime.now();

      // Calculate the difference in days
      return inputDate.difference(today).inDays;
    } catch (e) {
      // Handle invalid date string format
      // print('Error parsing date: $e');
      return 0;
    }
  }

  getTimeToDateTime(String time) {
    DateTime today = DateTime.now();

    // Combine the current date with the time string
    String dateTimeString = "${DateFormat('yyyy-MM-dd').format(today)} $time";

    // Parse the combined string to a DateTime object
    DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(dateTimeString);
    return dateTime;
  }

  int calculateAge(String dob) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime birthDate = format.parse(dob);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  getTimefromDatetimeString(String dateTimeString) {
    DateTime parsedDateTime = DateTime.parse(dateTimeString);

    // Format to desired time format (e.g., 08:30 PM)
    String formattedTime = DateFormat('hh:mm a').format(parsedDateTime);

    return formattedTime;
  }

  String convertTime(String input) {
    // Split the input string by colon
    List<String> parts = input.split(':');

    // Extract hours, minutes, and seconds
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    // int seconds = int.parse(parts[2]); // We won't use seconds in the output

    // Determine the period (AM/PM) and convert hours to 12-hour format
    String period = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    if (hours == 0) {
      hours = 12; // 12 AM or 12 PM
    }

    // Format the output string
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }

  bool isValidBloodGroup(String bloodGroup) {
    // Regular expression pattern for blood groups (e.g., A+, AB-, etc.)
    RegExp regex1 = RegExp(r'^[ABO][+-]$');
    RegExp regex2 = RegExp(r'^[ABO][ABO][+-]$');

    // Check if the entered blood group matches the pattern
    if (regex1.hasMatch(bloodGroup) || regex2.hasMatch(bloodGroup)) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidBloodPressure(String bp) {
    // Regular expression pattern for blood groups (e.g., A+, AB-, etc.)
    // RegExp regex = RegExp(r'^[ABO][+-]$');
    List<String> bpParts = bp.split('/');
    if (bpParts.length == 2 &&
        double.tryParse(bpParts[0]) != null &&
        double.tryParse(bpParts[1]) != null) {
      return true;
    } else {
      return false;
    }
    // onImageError(){
    //   imgError = true;
    //   notifyListeners();
    // }

    // removeLastIfZero(String str){
    //   if (str != null && str.length > 0 ) {
    //
    //     var st = str.substring(str.length-1);
    //     if(st == "0"){
    //       str = str.substring(0, str.length - 1);
    //
    //     }
    //   }
    //   return str;
    // }

    // Future<bool> checkInternetConnection() async {
    //   var connectivityResult = await Connectivity().checkConnectivity();
    //   return connectivityResult != ConnectivityResult.none;
    // }
  }

  String buildAddress(List<String?> addressParts) {
    return addressParts
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(', ');
  }

  String capitalizeFirstLetter(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600; // Get the number of hours
    int minutes =
        (totalSeconds % 3600) ~/ 60; // Get the number of remaining minutes
    int seconds = totalSeconds % 60; // Get the remaining seconds

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
