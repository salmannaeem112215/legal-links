import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/model/booking_model.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/view/appointment_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../../resources/resources.dart';
import '../../../../../../../utils/hights_widths.dart';

// ignore: must_be_immutable
class AppointmentWidget extends StatefulWidget {
  BookingModel model;
  AppointmentWidget({super.key, required this.model});

  @override
  State<AppointmentWidget> createState() => _AppointmentWidgetState();
}

class _AppointmentWidgetState extends State<AppointmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, vm, _) {
      return GestureDetector(
        onTap: () {
          visitProfileFn();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 6.sp),
          child: Container(
            padding: EdgeInsets.all(7.sp),
            decoration: BoxDecoration(
              border: Border.all(color: getColorForBookingStatus(widget.model.status)),
              color: getColorForBookingStatus(widget.model.status).withOpacity(.05),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: vm.userModel.role == UserRole.LAWYER
                            ? widget.model.customerImage ?? ""
                            : widget.model.lawyerImage ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 14.w,
                          width: 14.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: R.colors.white, width: 1),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, e) =>
                            SizedBox(height: 14.w, width: 14.w, child: const Icon(Icons.error)),
                        placeholder: (context, url) {
                          return Center(
                              child: SizedBox(
                            height: 14.w,
                            width: 14.w,
                            child: CircularProgressIndicator.adaptive(
                                backgroundColor: R.colors.primary),
                          ));
                        },
                      ),
                    ),
                    w3,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vm.userModel.role == UserRole.LAWYER
                                    ? widget.model.customerName ?? ""
                                    : widget.model.lawyerName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles
                                    .poppinsSemiBold(fontSize: 11, color: R.colors.black),
                              ),
                              Text(
                                bookingStatusEnum(widget.model.status!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles.poppinsMedium(
                                  fontSize: 11,
                                  color: getColorForBookingStatus(widget.model.status),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vm.userModel.role == UserRole.LAWYER
                                    ? widget.model.lawyerName ?? ""
                                    : widget.model.customerName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles
                                    .poppinsRegular(fontSize: 10, color: R.colors.primary),
                              ),
                              Text(
                                widget.model.feePerMeeting?.toStringAsFixed(2) ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles
                                    .poppinsRegular(fontSize: 10, color: Colors.blue[900]),
                              ),
                            ],
                          ),
                          Text(
                            widget.model.officeLocation ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: R.textStyles
                                .poppinsRegular(fontSize: 10, color: R.colors.primary),
                          ),
                          h2,
                          if (widget.model.selectedDate != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: R.colors.primary,
                                  size: 11.sp,
                                ),
                                Text(
                                  DateFormat(" MMMM dd, yyyy")
                                      .format(widget.model.selectedDate!.toDate()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles
                                      .poppinsRegular(fontSize: 10, color: R.colors.primary),
                                ),
                                Text(
                                  "  |  ",
                                  style: R.textStyles
                                      .poppinsRegular(fontSize: 10, color: R.colors.grey),
                                ),
                                Text(
                                  DateFormat("hh:mm a")
                                      .format(widget.model.timeSlot?.toDate() ?? DateTime.now()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles
                                      .poppinsRegular(fontSize: 10, color: R.colors.primary),
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  ]),
                ]),
          ),
        ),
      );
    });
  }

  void visitProfileFn() {
    debugPrint('model: ${widget.model}');
    Get.toNamed(AppointmentDetails.route, arguments: {"model": widget.model});
  }
}
