import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/pets_manager.dart';
import '../../../model/core/pets__types_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class PetsListScreen extends StatefulWidget {
  const PetsListScreen({Key? key}) : super(key: key);

  @override
  State<PetsListScreen> createState() => _PetsListScreenState();
}

class _PetsListScreenState extends State<PetsListScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getIt<PetsManager>().getPetTypesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Consumer<PetsManager>(
          builder: (context, mgr, child) {
            return SafeArea(
              child: Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.forYour,
                  height: h10p * 0.8,
                  width: w10p * 0.8,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: ListView(
                  children: [
                    // Padding(
                    //     padding:  EdgeInsets.symmetric(horizontal: w1p*4),
                    //     child: Text(,style: TextStyles.petTxt6,)),
                    mgr.petList != null && mgr.petList!.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: SizedBox(
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 3, // 3 columns
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 0.0,
                                childAspectRatio:
                                    1, // Adjust aspect ratio for rectangular items
                                children: mgr.petList!.map((item) {
                                  return PetItem(item);
                                }).toList(),
                              ),
                            ),
                          )
                        : petLoader,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PetItem extends StatelessWidget {
  final PetList item;
  final bool? isSelected;
  const PetItem(this.item, {super.key, this.isSelected});

  @override
  Widget build(BuildContext context) {
    // double size = 1;
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [boxShadow7],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                // fit: widget.fit,
                imageUrl: '${StringConstants.baseUrl}${item.image}',
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.black54),
              ),
            ),
            // Container(
            //   // width: 50,height: 50,
            //   // height: size,width: size ,
            //   decoration:BoxDecoration(image: DecorationImage(image: NetworkImage())
            // //       border: Border.all(
            // //   color: Color(0xffFF6F61)
            // //
            // // )
            //   ),child: Image.network(,fit: BoxFit.fitWidth,),
            //  ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            if (isSelected ?? false)
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                child: const Icon(Icons.check, size: 30, color: Colors.white),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.name ?? "",
                  style: t500_12.copyWith(color: const Color(0xffffffff)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
