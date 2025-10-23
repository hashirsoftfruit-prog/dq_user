import 'package:dqapp/controller/managers/category_manager.dart';
import 'package:dqapp/controller/managers/payment_manager.dart';
import 'package:dqapp/fcm.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/helper/screenshot.dart';
import 'package:dqapp/model/helper/text_to_speech.dart';
import 'package:dqapp/view/screens/pro/pro_home_vm.dart';
import 'package:dqapp/view/screens/search_choose_screen.dart';
import 'package:dqapp/view/screens/starting_screens/splash_scren.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/managers/auth_manager.dart';
import 'controller/managers/booking_manager.dart';
import 'controller/managers/chat_manager.dart';
import 'controller/managers/home_manager.dart';
import 'controller/managers/location_manager.dart';
import 'controller/managers/pets_manager.dart';
import 'controller/managers/profile_manager.dart';
import 'controller/managers/psychology_manager.dart';
import 'controller/managers/questionare_manager.dart';
import 'controller/managers/search_manager.dart';
import 'controller/managers/state_manager.dart';
import 'controller/routes/router.dart';
import 'firebase_options.dart';
import 'model/helper/service_locator.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //disable screenshot
  await ScreenshotHelper().secureScreen();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase notifications
  await NotificationService.instance.init();

  //text to speech
  await TextToSpeech.instance.init();

  // Setup service locator for dependency injection
  await setupServiceLocator();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

// Widget to handle and display errors in the app
class ErrorWidgetClass extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorWidgetClass(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(errorMessage: errorDetails.exceptionAsString());
  }
}

// Main application widget
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyRouteObserver myRouteObserver = MyRouteObserver();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set the app label based on a condition
    String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';

    // Initialize Zoom Video SDK
    var zoom = ZoomVideoSdk();
    InitConfig initConfig = InitConfig(domain: "zoom.us", enableLog: true);
    zoom.initSdk(initConfig);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<StateManager>()),
        ChangeNotifierProvider(create: (context) => getIt<AuthManager>()),
        ChangeNotifierProvider(create: (context) => getIt<CategoryMgr>()),
        ChangeNotifierProvider(create: (context) => getIt<LocationManager>()),
        ChangeNotifierProvider(create: (context) => getIt<HomeManager>()),
        ChangeNotifierProvider(create: (context) => getIt<PsychologyManager>()),
        ChangeNotifierProvider(create: (context) => getIt<BookingManager>()),
        ChangeNotifierProvider(create: (context) => getIt<ProfileManager>()),
        ChangeNotifierProvider(create: (context) => getIt<SearchManager>()),
        ChangeNotifierProvider(create: (context) => getIt<ChatProvider>()),
        ChangeNotifierProvider(create: (context) => getIt<PetsManager>()),
        ChangeNotifierProvider(
          create: (context) => getIt<QuestionnaireManager>(),
        ),
        ChangeNotifierProvider(create: (context) => getIt<ProHomeVm>()),
        ChangeNotifierProvider(create: (context) => getIt<PaymentManager>()),
      ],
      child: Consumer(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [myRouteObserver],

            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Set the locale based on shared preferences or fallback to 'en'
            locale:
                Provider.of<StateManager>(context).locale ??
                Locale(
                  getIt<SharedPreferences>().getString(
                        StringConstants.language,
                      ) ??
                      'en',
                ),

            // Supported locales
            supportedLocales: const [Locale('en'), Locale('ml')],

            // Define named routes
            routes: {'/searchScreen': (context) => const SearchChooseScreen()},
            onGenerateRoute: Routers.generateRoute,
            navigatorKey: getIt<NavigationService>().navigatorkey,

            // // Initial screen of the app
            // home: BookingSuccessScreen(bookingSuccessData: BookingSaveResponseModel(status: true,bookingId: 34,appointmentId: "Dff",bookingType: "sds",clinicAddress: "fasfd af afa ",
            //     dateTime: DateTime.now().toString(),doctorName: "afafsdf",doctorProfessionalQualifications: "Sdsda",message: "sdagvsfd",
            //
            // ),),
            home: const SplashScreen(),

            // home: AudioPlayerScreen("https://file-examples.com/storage/fee47d30d267f6756977e34/2017/11/file_example_MP3_700KB.mp3"),
            title: label,
            theme: ThemeData(primarySwatch: Colors.blue),
          );
        },
      ),
    );
  }
}

// Observer to track navigation events
class MyRouteObserver extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    currentRoute = newRoute?.settings.name;
  }
}

// Widget to display custom error messages
class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50.0),
          const SizedBox(height: 10.0),
          const Text(
            'Error Occurred!',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
