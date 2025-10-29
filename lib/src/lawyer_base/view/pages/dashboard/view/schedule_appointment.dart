import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/resources/validator.dart';
import 'package:legal_links_app/services/date_picker/date_picker_services.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/vm/base_vm.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/model/lawyer_schedule_model.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/vm/lawyer_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/common-widgets/custom_textformfield.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:legal_links_app/utils/zbot_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleAppointmentView extends StatefulWidget {
  static String route = '/scheduleAppointment';
  const ScheduleAppointmentView({super.key});

  @override
  State<ScheduleAppointmentView> createState() =>
      _ScheduleAppointmentViewState();
}

class _ScheduleAppointmentViewState extends State<ScheduleAppointmentView> {
  DateTime? startTime;
  DateTime? endTime;
  int? selectedInterval;

  TextEditingController startTimeTC = TextEditingController();
  TextEditingController endTimeTC = TextEditingController();

  FocusNode startTimeFN = FocusNode();
  FocusNode endTimeFN = FocusNode();

  bool isOpened = true;
  List<int> intervalMinutes = [15, 30, 45, 60];

  DateRangePickerSelectionChangedArgs? dateRangeArgs;
  List<DateTime> dates = [];

  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  // LawyerScheduleModel? lawyerSch;

  @override
  void initState() {
    super.initState();
    initFN();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LawyerVM>(
      builder: (context, vm, _) {
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
                  color: R.colors.black,
                ),
              ),
              title: Text(
                'Schedule Appointment',
                style: R.textStyles.poppinsSemiBold(
                  color: R.colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 13.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h3,
                  Text(
                    'Select Days',
                    style: R.textStyles.poppinsSemiBold(
                        fontSize: 12, color: R.colors.black),
                  ),
                  h1,
                  InkWell(
                    onTap: () {
                      setState(() {
                        isOpened = !isOpened;
                      });
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(7.sp),
                      decoration: R.decoration.decoration(radius: 15),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeIn,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select date for consultation',
                                style: R.textStyles
                                    .poppinsSemiBold(color: R.colors.primary),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isOpened = !isOpened;
                                  });
                                },
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  isOpened
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded,
                                  color: R.colors.black,
                                  size: 25.sp,
                                ),
                              )
                            ],
                          ),
                          h1,
                          if (isOpened)
                            SfDateRangePicker(
                              headerStyle: DateRangePickerHeaderStyle(
                                  textStyle: R.textStyles
                                      .poppinsMedium(color: R.colors.black)),
                              rangeTextStyle: R.textStyles
                                  .poppinsRegular(color: R.colors.black),
                              selectionColor: R.colors.primary,
                              onSelectionChanged: (d) {
                                setState(
                                  () {
                                    dateRangeArgs = d;
                                    dates = dateRangeArgs?.value;
                                    debugPrint("dates $dates");
                                  },
                                );
                              },
                              enablePastDates: false,
                              controller: dateRangePickerController,
                              selectionMode:
                                  DateRangePickerSelectionMode.multiple,
                              // initialSelectedRange: PickerDateRange(
                              //   DateTime.now().subtract(const Duration(days: 4)),
                              //   DateTime.now().add(const Duration(days: 3)),
                              // ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  h1,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          fieldTitle: "Start Time",
                          hintText: 'Start Time',
                          focusNode: startTimeFN,
                          controller: startTimeTC,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.datetime,
                          validator: FieldValidator.validateEmpty,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          onTap: () async {
                            await DateTimePickerServices
                                .selectStartTimeFunction(
                                    context, startTimeTC, TimeOfDay.now());

                            debugPrint(
                                "${R.colors.greenPrint} ${startTimeTC.text.trim()} }");

                            DateFormat format = DateFormat("hh:mm a");

                            try {
                              startTime = format.parse(startTimeTC.text.trim());

                              debugPrint(
                                  "${R.colors.greenPrint} ${startTimeTC.text.trim()} |$startTime");
                            } catch (e) {
                              debugPrint("Error parsing time: $e");
                            }

                            setState(() {});
                          },
                        ),
                      ),
                      w2,
                      Expanded(
                        child: CustomTextFormField(
                          fieldTitle: "End Time",
                          hintText: 'End Time',
                          focusNode: endTimeFN,
                          controller: endTimeTC,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.datetime,
                          validator: FieldValidator.validateEmpty,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          onTap: () async {
                            await DateTimePickerServices.selectEndTimeFunction(
                                context, endTimeTC);
                            DateFormat format = DateFormat("hh:mm a");
                            try {
                              endTime = format.parse(endTimeTC.text.trim());
                              debugPrint(
                                  "${R.colors.greenPrint} ${endTimeTC.text.trim()} |$endTime");
                            } catch (e) {
                              debugPrint("Error parsing time: $e");
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  h1,
                  Text(
                    'Interval of meeting',
                    style: R.textStyles.poppinsMedium(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                  h1,
                  DropdownButtonFormField<int?>(
                    iconEnabledColor: R.colors.black,
                    iconDisabledColor: R.colors.black,
                    value: selectedInterval,
                    onChanged: (value) {
                      setState(() {
                        selectedInterval = value!;
                      });
                    },
                    items: intervalMinutes.map((interval) {
                      return DropdownMenuItem<int?>(
                        value: interval,
                        child: Text(
                          '$interval minutes',
                          style: R.textStyles
                              .poppinsRegular(color: R.colors.black),
                        ),
                      );
                    }).toList(),
                    decoration: R.decoration
                        .fieldDecoration(hintText: "Select Interval"),
                  ),
                  h1,
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
              child: CustomButton(
                buttonTitle: "Save",
                tap: () {
                  List<Timestamp> timestamplist =
                      dates.map((e) => Timestamp.fromDate(e)).toList();

                  if (startTime != null &&
                      endTime != null &&
                      timestamplist.isNotEmpty) {
                    Timestamp now = Timestamp.now();
                    Map body = {
                      "id": context.read<AuthVM>().userModel.id,
                      "availableDates": timestamplist,
                      "intervalMinutes": selectedInterval,
                      "startTime": Timestamp.fromDate(startTime!),
                      "endTime": Timestamp.fromDate(endTime!),
                    };
                    debugPrint("${R.colors.whitePrint}body $body");

                    LawyerScheduleModel model = LawyerScheduleModel(
                      availableDates: timestamplist,
                      intervalMinutes: selectedInterval,
                      officeStartTime: Timestamp.fromDate(startTime!),
                      officeEndTime: Timestamp.fromDate(endTime!),
                      lawyerId: context.read<AuthVM>().userModel.id,
                      createdAt: now,
                      updatedAt: now,
                      status: 0,
                    );
                    debugPrint(
                        "${R.colors.cyanPrint}model ${model.availableDates}");
                    debugPrint(
                        "${R.colors.cyanPrint}timestamplist $timestamplist");

                    vm.createSchedule(model);
                  } else {
                    ZBotToast.showToastError(
                        message: "Please Select Required Fields");
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void initFN() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var lvm = Provider.of<LawyerVM>(context, listen: false);
      var bvm = Provider.of<BaseVM>(context, listen: false);
      var avm = Provider.of<AuthVM>(context, listen: false);

      var vm = Provider.of<BaseVM>(context, listen: false);
      ZBotToast.loadingShow();

      await vm.getLawyerScheduleById(avm.userModel.id ?? '');
      debugPrint("lyrSchByID ${bvm.lyrSchByID?.availableDates}");

      if (bvm.lyrSchByID?.officeStartTime != null &&
          bvm.lyrSchByID?.intervalMinutes != null) {
        startTimeTC.text = DateFormat("hh:mm a").format(
            bvm.lyrSchByID?.officeStartTime?.toDate() ?? DateTime.now());
        endTimeTC.text = DateFormat("hh:mm a")
            .format(bvm.lyrSchByID?.officeEndTime?.toDate() ?? DateTime.now());
        selectedInterval = bvm.lyrSchByID?.intervalMinutes;

        List<DateTime> dl =
            bvm.lyrSchByID!.availableDates!.map((e) => e.toDate()).toList();

        dateRangePickerController.selectedDates = dl;
        DateFormat format = DateFormat("hh:mm a");

        try {
          startTime = format.parse(startTimeTC.text.trim());
          endTime = format.parse(endTimeTC.text.trim());
          debugPrint("${R.colors.greenPrint} |$startTime : $endTime");
        } catch (e) {
          debugPrint("Error parsing time: $e");
        }

        // dateRangeArgs = dl;
      }

      setState(() {});
      ZBotToast.loadingClose();
    });
  }
}
