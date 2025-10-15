import 'package:avatar_glow/avatar_glow.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

import '../../controller/managers/booking_manager.dart';
import '../../model/helper/service_locator.dart';

class AnatomyScreen extends StatefulWidget {
  final int bookingId;
  final double? leftPoint;
  final double? topPoint;

  const AnatomyScreen({
    super.key,
    required this.bookingId,
    this.leftPoint,
    this.topPoint,
  });
  @override
  State<AnatomyScreen> createState() => _AnatomyScreenState();
}

class _AnatomyScreenState extends State<AnatomyScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.leftPoint != null && widget.topPoint != null) {
      _zoomToPoint(Offset(widget.leftPoint!, widget.topPoint!), 4);
    } else {
      _zoomToPoint(const Offset(0, 0), 1.5);
    }
  }

  // double _angleX = 0;
  // double _angleY = 0;

  final flipCntrlr = FlipCardController();

  final TransformationController _controller = TransformationController();

  // Dimensions for positioning the clickable regions
  double w = 400; // Replace with your actual width
  double h = 800; // Replace with your actual height

  // Function to zoom to a specific point
  void _zoomToPoint(Offset focalPoint, double scale) {
    setState(() {
      final Matrix4 zoomMatrix = Matrix4.identity()
        ..translate(-focalPoint.dx * (scale - 1), -focalPoint.dy * (scale - 1))
        ..scale(scale);

      _controller.value = zoomMatrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool? isShowSmallPoints = Provider.of<BookingManager>(
      context,
    ).showSmallPoints;
    String? selectedId = Provider.of<BookingManager>(
      context,
    ).selectedPositionId;

    var w1p = MediaQuery.of(context).size.width * 0.01;

    double w = 3 * w1p * 25;
    double h = 5 * w1p * 25;

    getPositionWid({
      required double top,
      required double left,
      required bool? visible,
    }) {
      return Visibility(
        visible: visible != true,
        child: Positioned(
          // width:13,height:13,
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () {
              _zoomToPoint(
                Offset(left, top),
                4.0,
              ); // Zoom to the specific region with scale 3.0
              getIt<BookingManager>().setShowSmallPoints(true);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DetailedView(
              //       partName: "Head",
              //       imagePath: "assets/head.png", // Detailed head image
              //     ),
              //   ),
              // );
            },
            child: AvatarGlow(
              glowRadiusFactor: 1,
              glowColor: Colors.red,

              // repeat:false,
              animate: true,
              // endRadius: 60.0,
              // strokeLinearGradient: const LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [Colors.white,Colors.black]
              // ),
              // baseDecoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   gradient: const LinearGradient(
              //       begin: Alignment.topRight,
              //       end: Alignment.bottomLeft,
              //       colors: [Colors.lightBlueAccent,Colors.teal]
              //   ),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    getSmallPositionWid({
      required double top,
      required double left,
      required bool? visible,
      required String? positionId,
    }) {
      return Visibility(
        visible: visible == true || selectedId == positionId,
        child: Positioned(
          // width:13,height:13,
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () async {
              getIt<BookingManager>().setSelectedSmallPoints(positionId);
              await getIt<BookingManager>().shareAnatomyPoint(
                point: positionId,
                bookingId: widget.bookingId,
              );
            },
            child: AvatarGlow(
              glowRadiusFactor: 1,
              glowColor: selectedId == positionId
                  ? Colors.green
                  : Colors.transparent,
              animate: selectedId == positionId ? true : false,
              glowCount: selectedId == positionId ? 2 : 0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      positionId ?? "",
                      style: TextStyles.textStyleAnatomy1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    btnWidget({required String title}) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffEB0000).withOpacity(0.4),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffFFF9F9),
            boxShadow: [boxShadow9red],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Center(
              child: Text(title, style: TextStyles.textStyleAnatomy2),
            ),
          ),
        ),
      );
    }

    getCard(img, {required List<Widget> points}) {
      return
      // Row(mainAxisAlignment:MainAxisAlignment.center,
      // children: [
      // Expanded(
      //   child: SizedBox(
      //     child: Entry(
      //       xOffset: -25,opacity: 0.5,
      //       // scale: 20,
      //       delay: const Duration(milliseconds: 100),
      //       duration: const Duration(milliseconds: 1000),
      //       curve: Curves.ease,
      //       child: Column(mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children:[
      //             btnWidget(title: "Head"),
      //             btnWidget(title: "Upper Body"),
      //             btnWidget(title: "Lower Body"),
      //             btnWidget(title: "Hand"),
      //             btnWidget(title: "Leg"),
      //
      //       ]),
      //     ),
      //   ),
      // ),
      Entry(
        xOffset: 25,
        opacity: 0.5,
        // scale: 20,
        delay: const Duration(milliseconds: 100),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.ease,
        child: SizedBox(
          height: h,
          width: w1p * 100,
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,

            onInteractionUpdate: (sds) {
              double currentScale = _controller.value.getMaxScaleOnAxis();

              if (currentScale > 2.5 && isShowSmallPoints != true) {
                getIt<BookingManager>().setShowSmallPoints(true);
              } else if (currentScale <= 2.5 && isShowSmallPoints != false) {
                getIt<BookingManager>().setShowSmallPoints(false);
              }
            },
            transformationController: _controller,
            // boundaryMargin: EdgeInsets.all(20.0),
            minScale: 1.0,
            maxScale: 4.0, // Adjust the zoom level as needed
            child: Stack(
              children: [
                // Main Anatomy Image
                Image.asset(
                  cacheWidth: w.round() * 4,
                  cacheHeight: h.round() * 4,
                  img, // Replace with your anatomy image
                  fit: BoxFit.contain,
                ),

                ...points,

                // Clickable Head Region

                // Add other regions (e.g., torso, arms) similarly...
              ],
            ),
          ),
        ),
      )
      //   ],
      // )
      ;
    }

    List<PositionModel> mainPoints = [
      PositionModel(
        id: "A1",
        top: h * 0.04,
        left: w * 0.42,
        visible: isShowSmallPoints,
      ),
      PositionModel(
        id: "A2",
        top: h * 0.20,
        left: w * 0.54,
        visible: isShowSmallPoints,
      ),
      PositionModel(
        id: "A3",
        top: h * 0.25,
        left: w * 0.27,
        visible: isShowSmallPoints,
      ),
      PositionModel(
        id: "A4",
        top: h * 0.35,
        left: w * 0.40,
        visible: isShowSmallPoints,
      ),
      PositionModel(
        id: "A5",
        top: h * 0.50,
        left: w * 0.40,
        visible: isShowSmallPoints,
      ),
    ];

    List<PositionModel> smallPoints = [
      PositionModel(
        id: "B1",
        top: h * 0.05,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B2",
        top: h * 0.08,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B3",
        top: h * 0.08,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B4",
        top: h * 0.1,
        left: w * 0.42,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B6",
        top: h * 0.2,
        left: w * 0.49,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B7",
        top: h * 0.3,
        left: w * 0.5,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B8",
        top: h * 0.3,
        left: w * 0.55,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B9",
        top: h * 0.25,
        left: w * 0.29,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "B10",
        top: h * 0.33,
        left: w * 0.25,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "B11",
        top: h * 0.44,
        left: w * 0.14,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "B12",
        top: h * 0.64,
        left: w * 0.55,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B13",
        top: h * 0.4,
        left: w * 0.42,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "B14",
        top: h * 0.50,
        left: w * 0.40,
        visible: isShowSmallPoints,
      ), //leg
      PositionModel(
        id: "B15",
        top: h * 0.55,
        left: w * 0.43,
        visible: isShowSmallPoints,
      ), //leg
    ];

    List<PositionModel> smallBackPoints = [
      PositionModel(
        id: "C1",
        top: h * 0.05,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C2",
        top: h * 0.08,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C3",
        top: h * 0.08,
        left: w * 0.50,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C6",
        top: h * 0.2,
        left: w * 0.49,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C7",
        top: h * 0.3,
        left: w * 0.5,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C8",
        top: h * 0.3,
        left: w * 0.55,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C9",
        top: h * 0.25,
        left: w * 0.29,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "C10",
        top: h * 0.33,
        left: w * 0.25,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "C11",
        top: h * 0.44,
        left: w * 0.14,
        visible: isShowSmallPoints,
      ), //hand
      PositionModel(
        id: "C12",
        top: h * 0.64,
        left: w * 0.55,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C13",
        top: h * 0.4,
        left: w * 0.42,
        visible: isShowSmallPoints,
      ), //head
      PositionModel(
        id: "C14",
        top: h * 0.50,
        left: w * 0.40,
        visible: isShowSmallPoints,
      ), //leg
      PositionModel(
        id: "C15",
        top: h * 0.55,
        left: w * 0.43,
        visible: isShowSmallPoints,
      ), //leg
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.close_rounded),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: w1p * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Entry(
              xOffset: -25,
              opacity: 0.2,
              // scale: 20,
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.ease,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Which area would you like to focus?",
                  style: t700_20.copyWith(color: clr444444),
                ),
              ),
            ),
            FlipCard(
              rotateSide: RotateSide.left,
              // onTapFlipping: true, //When enabled, the card will flip automatically when touched.
              axis: FlipAxis.vertical,

              // Front side of human body
              frontWidget: getCard(
                'assets/images/human-body-frontal.jpg',
                points: [
                  ...mainPoints
                      .map(
                        (e) => getPositionWid(
                          visible: e.visible,
                          left: e.left,
                          top: e.top,
                        ),
                      )
                      .toList(),
                  ...smallPoints
                      .map(
                        (e) => getSmallPositionWid(
                          positionId: e.id,
                          visible: e.visible,
                          left: e.left,
                          top: e.top,
                        ),
                      )
                      .toList(),
                ],
              ),

              // Back side of human body
              backWidget: getCard(
                'assets/images/human-body-back.jpg',
                points: [
                  ...mainPoints
                      .map(
                        (e) => getPositionWid(
                          visible: e.visible,
                          left: e.left,
                          top: e.top,
                        ),
                      )
                      .toList(),
                  ...smallBackPoints
                      .map(
                        (e) => getSmallPositionWid(
                          positionId: e.id,
                          visible: e.visible,
                          left: e.left,
                          top: e.top,
                        ),
                      )
                      .toList(),
                  // ...smallPoints.map((e) => getSmallPositionWid(positionId: e.id, visible: e.visible, left: e.left, top: e.top)).toList(),
                ],
              ),
              controller: flipCntrlr,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () {
          flipCntrlr.flipcard();
        },
        child: btnWidget(
          title: flipCntrlr.state?.isFront == false ? "Turn Body" : "Turn Body",
        ),
      ),
    );
  }
}

