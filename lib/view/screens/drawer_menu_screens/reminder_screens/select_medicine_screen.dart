import 'dart:async';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../controller/managers/home_manager.dart';
import '../../../../model/core/search_medicine_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';

class SelectMedicine extends StatefulWidget {
  final String title;
  const SelectMedicine({super.key, required this.title});

  @override
  State<SelectMedicine> createState() => SelectMedicineState();
}

class SelectMedicineState extends State<SelectMedicine> {
  @override
  void initState() {
    // getIt<SearchManager>().refreshRecentSearches(null);
    super.initState();
  }

  @override
  void dispose() {
    // getIt<SearchManager>().disposeSearch();
    super.dispose();
  }

  Timer? _debounce;

  TextEditingController keyCntrl = TextEditingController();

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Make the API call here
      getIt<HomeManager>().searchMedicine(searchKey: query);
    });
  }

  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  @override
  Widget build(BuildContext context) {
    // const int specialityNType = 1;
    // const int symptomsNType = 2;
    // const int doctorNType = 3;
    // const int clinicNType = 4;
    var get = getIt<SmallWidgets>();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        floatBtn({required String title}) {
          return Padding(
            padding: EdgeInsets.all(w1p * 5),
            child: ButtonWidget(
              btnText: title,
              ontap: () {
                if (keyCntrl.text.trim().isNotEmpty) {
                  Navigator.pop(
                    context,
                    DrugItem(title: keyCntrl.text, id: null),
                  );
                } else {
                  showTopSnackBar(
                    snackBarPosition: SnackBarPosition.bottom,
                    Overlay.of(context),
                    const ErrorToast(
                      maxLines: 4,
                      message: "Reminder name should not be empty",
                    ),
                  );
                }
              },
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            List<DrugItem>? data = mgr.searchMedResults;

            return Scaffold(
              key: _key, // Assign the key to Scaffold.
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,

              appBar: get.appBarWidget(
                title: widget.title,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: Entry(
                yOffset: 500,
                // scale: 20,
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 900),
                curve: Curves.ease,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: SearchMedicine(
                              cntrolr: keyCntrl,
                              hnt: AppLocalizations.of(
                                context,
                              )!.enterReminderNameSearchMed,
                              clearFn: () {
                                keyCntrl.clear();
                                if (mounted) setState(() {});
                              },
                              searchFn: (val) {
                                // print(val);
                                if (val.length > 1) {
                                  onSearchChanged(val);
                                } else if (val.isEmpty) {
                                  mgr.searchMedResults = null;
                                }
                                if (mounted) setState(() {});
                              },
                            ),
                          ),

                          // get.searchBarBox(title: "Search ${widget.title}", height: h10p, width: w10p,),
                          verticalSpace(h1p),

                          // keyCntrl.text.isNotEmpty?GestureDetector(
                          //   onTap: (){
                          //     Navigator.pop(context,DrugItem(title: keyCntrl.text,id: null));
                          //   }
                          //   ,
                          //   child: Align(alignment: Alignment.centerLeft,
                          //     child: SizedBox(child: Padding(
                          //       padding: EdgeInsets.symmetric(vertical: 18,horizontal: w1p*4),
                          //       child: Text('Add \' ${keyCntrl.text} \'',style: TextStyles.textStyle32f,textAlign: TextAlign.center,),
                          //     )),
                          //   ),
                          // ):SizedBox(),
                          mgr.searchMedResults != null &&
                                  mgr.searchMedResults!.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   width: w10p * 10,
                                    //   decoration: BoxDecoration(color: Colours.lightBlu.withOpacity(0.5)),
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 8),
                                    //     child: Text(
                                    //       "Medicine",
                                    //       style: t500_14.copyWith(color: const Color(0xff474747)),
                                    //     ),
                                    //   ),
                                    // ),
                                    verticalSpace(h1p),
                                    SizedBox(
                                      width: maxWidth,
                                      child: Column(
                                        // semanticChildCount: 4,
                                        //   shrinkWrap: true,physics: NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.85,
                                        //   crossAxisCount: 4)
                                        //   // crossAxisCount: 4,
                                        //   ,
                                        children: List.generate(data!.length, (
                                          index,
                                        ) {
                                          String title =
                                              data[index].title ?? "";
                                          // int id = data[index].id!;

                                          // var subtitel = popSpecialites.subcategory![index].title;
                                          return InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(
                                                context,
                                                data[index],
                                              );
                                              // await fn(specialityId:id,specialityTitle:title,categoryId: null,type: specialityNType,subSpecialityId: null );
                                            },
                                            child: SearchMedItem(
                                              w1p: w1p,
                                              h1p: h1p,
                                              title: title,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ]),

                        //    pad(horizontal: w1p*6,
                        //   child:   mgr.onlineCatLoader?CircularProgressIndicator():ListView(
                        //
                        //     children: [
                        //
                        //
                        //     ],
                        //
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: keyCntrl.text.trim().isEmpty
                  ? null
                  : floatBtn(title: "Proceed"),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          },
        );
      },
    );
  }
}

class SearchMedItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String title;
  const SearchMedItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Container(
            // height: h1p*9,
            // decoration: BoxDecoration(boxShadow: [boxShadow5],
            // color: Colours.appointBoxClr,
            color: Colors.white,
            // borderRadius: BorderRadius.circular(containerRadius/2)
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: w1p * 6,
                    ),
                    child: Text(
                      title,
                      style: t400_14.copyWith(color: clr444444, height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(
                  color: Colours.lightBlu,
                  endIndent: 0,
                  indent: 0,
                  height: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchMedicine extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String hnt;
  final TextEditingController cntrolr;
  final Function(String val) searchFn;
  final Function() clearFn;
  const SearchMedicine({
    super.key,
    // required this.h1p,
    // required this.w1p,
    required this.hnt,
    required this.cntrolr,
    required this.searchFn,
    required this.clearFn,
  });

  @override
  Widget build(BuildContext context) {
    var outLineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(width: 1, color: clr2D2D2D.withAlpha(140)),
    );

    InputDecoration inputDec4({required String hnt, bool? isEmpty}) {
      return InputDecoration(
        suffixIcon: InkWell(
          onTap: clearFn,
          child: const Icon(Icons.close, color: Colors.grey, size: 20),
        ),
        contentPadding: const EdgeInsets.only(left: 16),
        border: outLineBorder,
        enabledBorder: outLineBorder,
        focusedBorder: outLineBorder,
        filled: true,
        hintStyle: t400_13.copyWith(color: const Color(0xff474747)),
        hintText: hnt,
        fillColor: isEmpty == true ? Colours.lightBlu : Colors.transparent,
        errorStyle: const TextStyle(fontSize: 0),
      );
    }

    return TextFormField(
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      controller: cntrolr,
      onChanged: (val) {
        searchFn(val);
      },
      decoration: inputDec4(isEmpty: cntrolr.text.isEmpty, hnt: hnt),
      style: t500_14.copyWith(color: const Color(0xFF1E1E1E), height: 1),
      // validator: (v) => v!.trim().isEmpty?null:getIt<StateManager>().validateFieldValues(v,type),
    );
  }
}
