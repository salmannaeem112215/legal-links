import 'package:flutter/material.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:sizer/sizer.dart';

class AppDecoration {
  InputDecoration fieldDecoration(
      {Widget? preIcon,
      String? hintText,
      Widget? suffixIcon,
      double? radius,
      double? iconMinWidth,
      double? verticalPadding,
      Color? fillColor}) {
    return InputDecoration(
      // verticalPadding
      prefixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      isDense: true,
      fillColor: R.colors.primary.withOpacity(.05),
      filled: true,
      focusColor: R.colors.primary,

      hintText: hintText ?? "Select",
      // contentPadding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 12),
      suffixIcon: suffixIcon != null ? Container(child: suffixIcon) : null,

      hintStyle: R.textStyles.poppinsRegular(fontSize: 11, color: Colors.grey),
      errorStyle: R.textStyles.poppinsRegular(fontSize: 9, color: R.colors.red),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: R.colors.primary), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: R.colors.primary), borderRadius: BorderRadius.circular(8)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: R.colors.red), borderRadius: BorderRadius.circular(8)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: R.colors.red), borderRadius: BorderRadius.circular(8)),
    );
  }

  BoxDecoration decoration({double? radius}) {
    return BoxDecoration(
      color: R.colors.white,
      borderRadius: BorderRadius.circular(radius ?? 8),
      boxShadow: [
        BoxShadow(
          color: R.colors.black.withOpacity(0.1),
          offset: const Offset(-1, -1),
          blurRadius: 6,
        ),
        BoxShadow(
          color: R.colors.black.withOpacity(0.1),
          offset: const Offset(1, 1),
          blurRadius: 6,
        ),
      ],
    );
  }
}
