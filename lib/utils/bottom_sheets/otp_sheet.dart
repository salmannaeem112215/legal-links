// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/validator.dart';
import '../hights_widths.dart';

import '../common-widgets/custom_button.dart';
import 'change_password_sheet.dart';

class OTPSheet extends StatefulWidget {
  String route = "/otpscreen";
  final String? email;
  final bool isEmail;
  final VoidCallback onTap;

  OTPSheet({Key? key, required this.email, required this.onTap, required this.isEmail})
      : super(key: key);

  @override
  State<OTPSheet> createState() => _OTPSheetState();
}

class _OTPSheetState extends State<OTPSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 59;
  final Timer _timer = Timer(const Duration(seconds: 0), () {});
  int currentSeconds = 0;
  String currentText = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimeout();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
      decoration: BoxDecoration(
        color: R.colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(26.0),
        ),
        boxShadow: [
          BoxShadow(
            color: R.colors.black.withOpacity(0.16),
            offset: const Offset(0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h2,
          Text(
            "Enter OTP",
            style: R.textStyles.poppinsBold(
              fontSize: 15,
            ),
          ),
          h2,
          (widget.isEmail)
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Enter the OTP code that you have received on your email address",
                      style: R.textStyles.poppinsRegular(
                        color: R.colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: " "),
                        TextSpan(
                          text: widget.email!
                              .replaceRange(2, widget.email!.split("@").first.length, "******"),
                          style: R.textStyles.poppinsRegular(
                            fontSize: 12,
                            color: R.colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Enter the OTP code that you have received on your phone number",
                      style: R.textStyles.poppinsRegular(
                        fontSize: 12,
                        color: R.colors.grey,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: " "),
                        TextSpan(
                          text: widget.email!,
                          style: R.textStyles.poppinsRegular(
                            fontSize: 12,
                            color: R.colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          if (widget.isEmail == false)
            Padding(
              padding: EdgeInsets.only(top: 2.h, bottom: 3.h),
              child: Text(
                "Change Number",
                style: R.textStyles
                    .poppinsRegular(
                        fontSize: 12, fontWeight: FontWeight.w500, color: R.colors.black)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          if (widget.isEmail == true) h3,
          Form(key: formKey, child: otpCodeWidget()),
          h3,
          CustomButton(buttonTitle: "Proceed", tap: () => onTapSubmitFN()),
          h2,
        ],
      ),
    );
  }

  Widget otpCodeWidget() {
    return Column(
      children: [
        PinCodeTextField(
          textStyle: R.textStyles
              .poppinsRegular()
              .copyWith(color: R.colors.black, fontWeight: FontWeight.w500, fontSize: 13),
          appContext: context,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: 30.sp,
              fieldWidth: 30.sp,
              errorBorderColor: R.colors.primary,
              inactiveColor: R.colors.grey,
              activeColor: R.colors.primary.withOpacity(.3),
              selectedColor: R.colors.primary.withOpacity(.3),
              selectedFillColor: R.colors.grey.withOpacity(.1),
              disabledColor: R.colors.primary,
              activeFillColor: R.colors.primary.withOpacity(.1),
              inactiveFillColor: R.colors.grey.withOpacity(.1)),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: R.colors.white,
          cursorColor: R.colors.primary,
          enableActiveFill: true,
          controller: textEditingController,
          keyboardType: TextInputType.number,
          validator: (value) => FieldValidator.validateOTP(textEditingController.text),
          onCompleted: (v) {},
          onChanged: (value) {
            setState(() {
              currentText = value;
            });
          },
          beforeTextPaste: (text) {
            return true;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code?",
              style: R.textStyles.poppinsRegular(fontSize: 12, color: R.colors.black),
            ),
            Text(' $timerText',
                style: R.textStyles.poppinsRegular(
                    fontSize: 14, color: R.colors.black, fontWeight: FontWeight.w600)),
          ],
        ),
        h1,
        GestureDetector(
          onTap: () async {
            if (currentSeconds == timerMaxSeconds) {
              startTimeout();
            }
          },
          child: Text('Resend?',
              style: R.textStyles
                  .poppinsBold(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: currentSeconds == timerMaxSeconds ? R.colors.primary : R.colors.black,
                  )
                  .copyWith(decoration: TextDecoration.underline)),
        )
      ],
    );
  }

  void onTapSubmitFN() {
    if (formKey.currentState!.validate()) {
      Get.back();
      Get.bottomSheet(
        const ChangePasswordSheet(),
        isScrollControlled: true,
      );
    }
  }

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  void startTimeout() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      currentSeconds = timer.tick;
      if (timer.tick >= timerMaxSeconds) timer.cancel();
      setState(() {});
    });
  }

  void stopTimeout() {
    //_timer.cancel();
    setState(() {});
  }
}
