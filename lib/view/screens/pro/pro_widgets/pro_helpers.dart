// tabListener() {
//     tabIndex = tabController.index;
//     // if (tabController.indexIsChanging) return;

//     final selectedKey = _tabKeys[tabIndex];
//     final context = selectedKey.currentContext;

//     if (context != null) {
//       print('context : $context');

//       final box = context.findRenderObject() as RenderBox;
//       final tabOffset = box.localToGlobal(Offset.zero);

//       // Get scroll container RenderBox
//       final scrollBoxContext = rowScntrol.position.context.notificationContext;
//       if (scrollBoxContext == null) return;
//       final scrollBox = scrollBoxContext.findRenderObject() as RenderBox;
//       final scrollOffset = scrollBox.localToGlobal(Offset.zero);

//       final relativeOffset = tabOffset.dx - scrollOffset.dx;
//       final targetScrollOffset = rowScntrol.offset + relativeOffset - (scrollBox.size.width / 2) + (box.size.width / 2);

//       rowScntrol.jumpTo(
//         targetScrollOffset.clamp(
//           rowScntrol.position.minScrollExtent,
//           rowScntrol.position.maxScrollExtent,
//         ),
//         // duration: const Duration(milliseconds: 500),
//         // curve: Curves.easeInOut,
//       );
//       // rowScntrol.animateTo(
//       //   targetScrollOffset.clamp(
//       //     rowScntrol.position.minScrollExtent,
//       //     rowScntrol.position.maxScrollExtent,
//       //   ),
//       //   duration: const Duration(milliseconds: 500),
//       //   curve: Curves.easeInOut,
//       // );
//     }
//     // rowScntrol.position.jumpTo(50);
//     // rowScntrol.position.animateTo((tabIndex * scCntrol.position.maxScrollExtent * 60), duration: const Duration(milliseconds: 100), curve: Curves.linear);
//     print('index changing : $tabIndex');
//     print('position changing : ${rowScntrol.position.pixels}');
//     if (mounted) setState(() {});
//   }

//         SingleChildScrollView(
//                         controller: rowScntrol,
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             AnimatedContainer(
//                               duration: const Duration(milliseconds: 500),
//                               height: h1p * 6,
//                               margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + h10p * 1.25 - (searchFixed ? h1p * 2 : 0)),
//                               child: TabBar(
//                                 // dividerColor: Colors.transparent,
//                                 indicatorColor: Colors.purple,
//                                 indicatorSize: TabBarIndicatorSize.label,
//                                 // indicator: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.red, width: 2))),
//                                 // indicatorPadding: EdgeInsets.only(top: 8),

//                                 indicatorWeight: 8,
//                                 controller: tabController,
//                                 physics: const ScrollPhysics(parent: RangeMaintainingScrollPhysics()),
//                                 isScrollable: true,
//                                 labelPadding: EdgeInsets.symmetric(horizontal: w1p * 1),
//                                 labelColor: tabIndex == 0 ? clr202020 : clrFFFFFF,
//                                 tabs: [
//                                   tabContainer(title: 'All', icon: Icons.home_filled, index: 0),
//                                   // GestureDetector(key: _tabKeys[1], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 1)),
//                                   // GestureDetector(key: _tabKeys[2], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 2)),
//                                   // GestureDetector(key: _tabKeys[3], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 3)),
//                                   // GestureDetector(key: _tabKeys[4], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 4)),
//                                   // GestureDetector(key: _tabKeys[5], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 5)),
//                                   // GestureDetector(key: _tabKeys[6], child: tabContainer(title: 'All', icon: Icons.home_filled, index: 6)),
//                                   tabContainer(title: 'Instant Consultation', icon: Icons.video_chat_rounded, index: 1),
//                                   tabContainer(title: 'Appointments', icon: Icons.note_alt_rounded, index: 2),
//                                   tabContainer(title: 'Counselling', icon: Icons.group_rounded, index: 3),
//                                   tabContainer(title: 'Pet Care', icon: Icons.pets_rounded, index: 4),
//                                   tabContainer(title: 'Ayurvedic', icon: Icons.health_and_safety, index: 5),
//                                   tabContainer(title: 'Homeopathic', icon: Icons.medication_rounded, index: 6),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

// AnimatedContainer(
//                         duration: const Duration(milliseconds: 100),
//                         width: maxWidth,
//                         height: MediaQuery.of(context).padding.top + h10p * 1.85 - (searchFixed ? h1p * 2 : 0),
//                         // height: h10p * 1.5,
//                         padding: EdgeInsets.only(bottom: h1p * 1),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(containerRadius / 2),
//                           color: searchFixed ? null : Colors.transparent,
//                           boxShadow: !searchFixed ? null : [boxShadow6],
//                           // gradient: LinearGradient(colors: appBarGradient(tabIndex), begin: Alignment.topCenter, end: Alignment.bottomCenter),
//                         ),
//                       ),
