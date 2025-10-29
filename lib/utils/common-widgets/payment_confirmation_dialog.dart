import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/model/booking_model.dart';
import 'package:legal_links_app/src/base/view/pages/settings/model/content_model.dart';
import 'package:legal_links_app/src/base/vm/base_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:legal_links_app/utils/zbot_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final PaymentMethod? model;
  const PaymentConfirmationDialog({super.key, this.model});

  @override
  State<PaymentConfirmationDialog> createState() => _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  File? paymentImage;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(
      builder: (context, authVm, _) {
        return Scaffold(
          backgroundColor: R.colors.transparent,
          body: Center(
              child: Container(
            padding: EdgeInsets.all(8.sp),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: R.colors.red.withOpacity(.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: R.colors.red,
                      ),
                    ),
                  ),
                ),
                h2,
                Text(
                  widget.model?.providerName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: R.textStyles.poppinsSemiBold(fontSize: 13.sp, color: R.colors.black),
                ),
                h2,
                Center(child: pickImageWidget(authVm)),
                h3,
                CustomButton(
                  buttonTitle: "Save",
                  tap: () async {
                    if (paymentImage == null) {
                      ZBotToast.showToastError(message: "Please upload Image!");
                    } else {
                      ZBotToast.loadingShow();
                      BaseVM vm = Provider.of<BaseVM>(context, listen: false);
                      AuthVM aVm = Provider.of<AuthVM>(context, listen: false);
                      String? imageUrl = await vm.uploadImageUserInSupabase(paymentImage!,
                          '${vm.tempBookingModel?.id}', '${vm.tempBookingModel?.customerId}');
                      if (imageUrl?.isNotEmpty ?? false) {
                        vm.tempBookingModel = BookingModel(
                          id: vm.tempBookingModel?.id,
                          lawyerId: vm.tempBookingModel?.lawyerId,
                          customerId: vm.tempBookingModel?.customerId,
                          status: vm.tempBookingModel?.status, //Scheduled
                          createdAt: Timestamp.now(),
                          updatedAt: Timestamp.now(),
                          lawyerScheduleId: vm.tempBookingModel?.lawyerId,
                          selectedDate: vm.tempBookingModel?.selectedDate,
                          timeSlot: vm.tempBookingModel?.timeSlot,
                          lawyerName: vm.tempBookingModel?.lawyerName,
                          lawyerImage: vm.tempBookingModel?.lawyerImage,
                          customerName: aVm.userModel.fullName,
                          officeLocation: vm.tempBookingModel?.officeLocation,
                          feePerMeeting: vm.tempBookingModel?.feePerMeeting,
                          customerImage: vm.tempBookingModel?.customerImage,
                          accountNumber: widget.model?.accountNumber,
                          pName: widget.model?.providerName,
                          paymentId: Timestamp.now().microsecondsSinceEpoch.toString(),
                          paymentProviderLogo: widget.model?.image,
                          paymentImage: imageUrl,
                          paymentStatus: 0,
                          userName: widget.model?.userName,
                        );

                        bool p = await vm.createBookings(vm.tempBookingModel!);
                        if (p) {
                          vm.tempBookingModel = null;
                          ZBotToast.loadingClose();
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Widget pickImageWidget(AuthVM vm) {
    return Column(
      children: [
        if (paymentImage == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () async {
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  paymentImage = File(pickedFile.path);
                }

                // Navigator.pop(context);

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: R.colors.primary),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(4.sp),
                margin: EdgeInsets.all(12.sp),
                child: Icon(
                  Icons.add,
                  size: 25.sp,
                  color: R.colors.primary,
                ),
              ),
            ),
          )
        else
          Image.file(
            paymentImage!,
            width: 100.w,
            height: 60.h,
          ),
        // if (isPhotoPicked ?? false) const Divider(color: Colors.grey),
        // if (isPhotoPicked ?? false)
        if (paymentImage != null)
          InkWell(
            onTap: () {
              paymentImage = null;
              debugPrint("paymentImage $paymentImage");
              setState(() {});
            },
            child: Row(children: [
              const Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: Get.width * .03),
              Text(
                "Remove Photo",
                style: R.textStyles.poppinsMedium(
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              )
            ]),
          ),
      ],
    );
  }
}
