// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback? tap;
  final Color? color;
  final Color? textColor;
  final Color? borderCOlor;
  const CustomButton(
      {super.key,
      required this.buttonTitle,
      required this.tap,
      this.color,
      this.textColor,
      this.borderCOlor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 9.sp, horizontal: 8)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        backgroundColor: MaterialStateProperty.all(color ?? R.colors.primary),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonTitle,
            style: R.textStyles
                .poppinsMedium()
                .copyWith(color: textColor ?? R.colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomButtonSearchView extends StatelessWidget {
  final String text;
  final Color textCol;
  final VoidCallback? tap;
  const CustomButtonSearchView(
      {super.key,
      required this.text,
      required this.textCol,
      required this.tap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: tap,
        child: Container(
          height: 45,
          width: 120,
          decoration: BoxDecoration(
              color: R.colors.primary, borderRadius: BorderRadius.circular(5)),
          child: Center(
              child: Text(
            text,
            style: R.textStyles.poppinsRegular().copyWith(color: textCol),
          )),
        ),
      ),
    );
  }
}
