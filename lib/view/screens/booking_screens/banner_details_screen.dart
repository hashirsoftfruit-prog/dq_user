import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/core/banners_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';

class BannerDetailsScreen extends StatefulWidget {
  final BannerList banner;
  // double ma
  const BannerDetailsScreen({super.key, required this.banner});

  @override
  State<BannerDetailsScreen> createState() => _BannerDetailsScreenScreenState();
}

class _BannerDetailsScreenScreenState extends State<BannerDetailsScreen> {
  @override
  void dispose() {
    getIt<BookingManager>().disposePatientsUnderPackage();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    return Consumer<BookingManager>(
      builder: (context, mgr, child) {
        return Scaffold(
          appBar: getIt<SmallWidgets>().appBarWidget(
            title: 'Offer Details',
            height: h10p,
            width: w10p,
            fn: () {
              Navigator.pop(context);
            },
          ),
          body: Container(
            color: Colors.white,
            child: Stack(
              children: [
                pad(
                  horizontal: w1p * 4,
                  child: ListView(
                    children: [
                      Text(
                        widget.banner.title ?? "",
                        style: t500_18.copyWith(color: clr2D2D2D),
                      ),
                      verticalSpace(8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colours.grad1, Colours.primaryblue],
                            ),
                            borderRadius: BorderRadius.circular(
                              containerRadius / 2,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 2 / 1,
                            child: SmallWidgets().cachedImg(
                              widget.banner.image ?? "",
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(h1p * 2),
                      pad(
                        horizontal: w1p * 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(8),
                            Text(
                              widget.banner.subtitle ?? "",
                              style: t400_16.copyWith(color: clr2D2D2D),
                            ),
                            verticalSpace(8),
                            Text(
                              widget.banner.description ?? "",
                              style: t400_16.copyWith(color: clr2D2D2D),
                            ),
                            verticalSpace(24),
                          ],
                        ),
                      ),
                      verticalSpace(h1p),
                      const Divider(color: Colours.lightBlu),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: pad(
            vertical: h1p * 2,
            horizontal: 18,
            child: ButtonWidget(
              btnText: 'Close',
              ontap: () async {
                // if(mgr.patientsUnderPackage.isEmpty){
                Navigator.pop(context);

                // }
              },
            ),
          ),
        );
      },
    );
  }
}
