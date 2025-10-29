import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/model/booking_model.dart';
import 'package:legal_links_app/utils/common-widgets/call_confirmation.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/hights_widths.dart';
import '../../settings/view/widgets/custom_data_widget.dart';

class AppointmentDetails extends StatefulWidget {
  static String route = '/appointmentdetails';
  const AppointmentDetails({super.key});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  dynamic args;
  BookingModel? model;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        if (args['model'] != null) {
          model = args['model'];
        }
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: R.colors.white,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: R.colors.primary,
                )),
            title: Center(
              child: Text(
                'Appointment Details',
                style: R.textStyles.poppinsSemiBold(color: R.colors.primary),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.dialog(const CallConfirmationDialog());
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 10.sp),
                  margin:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 12.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: R.colors.red,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 10.sp,
                      ),
                      w2,
                      Text(
                        "Help",
                        style: R.textStyles.poppinsMedium(
                          fontSize: 9,
                          color: R.colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 15.sp),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: getColorForBookingStatus(model?.status),
                      ),
                      borderRadius: BorderRadius.circular(10.sp),
                      boxShadow: [
                        BoxShadow(
                          color: R.colors.grey.withOpacity(.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Your Appointment ID',
                              style: R.textStyles.poppinsSemiBold()),
                          h1,
                          Text(
                            "${model?.id.toString()}",
                            style: R.textStyles.poppinsSemiBold(
                                color: R.colors.primary, fontSize: 15),
                          ),
                          h1,
                          if (model?.selectedDate != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: R.colors.primary,
                                  size: 11,
                                ),
                                Text(
                                  DateFormat(" MMMM dd, yyyy").format(
                                      model?.selectedDate?.toDate() ??
                                          DateTime.now()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles.poppinsMedium(
                                      fontSize: 12, color: R.colors.primary),
                                ),
                                Text(
                                  "  |  ",
                                  style: R.textStyles.poppinsMedium(
                                      fontSize: 12, color: R.colors.grey),
                                ),
                                Text(
                                  DateFormat("hh:mm a").format(
                                      model?.timeSlot?.toDate() ??
                                          DateTime.now()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles.poppinsMedium(
                                      fontSize: 12, color: R.colors.primary),
                                )
                              ],
                            ),
                          h1,
                          CustomData(
                              title: 'Customer:',
                              subTitle: '${model?.customerName}'),
                          CustomData(
                              title: 'Laywer:',
                              subTitle: '${model?.lawyerName}'),
                          CustomData(
                              title: 'Address:',
                              subTitle: '${model?.officeLocation}'),
                          CustomData(
                              title: 'Date:',
                              subTitle: DateFormat("MMMM dd, yyyy").format(
                                  model?.selectedDate?.toDate() ??
                                      DateTime.now())),
                          CustomData(
                            title: 'Status:',
                            subTitle: bookingStatusEnum(model?.status),
                            color: getColorForBookingStatus(model?.status),
                          ),
                          CustomData(
                              title: 'Payment:',
                              subTitle:
                                  '${model?.feePerMeeting?.toStringAsFixed(2)}'),
                        ]),
                  ),
                ),
                h1,
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Total:',
                          style: R.textStyles.poppinsMedium(
                            fontSize: 12,
                            color: R.colors.primary,
                            letterSpacing: 0.45,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          '${model?.feePerMeeting}',
                          style: R.textStyles.poppinsBold(
                            color: R.colors.black,
                            letterSpacing: 0.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
