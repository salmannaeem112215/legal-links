import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:sizer/sizer.dart';

import '../common-widgets/custom_button.dart';
import '../hights_widths.dart';

class AppBottomSheet extends StatefulWidget {
  final String? image;
  final String? title;
  final String? subtitle;
  final String? buttonLeft;
  final String? buttonRight;
  final Function()? onLeftTap;
  final Function()? onRightTap;
  final double? subtitleFontSize;
  final Color? leftButtonColor;
  final Color? rightButtonColor;

  const AppBottomSheet({
    Key? key,
    this.image,
    this.title,
    this.subtitle,
    this.buttonLeft,
    this.buttonRight,
    this.onLeftTap,
    this.onRightTap,
    this.subtitleFontSize,
    this.leftButtonColor,
    this.rightButtonColor,
  }) : super(key: key);

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(26), topLeft: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h2,
            Icon(
              Icons.help_center_outlined,
              size: 50.sp,
              color: R.colors.primary,
            ),
            h2,
            Text(
              widget.title ?? "",
              textAlign: TextAlign.center,
              style: R.textStyles.poppinsBold(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 2.h),
            Visibility(
              visible: widget.subtitle == null ? false : true,
              child: Text(
                widget.subtitle ?? '',
                textAlign: TextAlign.center,
                style: R.textStyles.poppinsRegular(
                  fontSize: 13,
                  color: R.colors.darkGrey,
                  letterSpacing: 0.45,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: CustomButton(
                    color: widget.leftButtonColor ?? R.colors.primary,
                    buttonTitle: widget.buttonLeft ?? "No",
                    tap: widget.onLeftTap ?? () => Get.back(),
                    textColor: R.colors.white,
                  )),
                  w2,
                  Expanded(
                      child: CustomButton(
                    color: widget.rightButtonColor ?? R.colors.red,
                    buttonTitle: widget.buttonRight ?? "Yes",
                    tap: widget.onRightTap ?? () {},
                    textColor: R.colors.white,
                  )),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ));
  }
}
