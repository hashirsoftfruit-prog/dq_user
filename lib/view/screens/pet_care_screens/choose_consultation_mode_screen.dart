import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import '../../theme/constants.dart';
import 'my_pets_list_screen.dart';

class ConsutationModeChooseScreen extends StatelessWidget {
  const ConsutationModeChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
// var selectedPet = Provider.of<PetsManager>(context).selectedPet;
// var packagesList = Provider.of<BookingManager>(context).allPackages;
// var packageBillModel = Provider.of<BookingManager>(context).packageBillModel;
// var couponAppliedBillModel = Provider.of<BookingManager>(context).couponAppliedBillModel;
// var billModel = Provider.of<BookingManager>(context).billModel;

    // removePkgFn() async {
    //   getIt<BookingManager>().setSelectedPackage(null);
    //   getIt<BookingManager>().setLoaderActive(true);
    //   await Future.delayed(Duration(milliseconds: 500), () {
    //     getIt<BookingManager>().setLoaderActive(false);
    //   });
    // }

    // String username = getIt<SharedPreferences>().getString(StringConstants.userName)??"";
    // int? userId = getIt<SharedPreferences>().getInt(StringConstants.userId);
    // var locale = AppLocalizations.of(context);

// List<String> langs = ["English","Malayalam"];
// List<String> genderPrefs = [StringConstants.dPrefNoPref,  StringConstants.dPrefMale,  StringConstants.dPrefFemale,];

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        // double maxHeight = constraints.maxHeight;
        // double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        // double w1p = maxWidth * 0.01;

        return Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.white,
            body: Entry(
              yOffset: -500,
              // scale: 20,
              delay: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.ease,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MyPetsListScreen(
                                            isScheduledBooking: false,
                                          )));
                            },
                            child: Container(
                              width: 400,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadow1]),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Center(child: Text("Instant consult")),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MyPetsListScreen(
                                          isScheduledBooking: true)));
                            },
                            child: Container(
                              width: 400,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadow1]),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Center(child: Text("Schedule booking")),
                              ),
                            )),
                      )
                    ]),
              ),
            ));
      }),
    );
  }
}