class DetailedView extends StatelessWidget {
  final String partName;
  final String imagePath;

  const DetailedView({
    super.key,
    required this.partName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$partName Details")),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 1.0,
        maxScale: 4.0,
        child: const Stack(
          children: [
            // Detailed Part Image
            ModelViewer(
              src:
                  'assets/models/11091_FemaleHead_v4.obj', // Ensure the model is in your assets
              // autoRotate: true,
              cameraControls: true,
            ),

            // Clickable Points on the Detailed Image
            // Positioned(
            //   top: 100,
            //   left: 120,
            //   child: GestureDetector(
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: Text("Point of Interest"),
            //           content: Text("You tapped on a specific area of the $partName."),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.pop(context),
            //               child: Text("OK"),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //     child: Icon(
            //       Icons.location_on,
            //       color: Colors.red,
            //       size: 24.0,
            //     ),
            //   ),
            // ),

            // Add more points for the detailed view as needed...
          ],
        ),
      ),
    );
  }
}

class PositionModel {
  String id;
  // String? label;
  double top;
  double left;
  bool? visible;

  PositionModel({
    required this.id,
    // this.label,
    required this.top,
    required this.left,
    this.visible,
  });

  // PositionModel.fromJson(Map<String, dynamic> json) {
  //   label = json['label'];
  //   top = json['top'];
  //   left = json['left'];
  //   visible = json['visible'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   // data['label'] = this.label;
  //   data['top'] = this.top;
  //   data['left'] = this.left;
  //   data['visible'] = this.visible;
  //   return data;
  // }
}
