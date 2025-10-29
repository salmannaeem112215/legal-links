import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/services/google_map/address_model.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/dashboard.dart/view/widget/chamber_widget.dart';
import 'package:legal_links_app/src/base/vm/base_vm.dart';
import 'package:legal_links_app/utils/common-widgets/call_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../utils/hights_widths.dart';
import '../vm/home_vm.dart';
import 'all_lawyers_screen.dart';
import 'widget/court_widget.dart';
import 'widget/laywer_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFN = FocusNode();

  LatLng? latLng;
  PickLocationData? pickLocationData;
// is k solutiona read kro or try kro. ho jaye ga ok
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var vm = Provider.of<BaseVM>(context, listen: false);
      filteredLawyers = vm.lawyersList;
      vm.update();
      var baseVM = Provider.of<BaseVM>(context, listen: false);
      var homeVM = Provider.of<HomeVM>(context, listen: false);

      await Future.wait([
        baseVM.getAllLawyers(),
        homeVM.getChamberList(),
        homeVM.getCourtList(),
        homeVM.getLawFirmList(),
      ]);

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BaseVM, AuthVM>(builder: (context, vm, authVM, _) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // h1P5,
                      InkWell(
                        onTap: () {
                          Get.dialog(const CallConfirmationDialog());
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green[100],
                            // image: DecorationImage(
                            //   alignment: Alignment.topRight,
                            //   image: ,
                            // ),
                          ),
                          // mainAxisSize: MainAxisSize.min,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image.asset(
                                          //   R.images.instantLawyer,
                                          //   height: 6.h,
                                          // ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 2,
                                                child: Transform.rotate(
                                                  angle: 0.2,
                                                  child: const Icon(
                                                    Icons.flash_on_outlined,
                                                    color: Color(0xFFFFD700),
                                                  ),
                                                ),
                                              ),
                                              w2,
                                              Text(
                                                "Instant\nLawyer".toUpperCase(),
                                                style: R.textStyles
                                                    .poppinsSemiBold(),
                                              ),
                                            ],
                                          ),

                                          h0P4,
                                          SizedBox(
                                            width: 60.w,
                                            child: Text(
                                              // 'If you want to get direct service from legal links then call our helpline.',
                                              "If you want to get direct service from legal links then call our helpline.",
                                              style:
                                                  R.textStyles.poppinsRegular(
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Image.network(
                                  R.images.lawyer2,
                                  // alignment: Alignment.bottomCenter,
                                  // color: R.colors.red,
                                  width: 50.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      h1,
                      searchField(),
                      // h1,

                      viewAllWidget(isViewAll: true, "Lawyers", () {
                        Get.toNamed(AllLawyersScreen.route);
                      }),
                      // h1,
                      if (filteredLawyers.isEmpty)
                        const Center(child: Text("No Search Result"))
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              filteredLawyers.take(5).length,
                              (index) => LawyerWidget(
                                model: filteredLawyers.take(5).toList()[index],
                              ),
                            ),
                          ),
                        ),
                      // h0P7,
                      viewAllWidget("Chambers", () {}),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            context.read<HomeVM>().chamberList.length,
                            (index) => ChamberWidget(
                              model: context.read<HomeVM>().chamberList[index],
                            ),
                          ),
                        ),
                      ),
                      // h1,
                      viewAllWidget("Courts", () {}),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            context.read<HomeVM>().courtList.length,
                            (index) => CourtWidget(
                              model: context.read<HomeVM>().courtList[index],
                            ),
                          ),
                        ),
                      ),
                      // h1,
                      viewAllWidget("Law Firms", () {}),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            context.read<HomeVM>().lawFirmList.length,
                            (index) => ChamberWidget(
                              model: context.read<HomeVM>().lawFirmList[index],
                            ),
                          ),
                        ),
                      ),
                      // h1,

                      // viewAllWidget("Legal Links Users", () {}),
                      // h1,
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: List.generate(
                      //       context.read<HomeVM>().feedbackList.length,
                      //       (index) => FeedbackWidget(
                      //         model: context.read<HomeVM>().feedbackList[index],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                h2,
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget viewAllWidget(String title, Function() onPressed, {bool? isViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: R.textStyles
              .poppinsSemiBold(color: R.colors.black, fontSize: 14),
        ),
        if (isViewAll ?? false)
          TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            onPressed: onPressed,
            child: Text(
              'View All',
              style: R.textStyles
                  .poppinsRegular(
                    fontSize: 10,
                    color: R.colors.primary,
                  )
                  .copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
      ],
    );
  }

  Widget searchField() {
    return TextFormField(
      focusNode: searchFN,
      controller: searchController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        debugPrint('Search: $value');
        filterLawyers(value);
      },
      onTap: () {
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
      decoration: R.decoration.fieldDecoration(
        hintText: "Search by Lawyer",
        preIcon: Focus(
          focusNode: searchFN,
          child: Builder(builder: (context) {
            return Icon(
              Icons.search,
              color: searchFN.hasFocus ? R.colors.primary : Colors.red,
            );
          }),
        ),
        verticalPadding: 10,
      ),
    );
  }

  List<UserModel> filteredLawyers = [];

  void filterLawyers(String query) {
    List<UserModel> searchResult = [];
    if (query.isNotEmpty) {
      searchResult = context
          .read<BaseVM>()
          .lawyersList
          .where((lawyer) =>
              (lawyer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (lawyer.officeAdress?.streetAdress
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false))
          .toList();
    } else {
      searchResult = List.from(context.read<BaseVM>().lawyersList);
    }
    context.read<BaseVM>().update();

    setState(() {
      filteredLawyers = searchResult;
    });
  }

  // List<String> lawFirms = [
  //   'KPMG Taseer Hadi & Co.',
  //   'Orr, Dignam & Co.',
  //   'Haidermota & Co.',
  //   'Rasheed A. Razvi & Associates',
  //   'Rahmat Ali & Associates',
  //   'Raja Mohammed Akram & Co.',
  //   'Surridge and Beecheno',
  //   'ABS & Co.',
  //   'Mandviwalla & Zafar',
  //   'S & F Attorneys',
  // ];

  // Future<void> btnFun() async {
  //   for (String lawFirm in lawFirms) {
  //     debugPrint("lawFirm $lawFirm");

  //     Map<String, dynamic> body = {
  //       'id': Timestamp.now().microsecondsSinceEpoch.toString(),
  //       'image': 'https://cdn1.vectorstock.com/i/1000x1000/49/35/law-firm-logo-vector-29294935.jpg',
  //       'name': lawFirm,
  //       'status': 0,
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     };

  //     debugPrint("body $body");

  //     // FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // CollectionReference lawFirms = firestore.collection('chambers');
  //     await FBCollections.lawFirms.doc(Timestamp.now().microsecondsSinceEpoch.toString()).set(body);
  //   }
  // }
}
