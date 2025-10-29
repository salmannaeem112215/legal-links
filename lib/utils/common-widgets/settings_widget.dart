// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../resources/resources.dart';
import '../hights_widths.dart';

class ScreenTileWidget extends StatelessWidget {
  final IconData iconVar;
  final String title;
  Color? color = R.colors.primary;
  Color? textColor;
  final VoidCallback? tap;
  ScreenTileWidget(
      {super.key,
      required this.iconVar,
      required this.title,
      required this.tap,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
          margin: EdgeInsets.only(bottom: 6.sp),
          decoration: BoxDecoration(
            border: Border.all(color: textColor ?? R.colors.transparent),
            borderRadius: BorderRadius.circular(10),
            color: R.colors.white,
            boxShadow: [
              BoxShadow(
                color: R.colors.grey.withOpacity(.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // height: 6.h,
          width: double.infinity,
          child: Row(
            children: [
              Icon(iconVar, size: 14.sp, color: color),
              w2,
              Text(title, style: R.textStyles.poppinsMedium(fontSize: 10, color: textColor)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14.sp, color: textColor ?? R.colors.primary)
            ],
          ),
        ),
      ),
    );
  }
}
