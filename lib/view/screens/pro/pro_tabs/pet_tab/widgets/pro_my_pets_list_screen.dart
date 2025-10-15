// import 'package:dqapp/view/theme/text_styles.dart';
// import 'package:flutter/material.dart';

// class MyPetsScreen extends StatelessWidget {
//   const MyPetsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 80,
//         leading: const InkWell(
//             child: Icon(
//           Icons.arrow_back_ios,
//         )),
//         backgroundColor: const Color(0xffFFDDF2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 0,
//         title: Row(
//           children: [
//             Text(
//               "My pets",
//               style: t700_16.copyWith(color: Colors.black),
//             ),
//             const SizedBox(width: 4),
//             const Icon(Icons.pets, color: Color(0xffF950B8)),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: GridView.builder(
//                 itemCount: 4, // adjust as needed
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemBuilder: (context, index) {
//                   return _buildPetCard();
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 24, right: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.add, size: 20),
//                   label: const Text("Add your pet"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF3B3EA8),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPetCard() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               'https://i.imgur.com/BoN9kdC.png', // Replace with your image
//               height: 100,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Jimmy",
//             style: t700_16.copyWith(color: Colors.black),
//           ),
//           Text(
//             "Species: Dog",
//             style: t500_14.copyWith(color: Colors.black54),
//           ),
//           Text(
//             "male  ·  1.5 year old",
//             style: t400_13.copyWith(color: Colors.black38),
//           ),
//           // const SizedBox(height: 4),
//           // Text(
//           //   "Species: Dog",
//           //   style: t400_13.copyWith(color: Colors.black38),
//           // ),
//         ],
//       ),
//     );
//   }
// }
