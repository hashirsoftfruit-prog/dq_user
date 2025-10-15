import 'package:dqapp/controller/routes/routnames.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/model/helper/service_locator.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class NewsAndTipsListScreen extends StatefulWidget {
  final String type;
  final List<News>? news;
  final List<Tip>? tips;
  const NewsAndTipsListScreen({
    super.key,
    required this.type,
    this.news,
    this.tips,
  });

  @override
  State<NewsAndTipsListScreen> createState() => _NewsAndTipsListScreenState();
}

class _NewsAndTipsListScreenState extends State<NewsAndTipsListScreen> {
  late final dynamic item;

  @override
  void initState() {
    super.initState();
    item = widget.type == "Tip" ? widget.tips : widget.news;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: getIt<SmallWidgets>().appBarWidget(
            title: widget.type,
            height: h10p,
            width: w10p,
            fn: () {
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: item.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.newsAndTips,
                      arguments: NewsAndTipsScreenArguments(
                        type: widget.type,
                        tip: widget.type == "Tip" ? item[index] : null,
                        news: widget.type == "News" ? item[index] : null,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 1),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          // height: h10p,
                          // width: w1p * 025,
                          // decoration: const BoxDecoration(
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(8),
                          //     bottomLeft: Radius.circular(8),
                          //   ),
                          // ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),

                          child: Image.network(
                            StringConstants.baseUrl + item[index].image,
                            fit: BoxFit.cover,
                            height: h10p,
                            width: w1p * 025,
                          ),
                        ),
                        horizontalSpace(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item[index].title,
                              style: t500_15.copyWith(color: Colors.black),
                            ),
                            if (item[index].publishedDate != null)
                              Text(
                                item[index].publishedDate ?? "",
                                style: t400_14.copyWith(color: Colors.grey),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    horizontalSpace(0),
                                    Text(
                                      item[index].authorName ?? "Unknown",
                                      style: t400_14.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
