// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../resources/validator.dart';
import '../common-widgets/custom_button.dart';
import '../common-widgets/custom_textformfield.dart';
import '../hights_widths.dart';
import 'congragulations_sheet.dart';

class UpdatePasswordSheet extends StatefulWidget {
  const UpdatePasswordSheet({super.key});

  @override
  State<UpdatePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<UpdatePasswordSheet> {
  FocusNode passwordFocus = FocusNode();

  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode oldPasswordFocus = FocusNode();

  bool ispObscure = false;

  bool isObscure2 = false;
  bool oldPassObs = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, vm, _) {
      return Container(
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
        width: 100.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                h1,
                Text(
                  'Change Password',
                  style: R.textStyles
                      .poppinsBold(color: R.colors.black, fontSize: 15),
                ),
                h2,
                Text(
                  'Must include letter number and symbols.',
                  style: R.textStyles.poppinsRegular(color: R.colors.black),
                ),
                h2,
                CustomTextFormField(
                  controller: oldPasswordController,
                  focusNode: oldPasswordFocus,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.visiblePassword,
                  validator: FieldValidator.validateOldPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: 'Old password',
                  fieldTitle: "Old Password",
                  obscureText: oldPassObs,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        oldPassObs = !oldPassObs;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.sp),
                      child: Icon(
                        oldPassObs
                            ? Icons.visibility_off_rounded
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
                CustomTextFormField(
                  controller: newPasswordController,
                  focusNode: passwordFocus,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.visiblePassword,
                  validator: FieldValidator.validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: 'Enter new password',
                  fieldTitle: "Password",
                  obscureText: ispObscure,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        ispObscure = !ispObscure;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.sp),
                      child: Icon(
                        ispObscure
                            ? Icons.visibility_off_rounded
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
                CustomTextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  validator: (val) => FieldValidator.validatePasswordMatch(
                      newPasswordController.text,
                      confirmPasswordController.text),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: 'Re-enter new password',
                  fieldTitle: "Confirm Password",
                  obscureText: isObscure2,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure2 = !isObscure2;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.sp),
                      child: Icon(
                        isObscure2
                            ? Icons.visibility_off_rounded
                            : Icons.remove_red_eye_rounded,
                        color: Colors.grey,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
                h3,
                CustomButton(
                  buttonTitle: "Proceed",
                  tap: () async {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                      await changePassword(vm);
                      Get.bottomSheet(
                        CongratulationsSheet(
                          onApprove: () {
                            Get.back();
                          },
                          subTitle:
                              'Your password has been updated successfully.',
                        ),
                        isScrollControlled: true,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> changePassword(AuthVM vm) async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthVM>().changePassword(
            oldPasswordController.text.trim(),
            newPasswordController.text.trim(),
          );

      // Get.offAllNamed(BaseView.route);
    }
  }
}
