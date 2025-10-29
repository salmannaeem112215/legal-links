// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/constants/global_functions.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/view/appointment_view.dart';
import 'package:legal_links_app/src/base/view/pages/dashboard.dart/view/home_view.dart';
import 'package:legal_links_app/src/base/view/pages/dashboard.dart/vm/home_vm.dart';
import 'package:legal_links_app/src/base/view/pages/settings/view/settings_view.dart';
import 'package:legal_links_app/src/base/vm/base_vm.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/common-widgets/call_confirmation.dart';

class BaseView extends StatefulWidget {
  static String route = "/base_view";
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  final List<String> _pageTitles = [
    'Home',
    'Appointment',
    'Settings',
  ];
  final List<String> _barTitles = [
    'Home',
    'Appointment',
    'Settings',
  ];

  final List<IconData> _unselectedIcons = [
    Icons.home_outlined,
    Icons.schedule_outlined,
    Icons.settings_outlined,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home_filled,
    Icons.schedule,
    Icons.settings,
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var baseVM = Provider.of<BaseVM>(context, listen: false);
      var homeVM = Provider.of<HomeVM>(context, listen: false);

      await Future.wait([
        baseVM.getAllLawyers(),
        homeVM.getChamberList(),
        homeVM.getCourtList(),
        homeVM.getLawFirmList(),
      ]);
      baseVM.update();
      homeVM.update();

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVM>(builder: (context, dashVM, _) {
      return Scaffold(
        appBar: baseAppBar(dashVM: dashVM, index: dashVM.currentIndex),
        body: WillPopScope(
          onWillPop: GlobalFunctions.onWillPop,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: _getPage(
                dashVM: dashVM,
                index: dashVM.currentIndex,
              )),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: R.colors.white,
          currentIndex: dashVM.currentIndex,
          onTap: (i) => _onTabTapped(vm: dashVM, index: i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: R.colors.primary,
          unselectedItemColor: R.colors.black,
          items: _buildNavBarItems(),
        ),
      );
    });
  }

  List<BottomNavigationBarItem> _buildNavBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < _pageTitles.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(_unselectedIcons[i], size: 22),
          label: _pageTitles[i],
          activeIcon: Icon(_selectedIcons[i], size: 22),
        ),
      );
    }
    return items;
  }

  void _onTabTapped({required int index, required BaseVM vm}) {
    setState(() {
      vm.currentIndex = index;
      vm.update();
    });
  }

  Widget _getPage({required int index, required BaseVM dashVM}) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const AppointmentView();
      case 2:
        return const SettingsView();
      default:
        return tempWidget(dashVM: dashVM);
    }
  }

  Center tempWidget({required BaseVM dashVM}) {
    return Center(
        child: Text(
      _pageTitles[dashVM.currentIndex],
      style: R.textStyles.poppinsRegular(
        color: R.colors.primary,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
    ));
  }

  AppBar baseAppBar({required int index, required BaseVM dashVM}) {
    return AppBar(
      backgroundColor: R.colors.primary,
      elevation: 0,
      leadingWidth: 150,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (dashVM.currentIndex == 0)
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    // var vm = Provider.of<BaseVM>(context, listen: false);
                    // var baseVM = Provider.of<BaseVM>(context, listen: false);
                    // var homeVM = Provider.of<HomeVM>(context, listen: false);
                    // await Future.wait([
                    //   baseVM.getAllLawyers(),
                    //   homeVM.getChamberList(),
                    //   homeVM.getCourtList(),
                    //   homeVM.getLawFirmList(),
                    // ]);
                    // setState(() {});
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: context.read<AuthVM>().userModel.profileImages?.first ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        height: 11.w,
                        width: 11.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: R.colors.white, width: 1),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, e) =>
                          SizedBox(height: 11.w, width: 11.w, child: const Icon(Icons.error)),
                      placeholder: (context, url) {
                        return Center(
                            child: SizedBox(
                          height: 11.w,
                          width: 11.w,
                          child:
                              CircularProgressIndicator.adaptive(backgroundColor: R.colors.primary),
                        ));
                      },
                    ),
                  ),
                ),
                w1,
                Text(
                  "Hello, ${context.read<AuthVM>().userModel.fullName?.capitalizeFirst}!",
                  style: R.textStyles.poppinsMedium(fontSize: 15, color: R.colors.white),
                ),
                w1,
              ],
            )
          else
            Text(
              _barTitles[dashVM.currentIndex],
              style: R.textStyles.poppinsRegular(
                color: R.colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index != 2)
                // IconButton(
                //   iconSize: 25,
                //   onPressed: () {
                //     // Get.to(() => const SearchView());
                //   },
                //   icon: Icon(
                //     Icons.search_rounded,
                //     color: R.colors.white,
                //   ),
                // ),
                IconButton(
                  iconSize: 25,
                  onPressed: () {
                    Get.dialog(const CallConfirmationDialog());
                  },
                  icon: Icon(
                    Icons.call,
                    color: R.colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
