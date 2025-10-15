// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/screens/pet_care_screens/pets_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/pets_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/pets__types_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../widgets/common_widgets.dart';

class PetCreationScreen extends StatefulWidget {
  const PetCreationScreen({super.key});

  @override
  State<PetCreationScreen> createState() => _PetCreationScreenState();
}

class _PetCreationScreenState extends State<PetCreationScreen> {
  @override
  void initState() {
    getIt<PetsManager>().getPetTypesList();
    super.initState();
  }

  final PageController _pageController = PageController();
  TextEditingController ageCntrlr = TextEditingController();
  TextEditingController nameCntrlr = TextEditingController();
  PetCreateData petData = PetCreateData();

  int _currentPage = 0;

  bool isSaving = false;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _savePetData() async {
    isSaving = true;
    if (mounted) setState(() {});
    var res = await getIt<PetsManager>().createPet(petData);

    if (res.status == true) {
      showTopSnackBar(
        snackBarPosition: SnackBarPosition.bottom,
        padding: const EdgeInsets.all(30),
        Overlay.of(context),
        ErrorToast(maxLines: 3, message: res.message ?? ""),
      );

      Navigator.pop(context, true);
    } else {
      showTopSnackBar(
        snackBarPosition: SnackBarPosition.bottom,
        padding: const EdgeInsets.all(30),
        Overlay.of(context),
        ErrorToast(maxLines: 3, message: res.message ?? ""),
      );
    }
    isSaving = false;
    if (mounted) setState(() {});
    // print("Collected Pet Data: $petData");
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text("Pet Data Saved"),
    //     content: const Text("Your pet's data has been collected successfully."),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: const Text("OK"),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetsManager>(
      builder: (context, mgr, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // title: Text("Create a Pet"),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close_rounded),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildNameScreen(),
              _buildGenderScreen(),
              _buildSpeciesScreen(mgr.petList),
              _buildAgeScreen(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameScreen() {
    return _buildScreen(
      title: "What's your pet's name?",
      child: TextField(
        controller: nameCntrlr,
        onChanged: (value) {
          petData.name = value;
          if (mounted) setState(() {});
        },
        decoration: const InputDecoration(
          labelText: "Pet Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        style: t500_14.copyWith(color: Colors.black),
      ),
    );
  }

  genderBox(String txt, IconData icon, {required Color color}) {
    return GestureDetector(
      onTap: () {
        setState(() => petData.gender = txt);
        // _nextPage();
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(.4),
          borderRadius: BorderRadius.circular(20),
          border: petData.gender == txt
              ? Border.all(color: color, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              Text(txt, style: t500_14.copyWith(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  getButton({
    required Function onPressed,
    required Color color,
    required String txt,
    Color? textColor,
  }) {
    bool isDisabled = false;
    if (_currentPage == 0 && (petData.name == "" || petData.name == null)) {
      isDisabled = true;
    } else if (_currentPage == 1 &&
        (petData.gender == "" || petData.gender == null)) {
      isDisabled = true;
    } else if (_currentPage == 2 && petData.speciesId == null) {
      isDisabled = true;
    } else if (_currentPage == 3 && (petData.dateOfBirth == null || isSaving)) {
      isDisabled = true;
    }
    return GestureDetector(
      onTap: isDisabled == true && txt != "Back"
          ? null
          : () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              onPressed();
            },
      child: Container(
        width: double.infinity,
        // width: 300,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDisabled == true && txt != "Back" ? Colors.grey : color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              txt,
              style: t500_16.copyWith(
                color: textColor ?? const Color(0xFF3B3EA8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderScreen() {
    return _buildScreen(
      title: "Select your pet's gender",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          genderBox("Male", Icons.male_rounded, color: Colors.blueAccent),
          genderBox("Female", Icons.female_rounded, color: Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _buildSpeciesScreen(List<PetList>? petList) {
    return petList != null
        ? _buildScreen(
            title: "Species",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3, // 3 columns
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio:
                      1, // Adjust aspect ratio for rectangular items
                  children: petList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => petData.speciesId = item.id);
                        if (item.breeds != null && item.breeds!.isNotEmpty) {
                          _showBreedPicker(item.breeds!);
                        } else {
                          petData.breedId = null; // clear previous breed
                          // _nextPage();
                        }
                      },
                      child: PetItem(
                        item,
                        isSelected: item.id == petData.speciesId,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        : petLoader;
  }

  void _showBreedPicker(List<Breed> breeds) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Breed",
                  style: t700_18.copyWith(color: Colors.black),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: breeds.length,
                  itemBuilder: (context, index) {
                    final breed = breeds[index];
                    final isSelected = breed.id == petData.breedId;

                    return ListTile(
                      title: Text(
                        breed.title ?? '',
                        style: t600_14.copyWith(color: Colors.black),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() => petData.breedId = breed.id);
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => Navigator.pop(context),
                        );
                        // Navigator.pop(context);
                        // _nextPage(); // if needed
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgeScreen() {
    return _buildScreen(
      title: "How old is your pet?",
      child: Column(
        children: [
          SizedBox(
            child: TextFormField(
              readOnly: true,
              onTap: () async {
                var tday = DateTime.now();
                ageCntrlr.text = ageCntrlr.text.isNotEmpty
                    ? ageCntrlr.text
                    : DateFormat('dd/MM/yyyy').format(tday);
                petData.dateOfBirth = ageCntrlr.text;
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Material(
                      color: Colors.white,
                      child: SizedBox(
                        height: 255,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Done",
                                    style: t700_16.copyWith(
                                      color: clr444444,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 220,
                              margin: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              padding: const EdgeInsets.only(top: 8.0),
                              color: Colors.white,
                              child: CupertinoDatePicker(
                                initialDateTime: ageCntrlr.text.isNotEmpty
                                    ? getIt<StateManager>()
                                              .convertStringToDDMMYYY(
                                                ageCntrlr.text,
                                              ) ??
                                          tday
                                    : tday,
                                maximumDate: tday,
                                minimumDate: DateTime(tday.year - 120),
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                // This is called when the user changes the time.
                                onDateTimeChanged: (DateTime newTime) {
                                  String formattedDate = DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(newTime);
                                  // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    ageCntrlr.text =
                                        formattedDate; //set output date to TextField value.
                                    petData.dateOfBirth = formattedDate;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                // var tday = DateTime.now();
                // DateTime? pickedDate = await showDatePicker(barrierColor: Colours.primaryblue,
                //     initialEntryMode: DatePickerEntryMode.calendarOnly,
                //     context: context,
                //     initialDate: DateTime(tday.year-20),
                //     firstDate: DateTime(tday.year-120),
                //     //DateTime.now() - not to allow to choose before today.
                //     lastDate: DateTime(tday.year-10));
                //
                // if (pickedDate != null) {
                //   print(
                //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                //   String formattedDate =
                //   DateFormat('dd/MM/yyyy').format(pickedDate);
                //   print(
                //       formattedDate); //formatted date output using intl package =>  2021-03-16
                //   setState(() {
                //     ageCntrlr.text =
                //         formattedDate; //set output date to TextField value.
                //   });
                //   FocusScopeNode currentFocus = FocusScope.of(context);
                //   if (!currentFocus.hasPrimaryFocus) {
                //     currentFocus.unfocus();
                //   }
                // } else {}
              },
              style: t400_16.copyWith(color: Colors.black),

              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: outLineBorder4,
                enabledBorder: outLineBorder4,
                focusedBorder: outLineBorder,
                filled: true,
                fillColor: Colours.boxblue,
                errorStyle: const TextStyle(fontSize: 0),
                hintText: 'Date of Birth',
                hintStyle: t400_14.copyWith(color: Colors.black54),
              ),

              // decoration: inputDec2(hnt: "Date of Birth"),
              controller: ageCntrlr,
              // keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScreen({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: t700_24.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          child,
          const Spacer(),
          if (_currentPage > 0)
            getButton(
              color: Colors.transparent,
              txt: "Back",
              onPressed: _prevPage,
            ),
          if (_currentPage < 3)
            getButton(
              color: const Color(0xFF3B3EA8),
              txt: "Continue",
              textColor: clrFFFFFF,
              onPressed: _nextPage,
            ),
          if (_currentPage == 3)
            getButton(
              color: Colors.amber,
              txt: "Save",
              onPressed: _savePetData,
            ),
        ],
      ),
    );
  }

  // Widget _speciesCard(PetList pet) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() => petData.speciesId = pet.id);
  //       _nextPage();
  //     },
  //     child: PetItem(pet),
  //   );
  // }
}

class PetCreateData {
  String? name;
  String? gender;
  int? speciesId;
  int? breedId;
  String? dateOfBirth;

  PetCreateData({
    this.name,
    this.gender,
    this.speciesId,
    this.breedId,
    this.dateOfBirth,
  });
}
