import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:sizer/sizer.dart';

import '../../resources/resources.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime? selectDate;
  final TextEditingController? controller;
  const CustomDatePickerDialog({Key? key, this.selectDate, this.controller}) : super(key: key);

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: R.colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: R.textStyles.poppinsRegular(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: R.colors.primary,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.comfortable,
                      onPressed: () {
                        Get.back(result: null);
                      },
                      icon: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: R.colors.primary,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: R.textStyles.poppinsRegular(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: R.colors.primary,
                  ))),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumYear: 1950,
                    maximumYear: DateTime.now().year,
                    use24hFormat: false,
                    dateOrder: DatePickerDateOrder.dmy,
                    backgroundColor: CupertinoColors.white,
                    onDateTimeChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: Get.width,
                  height: 50,
                  child: CustomButton(
                      textColor: R.colors.white,
                      buttonTitle: 'Save',
                      tap: () {
                        if (_selectedDate != DateTime.now()) {
                          setState(() {
                            widget.controller?.text =
                                DateFormat('dd MMM, yyyy').format(_selectedDate);
                          });
                          Get.back(result: _selectedDate);
                        } else {
                          // Select Date of Birth Please
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
