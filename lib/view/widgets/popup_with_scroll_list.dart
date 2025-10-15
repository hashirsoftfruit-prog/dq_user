import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'common_widgets.dart';

class TextFieldPop extends StatelessWidget {
  final bool? isEmail;
  final String? value;
  final Function(String val) fn;
  const TextFieldPop({
    super.key,
    required this.fn,
    required this.value,
    this.isEmail,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    bool isValidEmail(String email) {
      // Define a regular expression pattern for a valid email
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      // Create a RegExp object
      RegExp regex = RegExp(pattern);
      // Return true if the email matches the pattern, false otherwise
      return regex.hasMatch(email);
    }

    var txtCntrlr = TextEditingController(text: value ?? "");

    return AlertDialog(
      // backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: SizedBox(
              height: 50,
              child: TextFormField(
                controller: txtCntrlr,
                validator: isEmail == true
                    ? (v) => v!.trim().isEmpty
                          ? null
                          : isValidEmail(v) == true
                          ? null
                          : "email not valid"
                    : null,
                autofocus: true,
                decoration: inputDec2(hnt: "sds"),
              ),
            ),
          ),
          verticalSpace(8),
          InkWell(
            onTap: () {
              bool validate = true;
              if (isEmail == true) {
                validate = formKey.currentState!.validate();
              }

              if (validate == true) {
                fn(txtCntrlr.text);
                Navigator.pop(context);
              } else if (isEmail == true) {
                showTopSnackBar(
                  snackBarPosition: SnackBarPosition.bottom,
                  padding: const EdgeInsets.all(30),
                  Overlay.of(context),
                  const ErrorToast(maxLines: 2, message: "Email is not valid"),
                );
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colours.primaryblue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Text(
                          "Done",
                          style: t400_16.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollPopUp extends StatefulWidget {
  final List<String> lst;
  final int itemIndex;
  final String? measur;
  final Function(String val) fn;
  const ScrollPopUp({
    super.key,
    required this.itemIndex,
    this.measur,
    required this.lst,
    required this.fn,
  });

  @override
  State<ScrollPopUp> createState() => _ScrollPopUpState();
}

class _ScrollPopUpState extends State<ScrollPopUp> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    String ext = widget.measur ?? "";
    // var lst =["Male","Female","Other"];
    final secondsWheel = WheelPickerController(
      itemCount: widget.lst.length,
      initialIndex: widget.itemIndex,
    );
    const textStyle = TextStyle(fontSize: 18.0, height: 1.5);

    // Timer.periodic(const Duration(seconds: 1), (_) => secondsWheel.shiftDown());

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: WheelPicker(
            builder: (context, index) => Text(
              '${widget.lst[index]} $ext',
              style: t500_16.copyWith(color: clr444444),
            ),
            controller: secondsWheel,
            selectedIndexColor: Colours.primaryblue,
            looping: false,
            onIndexChanged: (index, _) {
              setState(() {
                selected = widget.lst[index];
              });
            },
            style: WheelPickerStyle(
              // height: 300,
              itemExtent:
                  t500_16.copyWith(color: clr444444).fontSize! *
                  textStyle.height!, // Text height
              squeeze: 1.25,
              diameterRatio: .8,
              surroundingOpacity: .25,
              magnification: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 8,
          child: InkWell(
            onTap: () {
              if (selected != null) {
                widget.fn(selected!);
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
              child: Text("Done", style: t400_16.copyWith(color: clr444444)),
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollPopUpWith2Value extends StatefulWidget {
  final List<String> lst;
  final List<String> lst2;
  final int itemIndex;
  final int itemIndex2;
  final String? measur;
  final Function(String val) fn;
  const ScrollPopUpWith2Value({
    super.key,
    required this.itemIndex,
    required this.itemIndex2,
    this.measur,
    required this.lst,
    required this.lst2,
    required this.fn,
  });

  @override
  State<ScrollPopUpWith2Value> createState() => _ScrollPopUp2State();
}

class _ScrollPopUp2State extends State<ScrollPopUpWith2Value> {
  String? selectedFirstValue;
  String? selectedSecnd2;

  @override
  Widget build(BuildContext context) {
    String ext = widget.measur ?? "";
    // var lst =["Male","Female","Other"];
    final wheelControllr = WheelPickerController(
      itemCount: widget.lst.length,
      initialIndex: widget.itemIndex,
    );
    final wheelControllr2 = WheelPickerController(
      itemCount: widget.lst2.length,
      initialIndex: widget.itemIndex2,
    );
    const textStyle = TextStyle(fontSize: 18.0, height: 1.5);

    // Timer.periodic(const Duration(seconds: 1), (_) => secondsWheel.shiftDown());

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: WheelPicker(
                  builder: (context, index) => Text(
                    '${widget.lst[index]} $ext',
                    style: t500_16.copyWith(color: clr444444),
                  ),
                  controller: wheelControllr,
                  selectedIndexColor: Colours.primaryblue,
                  looping: false,
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedFirstValue = widget.lst[index];
                    });
                  },
                  style: WheelPickerStyle(
                    // height: 300,
                    itemExtent:
                        t500_16.copyWith(color: clr444444).fontSize! *
                        textStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: WheelPicker(
                  builder: (context, index) => Text(
                    '${widget.lst2[index]} $ext',
                    style: t500_16.copyWith(color: clr444444),
                  ),
                  controller: wheelControllr2,
                  selectedIndexColor: Colours.primaryblue,
                  looping: false,
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedSecnd2 = widget.lst2[index];
                    });
                  },
                  style: WheelPickerStyle(
                    // height: 300,
                    itemExtent:
                        t500_16.copyWith(color: clr444444).fontSize! *
                        textStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 8,
          child: InkWell(
            onTap: () {
              if (selectedFirstValue != null || selectedSecnd2 != null) {
                widget.fn(
                  '${selectedFirstValue ?? widget.lst[widget.itemIndex]}/${selectedSecnd2 ?? widget.lst2[widget.itemIndex2]}',
                );
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
              child: Text("Done", style: t400_16.copyWith(color: clr444444)),
            ),
          ),
        ),
      ],
    );
  }
}
