//
// import 'package:edumartial/model/core/login_student_model.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'dart:convert';
//
//
// class HiveMethods {
//   String hivebox = 'hivebox';
//
//   storeUser(StudentAuthModel usr) async {
//     await Hive.initFlutter();
//     var box = await Hive.openBox(hivebox);
//     usr.school=null;
//
//     var dt =usr.toJson();//open the hive box before writing
//     await box.add(dt);
//     Hive.close();
//
//     print("user stored");//closing the hive box
//   }
//
//
//   Future<StudentAuthModel> getUserDetails() async {
//     await Hive.initFlutter();
//     var box = await Hive.openBox(hivebox);
//     var userMap = box.getAt(0);
//     print(userMap);
//     var um = StudentAuthModel.fromJson(Map.from(userMap));
//     return um;
//
//    }
//
//
//   //   await Hive.initFlutter();
//   //
//   //   var box = await Hive.openBox(hiveBox);
//   //   List<CallRec> users = [];
//   //
//   //   for (int i = box.length - 1; i >= 0; i--) {
//   //     var userMap = box.getAt(i);
//   //
//   //     users.add(CallRec.fromJson(Map.from(userMap),i));
//   //   }
//   //   print("returned list");
//   //   return users;
//   // }
//   //
//   // //Deleting one data from hive DB
//   // deleteCall(int id) async {
//   //   var box = await Hive.openBox(hiveBox);
//   //   await box.deleteAt(id);
//   // }
//   //
//   // //Deleting whole data from Hive
//   // deleteAllUsers() async {
//   //   var box = await Hive.openBox(hiveBox);
//   //   await box.clear();
//   // }
//   //
//   //  updateItem(String id,Map<String,dynamic> rec) async {
//   //   await Hive.initFlutter();
//   //   var box = await Hive.openBox(hiveBox);
//   //   await box.put(id,rec);
//   //   await getIt<CallLogsManager>().getCallLogs();
//   //   print("updated");
//   // }
//
//
//
// }
