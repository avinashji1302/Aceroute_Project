// import 'package:ace_routes/core/Constants.dart';
// import 'package:ace_routes/core/colors/Constants.dart';
// import 'package:ace_routes/view/appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../controller/fontSizeController.dart';
//
// class PartDetailScreen extends StatefulWidget {
//   final String? category;
//   final String sku;
//   final String quantity;
//
//   const PartDetailScreen({
//     Key? key,
//     required this.category,
//     required this.sku,
//     required this.quantity,
//   }) : super(key: key);
//
//   @override
//   State<PartDetailScreen> createState() => _PartDetailScreenState();
// }
//
// class _PartDetailScreenState extends State<PartDetailScreen> {
//   final fontSizeController = Get.find<FontSizeController>();
//
//   @override
//   Widget build(BuildContext context) {
//     AllTerms.getTerm();
//     return Scaffold(
//         appBar:myAppBar(context: context, titleText: AllTerms.detailsLabel, backgroundColor:MyColors.blueColor ),
//       body: Container(
//         width: double.infinity,
//         height: 100.0,
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Category: ${widget.category ?? "Not Selected"}',
//                   style: TextStyle(fontSize: fontSizeController.fontSize),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'SKU: ${widget.sku}',
//                   style: TextStyle(fontSize: fontSizeController.fontSize),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Quantity: ${widget.quantity}',
//                   style: TextStyle(fontSize: fontSizeController.fontSize),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
