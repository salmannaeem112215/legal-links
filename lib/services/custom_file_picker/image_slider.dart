// // ignore_for_file: library_private_types_in_public_api

// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart'  as CS;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:legal_links_app/services/custom_file_picker/image_view.dart';

// class ImageSlider extends StatefulWidget {
//   final int index;
//   final List<File> sliderList;

//   const ImageSlider({Key? key, required this.index, required this.sliderList}) : super(key: key);

//   @override
//   _ImageSliderState createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {
//   // CarouselController
//   CS.CarouselController carouselController = CS.CarouselController();
//   List<File> sortedImagesList = [];
//   @override
//   void initState() {
//     sortedImagesList = widget.sliderList
//         .where((element) =>
//             element.path.split(".").last.toString() == "png" ||
//             element.path.split(".").last.toString() == "jpg" ||
//             element.path.split(".").last.toString() == "jpeg")
//         .toList();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: Get.height * .2),
//       child: CS.CarouselSlider(
//           carouselController: carouselController,
//           options: CS.CarouselOptions(
//             aspectRatio: 10 / 12,
//             autoPlay: true,
//             initialPage: widget.index,
//             autoPlayInterval: const Duration(seconds: 4),
//             autoPlayAnimationDuration: const Duration(seconds: 1),
//             autoPlayCurve: Curves.fastOutSlowIn,
//             viewportFraction: 0.6,
//             enlargeCenterPage: true,
//           ),
//           items: sortedImagesList
//               .map((item) => ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.to(() => ImageView(
//                               path: item,
//                               isForSubmit: false,
//                             ));
//                       },
//                       child: Image.file(
//                         item,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ))
//               .toList()),
//     );
//   }
// }
