import 'package:dqapp/controller/managers/category_manager.dart';
import 'package:dqapp/controller/managers/payment_manager.dart';
import 'package:dqapp/controller/managers/pets_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/managers/auth_manager.dart';
import '../../controller/managers/booking_manager.dart';
import '../../controller/managers/chat_manager.dart';
import '../../controller/managers/home_manager.dart';
import '../../controller/managers/location_manager.dart';
import '../../controller/managers/profile_manager.dart';
import '../../controller/managers/psychology_manager.dart';
import '../../controller/managers/questionare_manager.dart';
import '../../controller/managers/state_manager.dart';
import '../../controller/managers/search_manager.dart';
import '../../controller/services/dio_service.dart';
import '../../view/screens/pro/pro_home_vm.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  getIt.registerSingleton<HomeManager>(HomeManager());
  // getIt.registerSingleton<CordManager>(CordManager());
  getIt.registerSingleton<StateManager>(StateManager());
  getIt.registerSingleton<PsychologyManager>(PsychologyManager());
  // getIt.registerSingleton<StudentManager>(StudentManager());
  getIt.registerSingleton<AuthManager>(AuthManager());
  getIt.registerSingleton<SearchManager>(SearchManager());
  // getIt.registerSingleton<SchoolManager>(SchoolManager());
  getIt.registerSingleton<SmallWidgets>(SmallWidgets());
  getIt.registerSingleton<CategoryMgr>(CategoryMgr());
  getIt.registerSingleton<LocationManager>(LocationManager());
  getIt.registerSingleton<BookingManager>(BookingManager());
  getIt.registerSingleton<DioClient>(DioClient());
  getIt.registerSingleton<ProfileManager>(ProfileManager());
  getIt.registerSingleton<PetsManager>(PetsManager());
  getIt.registerSingleton<ChatProvider>(ChatProvider());
  getIt.registerSingleton<QuestionnaireManager>(QuestionnaireManager());
  getIt.registerSingleton<ProHomeVm>(ProHomeVm());
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  getIt.registerSingleton<PaymentManager>(PaymentManager());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  dynamic pushTo(String route, {dynamic arguments}) {
    return navigatorkey.currentState?.pushNamed(route, arguments: arguments);
  }

  dynamic goBack() {
    return navigatorkey.currentState?.pop();
  }
}
