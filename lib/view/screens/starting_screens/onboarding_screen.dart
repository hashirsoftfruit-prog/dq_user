import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import 'login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<PageData> pages = [
    PageData(
      image: 'assets/images/onboard-image-1.png',
      title: 'Discover doctors tailored to your needs.',
      description:
          'Effortlessly find the perfect doctor for your symptoms. Our intelligent system helps you connect with specialists for precise and reliable care.',
    ),
    PageData(
      image: 'assets/images/onboard-image-2.png',
      title: 'Instant consultations, anytime, anywhere.',
      description:
          'Speak with doctors on your terms, whether through online chats or face-to-face visits. Experience quick access to expert healthcare wherever you are.',
    ),
    PageData(
      image: 'assets/images/onboard-image-3.png',
      title: 'Get prescriptions and medicines delivered.',
      description:
          'Receive digital prescriptions and order medications seamlessly. Have them delivered quickly to your doorstep for a hassle-free experience.',
    ),
  ];

  late String selectedImage;

  @override
  void initState() {
    super.initState();

    selectedImage = pages[0].image;
  }

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(navigateLogin(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Brightness.dark,
    //     statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark// Status bar color
    // ));
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        // double w1p = maxWidth * 0.01;
        return Scaffold(
          appBar: getIt<SmallWidgets>().logoAppBarWidget(),
          extendBody: true,
          extendBodyBehindAppBar: true,
          // backgroundColor:Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6C6EB8), Color(0xffFE9297)],
                begin: Alignment.centerRight,
                end: Alignment.topLeft,
              ),
            ),
            width: maxWidth,
            height: maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(30),
                AnimatedSwitcher(
                  switchInCurve: Curves.slowMiddle,
                  // switchOutCurve: Curves.bounceIn,
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    selectedImage,
                    key: ValueKey<String>(selectedImage),
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (s) {
                      setState(() {
                        selectedImage = pages[s].image;
                        _currentIndex = s;
                      });
                    },
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return PageViewItem(pageData: pages[index]);
                    },
                  ),
                ),
                verticalSpace(40),
                pad(
                  horizontal: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_currentIndex != pages.length - 1)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              navigateLogin(),
                              (route) => false,
                            );
                          },
                          child: AnimatedContainer(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(52),
                            ),
                            height: 40,
                            width: 110,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Skip', style: t500_18),
                            ),
                          ),
                        ),
                      // if (_currentIndex == pages.length - 1) const Spacer(),
                      InkWell(
                        onTap: _nextPage,
                        child: AnimatedContainer(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: clrFFFFFF,
                            borderRadius: BorderRadius.circular(52),
                          ),
                          height: 40,
                          width: _currentIndex == pages.length - 1 ? 240 : 100,
                          child: Center(
                            child: Text(
                              'Next',
                              style: t500_18.copyWith(
                                color: const Color(0xff3F429A),
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
          ),
        );
      },
    );
  }
}

class PageViewItem extends StatelessWidget {
  final PageData pageData;

  const PageViewItem({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        pad(
          horizontal: 30,
          child: Text(
            pageData.title,
            style: t400_22.copyWith(height: 1.1),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            pageData.description,
            textAlign: TextAlign.center,
            style: t400_14.copyWith(height: 1.28),
          ),
        ),
      ],
    );
  }
}

class PageData {
  final String image;
  final String title;
  final String description;

  PageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

Route navigateLogin() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
