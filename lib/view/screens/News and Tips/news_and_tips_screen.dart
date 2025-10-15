import 'package:dqapp/controller/services/share_service.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/model/helper/service_locator.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsAndTipsScreen extends StatefulWidget {
  // final String type;
  final dynamic item; // can hold either News or Tip

  const NewsAndTipsScreen._internal({required this.item});

  // Factory constructor decides which type of screen to return
  factory NewsAndTipsScreen.news(News news) {
    return NewsAndTipsScreen._internal(item: news);
  }

  factory NewsAndTipsScreen.tip(Tip tip) {
    return NewsAndTipsScreen._internal(item: tip);
  }

  @override
  State<NewsAndTipsScreen> createState() => _NewsAndTipsScreenState();
}

class _NewsAndTipsScreenState extends State<NewsAndTipsScreen> {
  late final dynamic item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  String get imageUrl => "${StringConstants.baseUrl}${item?.image ?? ''}";

  String get authorImageUrl =>
      "${StringConstants.baseUrl}${item?.authorImage ?? ''}";

  @override
  Widget build(BuildContext context) {
    return Entry(
      delay: const Duration(milliseconds: 0),
      duration: const Duration(milliseconds: 1000),
      yOffset: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: getIt<SmallWidgets>().appBarWidget(
              title: "${widget.item is News ? "News" : "Tip"} Detail",
              height: constraints.maxHeight * 0.1,
              width: constraints.maxWidth * 0.1,
              fn: () => Navigator.pop(context),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "${item?.subtitle ?? 'unknown'}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => SvgPicture.asset(
                            "assets/images/banner_logo.svg",
                            height: 250,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    Text(
                      item?.title ?? "No Title Available",
                      style: t700_16.copyWith(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    verticalSpace(8),
                    Text(
                      item?.subtitle ?? "No Subtitle Available",
                      style: t400_16.copyWith(color: Colors.black),
                    ),
                    verticalSpace(16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                          child: ClipOval(
                            child: Image.network(
                              authorImageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                        horizontalSpace(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Author: ${item?.authorName ?? 'Unidentified Author'}",
                              style: t500_14.copyWith(color: Colors.black),
                            ),
                            Text(
                              "Date: ${item?.publishedDate ?? 'Unknown'}",
                              style: t500_14.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          item?.description ?? "No description available",
                          style: t400_14.copyWith(color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const CircleAvatar(
                          //   backgroundColor: Color(0xffEFDB93),
                          //   child: Icon(CupertinoIcons.hand_thumbsup,
                          //       color: Color(0xff705703)),
                          // ),
                          // horizontalSpace(16),
                          GestureDetector(
                            onTap: () async {
                              final String text =
                                  '''
${item.title}
${item.subtitle}

Author: ${item.authorName ?? "Unknown"}
Published On : ${item.publishedDate ?? "Unknown"}

\t${item.description}
''';

                              ShareService.shareTextWithImage(text, imageUrl);
                            },
                            child: const CircleAvatar(
                              // backgroundColor: Color(0xffEFDB93),
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                CupertinoIcons.share,
                                size: 24,
                                color: Color(0xff705703),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
