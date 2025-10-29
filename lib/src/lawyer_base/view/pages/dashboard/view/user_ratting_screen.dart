import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/view/widget/user_review_widget.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../vm/lawyer_vm.dart';

class UserRattingView extends StatefulWidget {
  static String route = '/userRatting';

  const UserRattingView({super.key});

  @override
  State<UserRattingView> createState() => _UserRattingViewState();
}

class _UserRattingViewState extends State<UserRattingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: R.colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: R.colors.primary,
            )),
        title: Text(
          'User Reviews',
          style: R.textStyles
              .poppinsSemiBold(color: R.colors.primary, fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 13.sp),
        child: Column(
          children: [
            h2,
            ...List.generate(
              context.read<LawyerVM>().userreviewsList.length,
              (index) => UserReviewsWidget(
                model: context.read<LawyerVM>().userreviewsList[index],
              ),
            ),
            h1,
          ],
        ),
      ),
    ));
  }
}
