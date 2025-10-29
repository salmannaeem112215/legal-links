import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/view/appointment_view.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/view/schedule_appointment.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/view/user_ratting_screen.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class LawyerHomeView extends StatefulWidget {
  static String route = '/lawyerHomeView';
  const LawyerHomeView({super.key});

  @override
  State<LawyerHomeView> createState() => _LawyerHomeViewState();
}

class _LawyerHomeViewState extends State<LawyerHomeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(
      builder: (context, vm, _) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h2,
                  Text(
                    'Hello, ${vm.userModel.fullName}!',
                    style: R.textStyles.poppinsBold(fontSize: 15),
                  ),
                  Text(
                    'Elevate Your practice with Legal Links',
                    style: R.textStyles.poppinsRegular(),
                  ),
                  h2,
                  Container(
                    padding: EdgeInsets.all(15.sp),
                    decoration: R.decoration.decoration(radius: 12),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: lawyerWidget(
                                Icons.meeting_room,
                                'In office',
                                () {
                                  Get.toNamed(AppointmentView.route);
                                },
                              ),
                            ),
                            w2,
                            Expanded(
                              child: lawyerWidget(
                                Icons.schedule_rounded,
                                'Schedule',
                                () {
                                  Get.toNamed(ScheduleAppointmentView.route);
                                },
                              ),
                            ),
                          ],
                        ),
                        h2,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: lawyerWidget(
                                Icons.share_rounded,
                                'Refer a lawyer',
                                () async {
                                  debugPrint('click');
                                  await Share.share(
                                    'Check out this amazing lawyer on Legal Links!',
                                    subject: 'Legal Links Lawyer Referral',
                                  );
                                },
                              ),
                            ),
                            w2,
                            Expanded(
                              child: lawyerWidget(
                                Icons.reviews,
                                'Reviews',
                                () {
                                  Get.toNamed(UserRattingView.route);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  h1,
                  Text(
                    'Whats New in the Lawyer industory?',
                    style: R.textStyles.poppinsMedium(),
                  ),
                  h1,
                  Container(
                    padding: EdgeInsets.all(15.sp),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          R.colors.primary,
                          R.colors.primary,
                          R.colors.primary,
                          R.colors.champagne,
                        ],
                      ),
                      // border: Border.all(color: R.colors.champagne),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: R.colors.black.withOpacity(.3),
                          offset: const Offset(-1, -1),
                          blurRadius: 1,
                        ),
                        BoxShadow(
                          color: R.colors.black.withOpacity(.2),
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay Curious, Stay Informed',
                          style: R.textStyles.poppinsSemiBold(color: R.colors.white),
                        ),
                        h1,
                        Text(
                          'Tap the banner to access the latest healthcare industory updates',
                          style: R.textStyles.poppinsRegular(color: R.colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget lawyerWidget(var iconName, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        // width: 35.w,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: R.colors.grey.withOpacity(.6),
                border: Border.all(color: R.colors.primary),
              ),
              child: Icon(iconName, color: R.colors.primary),
            ),
            h1,
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: R.textStyles.poppinsRegular(),
            )
          ],
        ),
      ),
    );
  }
}
