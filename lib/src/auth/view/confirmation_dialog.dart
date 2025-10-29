import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/src/auth/view/lawyer_singup/lawyer_singup.dart';
import 'package:legal_links_app/src/auth/view/signup_screen.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/resources.dart';
import '../../../utils/common-widgets/custom_app_button.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({super.key});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: R.colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(7.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: R.colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.20),
                  offset: const Offset(-5, -2),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.20),
                  offset: const Offset(3, 3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: R.colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 16,
                        color: R.colors.black,
                      ),
                    ),
                  ),
                ),
                h1,
                Text(
                  "Create Account as:",
                  style: R.textStyles.poppinsMedium(
                    fontSize: 13,
                  ),
                ),
                h1,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: double.infinity,
                  child: AppButton(
                    verticlePadding: 12,
                    borderRadius: 10,
                    buttonTitle: 'Customer',
                    onTap: () {
                      context.read<AuthVM>().userRole = UserRole.CLIENT;
                      context.read<AuthVM>().update();
                      Get.toNamed(SignupScreen.route);
                      debugPrint("User Role: ${context.read<AuthVM>().userRole} ");
                    },
                  ),
                ),
                h1,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  width: double.infinity,
                  child: AppButton(
                    verticlePadding: 12,
                    borderRadius: 10,
                    buttonTitle: 'Lawyer',
                    onTap: () {
                      context.read<AuthVM>().userRole = UserRole.LAWYER;
                      context.read<AuthVM>().update();
                      Get.toNamed(LawyerSignupView.route);
                      debugPrint("User Role: ${context.read<AuthVM>().userRole} ");
                    },
                  ),
                ),
                h1,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
