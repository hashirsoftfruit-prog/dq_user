import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;

import '../../controller/managers/state_manager.dart';
import '../../model/helper/service_locator.dart';

// to view image in full screen
class GalleryImageViewWrapper extends StatefulWidget {
  final Color? backgroundColor;
  final int? initialIndex;
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Function paginationFn;
  final double minScale;
  final double maxScale;
  final double radius;
  final bool reverse;
  final List<String> imageList;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;

  const GalleryImageViewWrapper({
    Key? key,
    required this.titleGallery,
    required this.backgroundColor,
    required this.initialIndex,
    required this.galleryItems,
    required this.imageList,
    required this.loadingWidget,
    required this.paginationFn,
    required this.errorWidget,
    required this.minScale,
    required this.maxScale,
    required this.radius,
    required this.reverse,
    required this.showListInGalley,
    required this.showAppBar,
    required this.closeWhenSwipeUp,
    required this.closeWhenSwipeDown,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageViewWrapperState();
  }
}

class _GalleryImageViewWrapperState extends State<GalleryImageViewWrapper> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex ?? 0,
  );
  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.toInt() ?? 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // getIt<StateManager>().setShareLoader(val: false,isDispose: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool  loader = Provider.of<StateManager>(context).shareLoader;
    bool loader = false;
    List<GalleryItemModel> galleryItems = widget.imageList.map((e) {
      var indxx = widget.imageList.indexOf(e);
      // print ('${getIt<StateManager>().generateRandomString()} $indxx ${e.imgName}');
      return GalleryItemModel(
        id: getIt<StateManager>().generateRandomString(),
        index: indxx,
        imageUrl: e,
      );
    }).toList();

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: Text(widget.titleGallery ?? "Gallery"))
          : null,
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (widget.closeWhenSwipeUp &&
                        details.primaryVelocity! < 0) {
                      //'up'
                      Navigator.of(context).pop();
                    }
                    if (widget.closeWhenSwipeDown &&
                        details.primaryVelocity! > 0) {
                      // 'down'
                      Navigator.of(context).pop();
                    }
                  },
                  child: PageView.builder(
                    reverse: widget.reverse,
                    controller: _controller,
                    itemCount: galleryItems.length,
                    itemBuilder: (context, index) =>
                        _buildImage(galleryItems[index], loader),
                  ),
                ),
              ),
              if (widget.showListInGalley)
                SizedBox(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: galleryItems.map((e) {
                        // var indx = galleryItems.indexOf(e);
                        return Row(children: [_buildLitImage(e)]);
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // build image with zooming
  Widget _buildImage(GalleryItemModel item, bool loader) {
    return Stack(
      children: [
        Hero(
          tag: item.id,
          child: InteractiveViewer(
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            child: Center(
              child: AppCachedNetworkImage(
                imageUrl: item.imageUrl,
                loadingWidget: widget.loadingWidget,
                errorWidget: widget.errorWidget,
                radius: widget.radius,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(top: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: loader == true
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white70),
                  )
                : IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  // build image with zooming
  Widget _buildLitImage(GalleryItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.jumpToPage(item.index);
          });
        },
        child: AppCachedNetworkImage(
          height: _currentPage == item.index ? 70 : 60,
          width: _currentPage == item.index ? 70 : 60,
          fit: BoxFit.cover,
          imageUrl: item.imageUrl,
          errorWidget: widget.errorWidget,
          radius: widget.radius,
          loadingWidget: widget.loadingWidget,
        ),
      ),
    );
  }
}

class GalleryItemModel {
  GalleryItemModel({
    required this.id,
    required this.imageUrl,
    required this.index,
  });
  // index in list of image
  final int index;
  // id image (image url) to use in hero animation
  final String id;
  // image url
  final String imageUrl;
}

class AppCachedNetworkImage extends StatelessWidget {
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;
  final String imageUrl;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.loadingWidget,
    this.errorWidget,
    this.fit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            loadingWidget ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:path/path.dart' as path;
// import 'package:flutter/material.dart';
// import 'package:infinite_carousel/infinite_carousel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:share_plus/share_plus.dart';
//
// import 'model/core/gllrymdl_model.dart';
//
// class GalleryImagest extends StatefulWidget {
//   final LoadingBuilder? loadingBuilder;
//   final BoxDecoration? backgroundDecoration;
//   final int initialIndex;
//   final List<GalleryItemModel> galleryItems;
//   final Axis scrollDirection;
//   final String? titleGallery;
//   final Icon iconBack;
//   final BoxFit fit;
//   final bool loop;
//   final bool activeCarouselList;
//
//   const GalleryImagest({
//     Key? key,
//     this.loadingBuilder,
//     this.titleGallery,
//     this.backgroundDecoration,
//     required this.initialIndex,
//     required this.galleryItems,
//     this.scrollDirection = Axis.horizontal,
//     required this.iconBack,
//     required this.fit,
//     required this.loop,
//     required this.activeCarouselList,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _GalleryImagestState();
//   }
// }
//
// class _GalleryImagestState extends State<GalleryImagest> {
//   final minScale = PhotoViewComputedScale.contained * 0.8;
//   final maxScale = PhotoViewComputedScale.covered * 8;
//
//   late PageController pageController;
//   late InfiniteScrollController _controller;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//
//
//     super.initState();
//     _controller = InfiniteScrollController(initialItem: widget.initialIndex);
//     pageController = PageController(initialPage: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   clickImage(int itemIndex) {
//     Navigator.pushReplacement(
//       context,
//       PageRouteBuilder(
//         transitionDuration: Duration.zero,
//         pageBuilder: (context, __, ___) => GalleryImagest(
//           titleGallery: widget.titleGallery,
//           galleryItems: widget.galleryItems,
//           backgroundDecoration: const BoxDecoration(
//             color: Colors.black,
//           ),
//           initialIndex: itemIndex,
//           scrollDirection: Axis.horizontal,
//           iconBack: widget.iconBack,
//           fit: widget.fit,
//           loop: widget.loop,
//           activeCarouselList: widget.activeCarouselList,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ProgressHUD(
//       child: Builder(
//         builder: (context) {
//           final progress = ProgressHUD.of(context);
//
//           return Scaffold(
//             body: Stack(
//               children: [
//                 Container(
//                   decoration: widget.backgroundDecoration,
//                   constraints: BoxConstraints.expand(
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   child: PhotoViewGallery.builder(
//                     scrollPhysics: const BouncingScrollPhysics(),
//                     builder: _buildImage,
//                     itemCount: widget.galleryItems.length,
//                     loadingBuilder: widget.loadingBuilder,
//                     backgroundDecoration: widget.backgroundDecoration,
//                     pageController: pageController,
//                     scrollDirection: widget.scrollDirection,
//                   ),
//                 ),
//                 SafeArea(bottom:false,
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Row(
//                         children: [
//                           Container(
//                               margin: const EdgeInsets.only(top: 5.0, left: 5.0),
//                               decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.4),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: widget.iconBack)),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 5.0, left: 20.0),
//                               child: Text(
//                                 widget.titleGallery ?? "",
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                           Container(
//                               margin: const EdgeInsets.only(top: 5.0, left: 5.0),
//                               decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.4),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: IconButton(
//                                   onPressed: ()async {
//                                     progress!.show();
//           var ur = widget.galleryItems[_selectedIndex].imageUrl;
//                                     final url = Uri.parse(ur);
//                                     final response = await http.get(url);
//                                     Directory docDir = await getApplicationDocumentsDirectory();
//                                     var fl = await File(path.join(docDir.path,path.basename(ur))).writeAsBytes(response.bodyBytes);
//           var xfl = XFile(fl.path);
//                                     await Share.shareXFiles([xfl], text:'');
//                                     progress.dismiss();
//                                   },
//                                   icon: Icon(Icons.share,color: Colors.white,)))
//                         ],
//                       )),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: SizedBox(
//                     height: 100,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: InfiniteCarousel.builder(
//                         itemCount: widget.galleryItems.length,
//                         itemExtent: 150,
//                         loop: widget.loop,
//                         controller: _controller,
//                         onIndexChanged: (index) {
//                           print("index changed");
//                           if (_selectedIndex != index) {
//                             setState(() => _selectedIndex = index);
//                           }
//                         },
//                         itemBuilder: (context, itemIndex, realIndex) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: GestureDetector(
//                                 onTap: () {
//                                   clickImage(itemIndex);
//                                 },
//                                 child: widget.activeCarouselList
//                                     ? ClipRRect(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(5)),
//                                   child:
//                                        CachedNetworkImage(
//                                     fit: widget.fit,
//                                     imageUrl: widget
//                                         .galleryItems[itemIndex].imageUrl,
//                                     placeholder: (context, url) =>
//                                     const Center(
//                                         child:
//                                         CircularProgressIndicator()),
//                                     errorWidget: (context, url, error) =>
//                                     const Icon(Icons.error),
//                                   ),
//                                 )
//                                     : const SizedBox()),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       ),
//     );
//   }
//
// // build image with zooming
//   PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
//     final GalleryItemModel item = widget.galleryItems[index];
//     return PhotoViewGalleryPageOptions.customChild(
//       child:CachedNetworkImage(
//         imageUrl: item.imageUrl,
//         placeholder: (context, url) =>
//         const Center(child: CircularProgressIndicator()),
//         errorWidget: (context, url, error) => const Icon(Icons.error),
//       ),
//       initialScale: PhotoViewComputedScale.contained,
//       minScale: minScale,
//       maxScale: maxScale,
//       heroAttributes: PhotoViewHeroAttributes(tag: item.id),
//     );
//   }
// }
