import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/pets_manager.dart';
import '../../../model/core/pet_groomer_details_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class GroomerDetailsScreen extends StatefulWidget {
  final int groomerId;
  const GroomerDetailsScreen({super.key, required this.groomerId});

  @override
  State<GroomerDetailsScreen> createState() => _GroomerDetailsScreenState();
}

class _GroomerDetailsScreenState extends State<GroomerDetailsScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getIt<PetsManager>().getPetGroomerDetails(widget.groomerId);
    super.initState();
  }

  @override
  void dispose() {
    getIt<PetsManager>().groomerDetailsDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = 80;
    BoxDecoration bxDec = BoxDecoration(
      color: const Color(0xffFFEBBB),
      borderRadius: BorderRadius.circular(10),
    );

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Brightness.dark,
    //     statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark// Status bar color
    // ));
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Widget cachedImg(String img) {
          return CachedNetworkImage(
            fit: BoxFit.cover,
            // fit: widget.fit,
            imageUrl: StringConstants.baseUrl + img,
            placeholder: (context, url) => Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/images/pet-dog-icon-placeholder-temp.png",
              ),
            ),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/pet-dog-icon-placeholder-temp.png"),
          );
        }

        title(String title) {
          return Padding(
            padding: EdgeInsets.only(
              left: w1p * 5,
              top: h1p * 1.5,
              bottom: h1p,
            ),
            child: Text(title, style: TextStyles.petTxt20),
          );
        }

        return Consumer<PetsManager>(
          builder: (context, mgr, child) {
            GroomerDetails? data = mgr.petGroomerDetails;
            String mapUrl =
                "https://image.maps.ls.hereapi.com/mia/1.6/mapview"
                "?apiKey=${StringConstants.hereMapApiKey}"
                "&lat=${data?.latitude ?? '27.173891'}"
                "&lon=${data?.longitude ?? '78.042068'}"
                "&z=14"
                "&w=600"
                "&h=400";

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: "",
                  height: h10p * 0.8,
                  width: w10p * 0.8,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: SingleChildScrollView(
                  child: data != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: maxWidth,
                              margin: EdgeInsets.symmetric(horizontal: w1p * 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [boxShadow9],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                  vertical: h1p * 2,
                                ),
                                child: SizedBox(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: SizedBox(
                                          width: size,
                                          height: size,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            // fit: widget.fit,
                                            imageUrl:
                                                '${StringConstants.baseUrl}${data.logo}',
                                            placeholder: (context, url) =>
                                                const SizedBox(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const SizedBox(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data.name ?? "",
                                        style: TextStyles.petTxt18,
                                      ),
                                      Text(
                                        data.address1 ?? data.address2 ?? "",
                                        style: TextStyles.petTxt19,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            data.groomingPets != null &&
                                    data.groomingPets!.isNotEmpty
                                ? title(
                                    AppLocalizations.of(
                                      context,
                                    )!.whoWeAreHelping,
                                  )
                                : const SizedBox(),
                            data.groomingPets != null &&
                                    data.groomingPets!.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 4,
                                      vertical: h1p * 1,
                                    ),
                                    child: SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: data.groomingPets!
                                              .map(
                                                (e) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8.0,
                                                      ),
                                                  child: SizedBox(
                                                    width: 50,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          child: cachedImg(
                                                            e.petIcon ?? "",
                                                          ),
                                                        ),
                                                        verticalSpace(8),
                                                        Text(
                                                          e.pet ?? "",
                                                          style: TextStyles
                                                              .petTxt21,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            title(AppLocalizations.of(context)!.timing),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: bxDec,

                                      // margin: EdgeInsets.symmetric(horizontal:w1p*4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Grooming Centre",
                                              style: t500_14.copyWith(
                                                color: clr444444,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/icon-time2.svg",
                                                ),
                                                horizontalSpace(4),
                                                Text(
                                                  "10.00 AM - 5.00 PM",
                                                  style: TextStyles.petTxt17,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(
                                    data.hasHomeService == true ? 8 : 0,
                                  ),
                                  data.hasHomeService == true
                                      ? Expanded(
                                          child: Container(
                                            decoration: bxDec,

                                            // margin: EdgeInsets.only(left:w1p*2),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Home Visit",
                                                    style: t500_14.copyWith(
                                                      color: clr444444,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/icon-time2.svg",
                                                      ),
                                                      horizontalSpace(4),
                                                      Text(
                                                        "10.00 AM - 5.00 PM",
                                                        style:
                                                            TextStyles.petTxt17,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            data.services != null && data.services!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      title(
                                        AppLocalizations.of(
                                          context,
                                        )!.serviceWeProvide,
                                      ),
                                      Container(
                                        width: maxWidth,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: w1p * 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [boxShadow9],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 4,
                                            vertical: h1p * 2,
                                          ),
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: data.services!
                                                  .map(
                                                    (e) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8.0,
                                                          ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/pet-icon-tick.svg",
                                                          ),
                                                          horizontalSpace(8),
                                                          Text(
                                                            e,
                                                            style: TextStyles
                                                                .petTxt21,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            title(AppLocalizations.of(context)!.location),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4,
                              ),
                              child: SizedBox(
                                width: maxWidth,
                                height: 200,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  // fit: widget.fit,
                                  imageUrl: mapUrl,
                                  placeholder: (context, url) =>
                                      const SizedBox(),
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(),
                                ),
                              ),
                            ),
                            verticalSpace(h10p),
                          ],
                        )
                      : petLoader,
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: maxWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xffFFAE00), Color(0xffFFD166)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.contactNow,
                        style: TextStyles.petTxt22,
                      ),
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
              ),
            );
          },
        );
      },
    );
  }
}
