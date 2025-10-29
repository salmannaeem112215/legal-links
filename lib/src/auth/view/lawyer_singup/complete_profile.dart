import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/src/lawyer_base/view/lawyer_base_view.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/hights_widths.dart';

class CompleteProfile extends StatefulWidget {
  static String route = '/completeProfile';
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 30.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundColor: R.colors.primary,
              child: Icon(
                Icons.check,
                size: 30.sp,
                weight: 20.sp,
              ),
            ),
            h3,
            Text(
              'You have successfully created your profile on Legal Links',
              textAlign: TextAlign.center,
              style: R.textStyles.poppinsSemiBold(color: R.colors.primary, fontSize: 17),
            ),
            h3,
            Text(
              'It is pending for verification & once done, we will notify you here on this app.',
              textAlign: TextAlign.center,
              style: R.textStyles.poppinsMedium(color: R.colors.red),
            ),
            h3,
            CustomButton(
              buttonTitle: 'Continue to your dashboard',
              tap: () {
                Get.toNamed(LawyerBaseView.route);
              },
            )
          ],
        ),
      ),
    ));
  }
}
